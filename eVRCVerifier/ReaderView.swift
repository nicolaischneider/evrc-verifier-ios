//
//  ReaderView.swift
//  EVRCReader
//
//  Created by Nicolai Schneider on 29.05.24.
//

import SwiftUI

struct ReaderView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ReaderViewModel()

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .idle:
                    Text("Initializing...")
                case .scanningQRCode:
                    VStack {
                        Text("Scanning for QR Code...")
                        QRCodeScannerView { result in
                            switch result {
                            case .success(let code):
                                viewModel.scanQRCode(result: code)
                            case .failure(let error):
                                print("Scanning failed: \(error.localizedDescription)")
                            }
                        }
                        .cornerRadius(10)
                        .padding()
                    }
                case .connecting:
                    Text("Connecting to BLE...")
                case .receiving:
                    VStack {
                        ProgressView("Receiving Data...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Text("Please wait while the data is being received.")
                    }
                case .complete(let eVRC):
                    SuccessView(vehicle: eVRC)
                case .error:
                    Text("Something went wrong.")
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Quit") {
                        dismissAndEndBLE()
                    }
                }
            }
        }
    }
    
    func dismissAndEndBLE() {
        viewModel.terminate()
        dismiss()
    }
}

#Preview {
    ReaderView()
}
