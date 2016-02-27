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
        iOSShareDataRequest().fetchData().subscribeNext{print($0)}.addDisposableTo(bag)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

