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
        let requestFinish = request.flatMap({_ in Observable.just() })
        
        Observable.of(
            Observable.of(true).sample(refreshTrigger),
            Observable.of(false).sample(requestFinish)
        )
        .merge()
        .bindTo(loading)
        .addDisposableTo(disposeBag)
        
        
        request
            .subscribeNext({print($0)})
            .addDisposableTo(disposeBag)
    }
}
