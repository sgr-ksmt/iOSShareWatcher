//
//  iOSShareDataRequestTests.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/03/08.
//
//

import XCTest

import Quick
import Nimble
import RxSwift
import RxTests
@testable import iOSShareWatcher

class iOSShareDataRequestSpec: QuickSpec {
    
    override func spec() {
        describe("fetchChartData") {
            context("do decode chartData from json") {
                it("should success") {
                    let disposebag = DisposeBag()
                    let json = [
                        "elements" : [
                            [ "name": "iOS 9", "value": 77, "color": "#79cdf8", "x": -20, "y": -20],
                            [ "name": "iOS 8", "value": 17, "color": "#b3e1fb"],
                            [ "name": "Earlier", "value": 6, "color": "#79cdf8", "y": -10]
                        ]
                    ]
                    iOSShareDataRequest
                        .decodeChartData(json)
                        .shareReplay(1)
                        .subscribe {
                            switch $0 {
                            case .Error(let error): fail("\(error)")
                            default: ()
                            }
                        }
                        .addDisposableTo(disposebag)
                }
            }
        }
    }
}