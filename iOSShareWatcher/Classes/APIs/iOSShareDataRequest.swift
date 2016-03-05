//
//  iOSShareDataRequest.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/26.
//
//

import Foundation
import RxSwift
import Alamofire
import AsyncKit
import Himotoki

struct iOSShareDataRequest {
    
    private static let baseURL = "https://developer.apple.com/support"
    
    static func fetchChartData() -> Observable<String> {
        return Observable<String>.create { observer in
            Alamofire.request(.GET, "https://developer.apple.com/support/includes/ios-chart/scripts/chart.js").responseString {
                switch $0.result {
                case .Success(let code):
                    observer.onNext(code)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            return AnonymousDisposable {}
        }
    }
    
    static private func parseChartData(code: String) -> Observable<String> {
        return Observable<String>.create { observer in
            observer.onNext("HogeHoge")
            observer.onCompleted()
            return AnonymousDisposable {}
        }
    }
    
    static func fetchDate() -> Observable<String> {
        return Observable<String>.create { observer in
            Alamofire.request(.GET, "https://developer.apple.com/support/app-store/").responseString {
                switch $0.result {
                case .Success(let code):
                    observer.onNext(code)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            return AnonymousDisposable {}
        }
    }
    
    static func fetchData() -> Observable<[String]> {
        return Observable
            .zip(fetchChartData().flatMap({ parseChartData($0) }), fetchDate()) {
                return [$0, $1]
        }
    }
}
