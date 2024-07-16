import SwiftUI
import CoreBluetooth
import AVFoundation
import LocalAuthentication

enum ReaderState {
    case idle
    case scanningQRCode
    case connecting
    case receiving
    case complete(EVRCData)
    case error
}

class ReaderViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var state: ReaderState = .idle
    
    private var centralManager: CBCentralManager!
    private var discoveredPeripheral: CBPeripheral?
    
    var uuid = ""
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        transition(to: .scanningQRCode)
    }
    
    func terminate() {
        centralManager = nil
        discoveredPeripheral = nil
    }

    private func transition(to newState: ReaderState) {
        state = newState
        switch newState {
        case .idle:
            break
        case .scanningQRCode:
            break
        case .connecting:
            break
        case .receiving:
            break
        case .complete:
            break
        case .error:
            terminate()
        }
    }
    
    func scanQRCode(result: String) {
        uuid = result
        startBLEConnection(result: result)
    }

    private func startBLEConnection(result: String) {
        print("scanning for service \(result)")
        centralManager.scanForPeripherals(withServices: [CBUUID(string: result)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: false)])
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Central is powered on")
        } else {
            print("Central is not powered on")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "unknown device") at \(RSSI). Trying to connect.")
        if discoveredPeripheral == nil {
            discoveredPeripheral = peripheral
            centralManager.stopScan()
            print("Stopped scanning. Attempting to connect to \(peripheral.name ?? "unknown device").")
            centralManager.connect(peripheral, options: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: uuid)])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral) with error: \(error?.localizedDescription ?? "none")")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        print("Services discovered: \(peripheral.services?.map { $0.uuid.uuidString } ?? [])")
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([CBUUID(string: "0A2C8BFC-FC3E-4429-B51D-A66B361CC439")], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        print("Characteristics discovered for service \(service.uuid): \(service.characteristics?.map { $0.uuid.uuidString } ?? [])")
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUID(string: "0A2C8BFC-FC3E-4429-B51D-A66B361CC439") {
                    // Discover characteristic properties, subscribe if notifications are supported
                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    } else {
                        print("Notification not supported for this characteristic")
                    }
                    // Sending "START" message if characteristic is writable
                    if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                        let startMessage = "START".data(using: .utf8)!
                        peripheral.writeValue(startMessage, for: characteristic, type: .withResponse)
                    }
                    transition(to: .receiving)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Should be receiving data here")
        
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            guard let decoded = try? JSONDecoder().decode(EVRCData.self, from: data) else {
                state = .error
                return
            }
            state = .complete(decoded)
        }
    }
}
