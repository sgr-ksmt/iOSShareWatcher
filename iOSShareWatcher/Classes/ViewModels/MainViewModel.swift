//
//  MainViewModel.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/03/06.
//
//

import UIKit
import RxSwift

class MainViewModel {
    
    let refreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    let loading = Variable<Bool>(false)
    
    init() {
        let request = [
            Observable.never().takeUntil(refreshTrigger),
            iOSShareDataRequest.fetchData()
            ]
            .concat()
            .shareReplay(1)
        
        //TODO: change
        let requestFinishTrigger = PublishSubject<Void>()        
        request
            .subscribe { _ in
                requestFinishTrigger.onCompleted()
            }
            .addDisposableTo(disposeBag)
        
        Observable.of(
            Observable.of(true).sample(refreshTrigger),
            Observable.of(false).sample(requestFinishTrigger)
        )
        .merge()
        .bindTo(loading)
        .addDisposableTo(disposeBag)
        
        
        request
            .subscribe({ (event) -> Void in
                switch event {
                case .Next(let elements): print("elements :", elements)
                case .Error(let error): print("error :", error)
                default: ()
                }
            })
            .addDisposableTo(disposeBag)
    }
}
