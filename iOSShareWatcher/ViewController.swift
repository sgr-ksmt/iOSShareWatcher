//
//  ViewController.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/25.
//
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Async

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_sentMessage(Selector("viewWillAppear:"))
            .map { _ in () }
            .bindTo(viewModel.refreshTrigger)
            .addDisposableTo(disposeBag)

        viewModel.loading
            .asObservable()
            .subscribeNext { visible in
                Async.main {
                    if visible {
                        SVProgressHUD.showWithStatus("loading")
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    
                }
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

