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
                dispatch_async(dispatch_get_main_queue()) {
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

