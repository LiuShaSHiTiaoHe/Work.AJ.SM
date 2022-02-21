//
//  SetVisitorQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit

class SetVisitorQRCodeViewController: BaseViewController {

    lazy var contentView: SetVisitorQRCodeView = {
        let view = SetVisitorQRCodeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

    func initData() {
        
    }
}
