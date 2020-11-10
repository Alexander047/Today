//
//  ViewController.swift
//  Today
//
//  Created by Alexander on 10.11.2020.
//

import UIKit
import EasyLayout_ios

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "MAIN"
        view.addSubview(label)
        label.makeConstraints { (pin) in
            pin.center.equalToSuperView()
        }
        view.backgroundColor = .white
        let s = UISwitch()
        
    }


}

