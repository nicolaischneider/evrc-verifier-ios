import Foundation

struct Validity: Codable, Equatable {
    var validFrom: Date
    var validUntil: Date
}

struct EVRCData: Codable, Identifiable, Equatable {
    
    var id = UUID()
    
    var licensePlateNumber: String
    var brand: String
    var vehicleType: String
    var vehicleIdentificationNumber: String
    var vehicleOwnerName: String
    var vehicleOwnerFirstnames: String
    var vehicleOwnerAddress: String
    var vehicleCategory: String
    var issueDate: String
    var issuingCountry: String
    var issuingAuthority: String
    
    var validity: Validity?
    
    var isSharedInstance: Bool
    var sharedInstances: [SharedInstance]
    
    init(id: UUID = UUID(), licensePlateNumber: String, brand: String, vehicleType: String, vehicleIdentificationNumber: String, vehicleOwnerName: String, vehicleOwnerFirstnames: String, vehicleOwnerAddress: String, vehicleCategory: String, issueDate: String, issuingCountry: String, issuingAuthority: String, isSharedInstance: Bool, sharedInstances: [SharedInstance], validity: Validity?) {
        self.id = id
        self.licensePlateNumber = licensePlateNumber
        self.brand = brand
        self.vehicleType = vehicleType
        self.vehicleIdentificationNumber = vehicleIdentificationNumber
        self.vehicleOwnerName = vehicleOwnerName
        self.vehicleOwnerFirstnames = vehicleOwnerFirstnames
        self.vehicleOwnerAddress = vehicleOwnerAddress
        self.vehicleCategory = vehicleCategory
        self.issueDate = issueDate
        self.issuingCountry = issuingCountry
        self.issuingAuthority = issuingAuthority
        self.validity = validity
        self.isSharedInstance = isSharedInstance
        self.sharedInstances = sharedInstances
    }
    
    func valuesAsArray() -> [(String, String)] {
        return [
            ("License Plate Number", licensePlateNumber),
            ("Brand", brand),
            ("Vehicle Type", vehicleType),
            ("Vehicle Identification Number", vehicleIdentificationNumber),
            ("Vehicle Owner Name", vehicleOwnerName),
            ("Vehicle Owner Firstnames", vehicleOwnerFirstnames),
            ("Vehicle Owner Address", vehicleOwnerAddress),
            ("Vehicle Category", vehicleCategory),
            ("Issue Date", issueDate),
            ("Issuing Country", issuingCountry),
            ("Issuing Authority", issuingAuthority)
        ]
    }
}

struct SharedInstance: Codable, Equatable, Identifiable {
    var id = UUID()
    var nickname: String
    var validity: Validity?
}
