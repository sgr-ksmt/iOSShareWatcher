//
//  iOSShareWatcherTests.swift
//  iOSShareWatcherTests
//
//  Created by Suguru Kishimoto on 2016/02/25.
//
//

import Quick
import Nimble
@testable import iOSShareWatcher

class Spec: QuickSpec {
    override func spec() {
        describe("describe text") {
            context("context text1") {
                it("it text") {
                    expect(1).to(beGreaterThanOrEqualTo(1))
                }
            }
            context("context text2") {
                it("it text") {
                    expect(2).to(beGreaterThanOrEqualTo(1))
                }
            }

        }
    }
}