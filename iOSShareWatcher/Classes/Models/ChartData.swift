//
//  ChartData.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/27.
//
//

import UIKit
import RealmSwift
import Himotoki
import HEXColor
import Then

struct ChartData: Decodable {
    var date: NSDate?
    var elements: [ChartElement]?
    static func decode(e: Extractor) throws -> ChartData {
        var d = ChartData()
        d.elements = try e <|| "elements"
        return d
    }
}

struct ChartElement: Decodable, Then {

    let name: String
    let value: Int
    private let colorHex: String
    var color: UIColor {
        return UIColor(rgba: colorHex)
    }

    static func decode(e: Extractor) throws -> ChartElement {
        return try ChartElement(
            name: e <| "name",
            value: e <| "value",
            colorHex: e <| "color"
        )
    }
}
