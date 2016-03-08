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
        
        viewModel.indicatorTrigger
            .subscribe { event in
                Async.main {
                    SVProgressHUD.rx_switch("Loading...", event: event)
                }
            }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SVProgressHUD {
    
    static func rx_switch(msg: String, errorMsg: String = "Error!", event: Event<Bool>) {
        switch event {
        case .Next(let visible):
            if visible {
                SVProgressHUD.showWithStatus(msg)
            } else {
                SVProgressHUD.dismiss()
            }
        case .Error( _):
            SVProgressHUD.showErrorWithStatus(errorMsg)
        default:
            SVProgressHUD.dismiss()
        }
    }
}

