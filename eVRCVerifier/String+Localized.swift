import SwiftUI

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ input: String) -> String {
        return self.localized.replacingOccurrences(of: "#", with: input)
    }
    
    func localized(_ input1: String, _ input2: String, _ input3: String) -> String {
        var string = self.localized
        string = string.replacingOccurrences(of: "#", with: input1)
        string = string.replacingOccurrences(of: "+", with: input2)
        string = string.replacingOccurrences(of: "$", with: input3)
        return unescapeString(string)
    }
    
    private func unescapeString(_ string: String) -> String {
        return string.replacingOccurrences(of: "\\n", with: "\n")
    }
}
