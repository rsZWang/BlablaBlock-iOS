//
//  StringExtensions.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import Foundation

public extension String {
    
    var int: Int {
        Int(self) ?? 0
    }
    
    var double: Double {
        Double(self) ?? 0
    }

    func toPrecisedString(precision: Int = 2) -> String {
        double.toPrecisedString(percision: precision)
    }
    
    func toPrettyPrecisedString(precision: Int = 2) -> String {
        double.toPrecisedString(percision: precision).formattedNumeric
    }
    
    var isNotEmpty: Bool { !isEmpty }
    
    var isNumeric: Bool {
        get { !(self.isEmpty) && self.allSatisfy { $0.isNumber } }
    }
    
    var isEmail: Bool {
        get {
            let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
            return testEmail.evaluate(with: self)
        }
    }
    
    func substring(from: Int, to: Int) -> String {
        guard (from>=0) && (from<to) && (to<=count) else { return "" }
        let range: Range = index(startIndex, offsetBy: from) ..< index(startIndex, offsetBy: to)
        return String(self[range])
    }
    
    var isNotEmail: Bool { !isEmail }
    
    var formattedNumeric: String {
        get {
            if let numericString = Int(self) {
                return numericString.withCommas().appendTo2Precision()
            } else if let numericString = Double(self) {
                return numericString.withCommas().appendTo2Precision()
            } else {
                Timber.w("This is not a numeric string! (\(self))")
                return self
            }
        }
    }
    
    var isValidPassword: Bool { count >= 6 && count <= 16 }
    
    var isNotValidPassword: Bool { !isValidPassword }
        
//    var isPhoneNumber: Bool {
//        get {
//            do {
//                let phoneNumber = try PhoneNumberKit().parse(self)
//                return phoneNumber.type == .mobile
//            } catch {
//                return false
//            }
//        }
//    }
//
//    var isNotPhoneNumber: Bool { !isPhoneNumber }
    
//    func dashedPhoneNumber() -> String {
//        do {
//            let phoneNumberKit = PhoneNumberKit()
//            let rawNumber = try phoneNumberKit.parse(self)
//            let formattedNumber = phoneNumberKit.format(rawNumber, toType: .national).dropFirst().replacingOccurrences(of: " ", with: "-")
//            return "+\(rawNumber.countryCode) \(formattedNumber)"
//        } catch {
//            Timber.e("Parsing phone number failed!: \(self)")
//            return self
//        }
//    }
//
//    func formattedPhoneNumber(masked: Bool) -> String {
//        do {
//            let phoneNumberKit = PhoneNumberKit()
//            let rawNumber = try phoneNumberKit.parse(self)
//            var nationNumber = "0\(rawNumber.nationalNumber)"
//            if masked {
//                let length = nationNumber.count/2
//                let start: Int
//                if ((nationNumber.count/2)%2) == 0 {
//                    start = (nationNumber.count/2)/2
//                } else {
//                    start = ((nationNumber.count/2)/2 + 1)
//                }
//                let startIndex = nationNumber.index(nationNumber.startIndex, offsetBy: start)
//                let endIndex = nationNumber.index(startIndex, offsetBy: length)
//                nationNumber.replaceSubrange(startIndex ..< endIndex, with: "*".repeated(count: length))
//            }
//            return "(+\(rawNumber.countryCode)) \(nationNumber)"
//        } catch {
//            Timber.e("Parsing phone number failed!: \(self)")
//            return "+\(self)"
//        }
//    }
    
//    func toFormattedDateTime(from: String, to: String) -> String {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
//        formatter.locale = CommonFrameworkUtility.getPreferredLocale()
//        formatter.dateFormat = from
//        if let dateTime = formatter.date(from: self) {
//            formatter.dateFormat = to
//            return formatter.string(from: dateTime)
//        } else {
//            Timber.e("Format error: \(from) for \(self)")
//            return self
//        }
//    }
    
    func repeated(count: Int) -> String {
        if count <= 0 {
            return self
        } else {
            var s = ""
            for _ in 0..<count {
                s = "\(s)\(self)"
            }
            return s
        }
    }
    
    func jsonToArray(separator: Character) -> [String] {
        var list = [String]()
        var str = ""
        for char in self {
            if char != separator {
                str.append(char)
            } else {
                list.append(str)
                str.removeAll()
            }
        }
        return list
    }
    
    func appendTo2Precision() -> String {
        var string = self
        let chunk = string.split(separator: ".")
        if chunk.count == 1 {
            string.append(contentsOf: ".00")
        } else if chunk[1].count == 1 {
            string.append(contentsOf: "0")
        }
        return string
    }
    
}
