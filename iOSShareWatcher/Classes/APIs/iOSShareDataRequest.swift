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

import SVProgressHUD

struct iOSShareDataRequest {
    
    private static let baseURL = "https://developer.apple.com/support"
    private static var chartJSURL: String {
        return baseURL.stringByAppendingPathComponent("includes/ios-chart/scripts/chart.js")
    }
    private static var appStoreURL: String {
        return baseURL.stringByAppendingPathComponent("app-store")
    }
    
    static func fetchChartData() -> Observable<ChartData> {
        return Observable<String>
            .create { observer in
                let request = Alamofire
                    .request(.GET, chartJSURL)
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
            .flatMap(parseChartData)
            .flatMap(decodeChartData)
    }
    
    static private func parseChartData(code: String) -> Observable<Himotoki.AnyJSON> {
        return Observable<Himotoki.AnyJSON>.create { observer in
            observer.onNext(ChartDataParser.parse(code))
            observer.onCompleted()
            return AnonymousDisposable {}
        }
    }
    
    static private func decodeChartData(json: Himotoki.AnyJSON) -> Observable<ChartData> {
        return Observable<ChartData>.create { observer in
            do {
                let chartData: ChartData = try decodeValue(json)
                observer.onNext(chartData)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return AnonymousDisposable {}
        }
    }
    
    static func fetchUpdatedDate() -> Observable<String> {
        return Observable<String>.create { observer in
            let request = Alamofire
                .request(.GET, appStoreURL)
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
            .zip(fetchChartData(), fetchUpdatedDate()) { _ in
                return [""]
        }
    }
}
