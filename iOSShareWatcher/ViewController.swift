//
//  ViewController.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/02/25.
//
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        iOSShareDataRequest.fetchData().subscribeNext({
            print($0)
        }).addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
