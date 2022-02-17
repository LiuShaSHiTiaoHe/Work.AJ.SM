//
//  MobileCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit

class MobileCallElevatorViewController: BaseViewController {

    lazy var mobileCallElevator: MobileCallElevatorView = {
        let view = MobileCallElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        view.addSubview(mobileCallElevator)
        mobileCallElevator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
