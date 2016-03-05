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
            let request = Alamofire
                .request(.GET, baseURL.stringByAppendingPathComponent("includes/ios-chart/scripts/chart.js"))
                .responseString {
                    switch $0.result {
                    case .Success(let code):
                        observer.onNext(code)
                        observer.onCompleted()
                    case .Failure(let error):
                        observer.onError(error)
                    }
            }
            return AnonymousDisposable {
                request.cancel()
            }
            }.flatMap(parseChartData)
    }
    
    static private func parseChartData(code: String) -> Observable<String> {
        return Observable<String>.create { observer in
            observer.onNext("HogeHoge")
            observer.onCompleted()
            return AnonymousDisposable {}
        }
    }
    
    static func fetchUpdatedDate() -> Observable<String> {
        return Observable<String>.create { observer in
            let request = Alamofire
                .request(.GET, baseURL.stringByAppendingPathComponent("app-store"))
                .responseString {
                    switch $0.result {
                    case .Success(let code):
                        observer.onNext(code)
                        observer.onCompleted()
                    case .Failure(let error):
                        observer.onError(error)
                    }
            }
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
    
    static func fetchData() -> Observable<[String]> {
        return Observable
            .zip(fetchChartData(), fetchUpdatedDate()) {
                return [$0, $1]
        }
    }
}
