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

struct ChartData {
    var date: NSDate?
    let elements: [ChartElement]
}

struct ChartElement: Decodable, Then {
    let name: String
    let value: Int
    let color: UIColor
    
    private static var colorTransformer: Transformer<String, UIColor> {
        return Transformer { return try UIColor(rgba_throws: $0) }
    }
    
    static func decode(e: Extractor) throws -> ChartElement {
        return try ChartElement(
            name: e <| "name",
            value: e <| "value",
            color: colorTransformer.apply(e <| "color")
        )
    }
}
