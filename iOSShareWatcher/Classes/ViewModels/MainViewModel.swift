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
    let indicatorTrigger = PublishSubject<Bool>()
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
        let loadErrorTrigger = PublishSubject<Bool>()
        
        Observable
            .of(
                loading.asObservable(),
                loadErrorTrigger.asObservable()
            )
            .merge()
            .shareReplay(1)
            .subscribe { [weak self] in
                self?.indicatorTrigger.on($0)
            }
            .addDisposableTo(disposeBag)
        
        
        Observable
            .of(
                Observable.of(true).sample(refreshTrigger),
                Observable.of(false).sample(requestFinishTrigger)
            )
            .merge()
            .shareReplay(1)
            .bindTo(loading)
            .addDisposableTo(disposeBag)
        
        
        request
            .subscribe { (event) -> Void in
                switch event {
                case .Next(let elements):
                    print("elements :", elements)
                case .Error(let error):
//                    print("error :", error)
                    loadErrorTrigger.onError(error)
                default: ()
                }
                requestFinishTrigger.onCompleted()
            }
            .addDisposableTo(disposeBag)
    }
}
