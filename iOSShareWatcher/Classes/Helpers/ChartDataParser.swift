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

struct ChartDataParser {
    private init() {}
    static func formatToJSON(text: String) -> String {
        let replaced = re
            .compile("(name|value|color|x|y).?:")
            .sub("\"$1\":", text)
        
        return "{\"elements\":" + replaced + "}"
    }
    static func parse(code: String) -> Himotoki.AnyJSON {
        print(code)
        if let
            m = re.compile(".*var newData = (.+)").search(code),
            text = m.group(1),
            json = formatToJSON(text).dataUsingEncoding(NSUTF8StringEncoding),
            elements = try? NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments) {
                return elements
        } else {
            return [:]
        }
    }
}
