//
//  ChartDataParser.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/27.
//
//

import Foundation
import UIKit
import PySwiftyRegex
import Himotoki
import Then

//TODO: move to suswiftsugar or extensions
extension NSLocale {
    enum Type: String {
        case en_US_POSIX
        case en_US
        case ja_JP
    }
    convenience init(type: Type) {
        self.init(localeIdentifier: type.rawValue)
    }
}

struct ChartDataParser {
    
    enum ElementParseError: ErrorType {
        case ParseFailed
        case ConvertToJSONFailed
    }
    
    enum DateParseError: ErrorType {
        case ParseFailed
        case ConvertToDateFailed
    }

    private init() {}
    static func formatToJSON(text: String) -> String {
        let replaced = re
            .compile("(name|value|color|x|y).?:")
            .sub("\"$1\":", text)
        return "{\"elements\":" + replaced + "}"
    }
    static func parseElements(code: String) throws -> Himotoki.AnyJSON {
        
        guard let
            matches = re.compile(".*var newData = (.+)").search(code),
            text = matches.group(1) else {
                throw ElementParseError.ParseFailed
        }
        
        guard let json = formatToJSON(text).dataUsingEncoding(NSUTF8StringEncoding) else {
            throw ElementParseError.ConvertToJSONFailed
        }
        
        do {
            return try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
        } catch let error {
            throw error
        }
    }
    
    static func parseDate(code: String) throws -> NSDate {
        guard let
            matches = re.compile(".*As measured by the App Store on <.*>(.+)\\..*").search(code),
            dateStr = matches.group(1) else {
                throw DateParseError.ParseFailed
        }
        let formatter = NSDateFormatter().then {
            $0.dateFormat = "MMMM dd, yyyy"
            $0.locale = NSLocale(type: .en_US_POSIX)
        }
        print(formatter.stringFromDate(NSDate()))
        if let date = formatter.dateFromString(dateStr) {
            return date
        } else {
            throw DateParseError.ConvertToDateFailed
        }
    }
}
