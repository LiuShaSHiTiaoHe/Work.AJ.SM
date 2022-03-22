//
//  BleCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class BleCallElevatorViewController: BaseViewController {

    lazy var contentView: BleCallElevatorView = {
        let view = BleCallElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission([.bluetooth])
    }
    
    override func initUI() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
