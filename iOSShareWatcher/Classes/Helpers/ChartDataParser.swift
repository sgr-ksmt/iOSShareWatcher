//
//  ChartDataParser.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/27.
//
//

import Foundation
import UIKit

struct ChartDataParser {
    private init() {}
    
    static func parse(code: String) -> [String: AnyObject] {
        // mock
//        return [:]
        return [
            "elements": [
                ["name": "iOS 9", "value": 77, "color": "#79cdf8", "x": -20, "y": -20],
                ["name": "iOS 8", "value": 17, "color": "#b3e1fb"],
                ["name": "Earlier", "value": 6, "color": "#c1e8fb", "y":-10]
            ]
        ]
    }
}
