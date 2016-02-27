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

class iOSShareDataRequest {
    func fetch() -> Observable<[String]> {
        let observable = Observable<[String]>.create { observer in
            Alamofire.request(.GET, "https://developer.apple.com/support/includes/ios-chart/scripts/chart.js").responseString {
                switch $0.result {
                case .Success(let code): print(code)
                case .Failure(let error): observer.onError(error)
                }
            }
            observer.onNext(["Apple", "Banana"])
            observer.onCompleted()
            return AnonymousDisposable{}
        }
        return observable
    }
}
