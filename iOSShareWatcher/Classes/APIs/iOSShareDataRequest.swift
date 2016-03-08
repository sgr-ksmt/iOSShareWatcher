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
    
    static let baseURL = "https://developer.apple.com/support"
    static var chartJSURL: String {
        return baseURL + "/includes/ios-chart/scripts/chart.js"
    }
    static var appStoreURL: String {
        return baseURL + "/app-store"
    }
    
    static func fetchChartData() -> Observable<[ChartElement]> {
        return Observable.just()
            .flatMap(getChartJS)
            .flatMap(parseChartData)
            .flatMap(decodeChartData)
    }

    static func getChartJS() -> Observable<String> {
        return Observable.create { observer in
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
    }
    
    static func parseChartData(code: String) -> Observable<Himotoki.AnyJSON> {
        return Observable.create { observer in
            do {
                let json = try ChartDataParser.parseElements(code)
                observer.onNext(json)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return AnonymousDisposable {}
        }
    }
    
    static func decodeChartData(json: Himotoki.AnyJSON) -> Observable<[ChartElement]> {
        return Observable.create { observer in
            do {
                let elements: [ChartElement] = try decodeArray(json, rootKeyPath: "elements")
                observer.onNext(elements)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return AnonymousDisposable {}
        }
    }
    
    static func fetchUpdatedDate() -> Observable<NSDate> {
        return Observable.just()
            .flatMap(getHTML)
            .flatMap(parseDate)
    }
    
    static func getHTML() -> Observable<String> {
        return Observable.create { observer in
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
    
    static func parseDate(code: String) -> Observable<NSDate> {
        return Observable.create { observer in
            do {
                let date = try ChartDataParser.parseDate(code)
                observer.onNext(date)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return AnonymousDisposable {}
        }
    }
    
    static func fetchData() -> Observable<ChartData> {
        return Observable.zip(fetchChartData(), fetchUpdatedDate()) {
            return ChartData(date: $1, elements: $0)
        }
    }
}
