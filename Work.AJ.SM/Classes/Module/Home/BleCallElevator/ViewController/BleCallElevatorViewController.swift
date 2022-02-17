//
//  BleCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class BleCallElevatorViewController: BaseViewController {

    lazy var bleCallElevator: BleCallElevatorView = {
        let view = BleCallElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        view.addSubview(bleCallElevator)
        
        bleCallElevator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
