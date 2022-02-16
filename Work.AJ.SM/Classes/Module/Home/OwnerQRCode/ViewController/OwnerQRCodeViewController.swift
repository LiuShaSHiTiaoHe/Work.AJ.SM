//
//  OwnerQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class OwnerQRCodeViewController: BaseViewController {

    lazy var ownerQRCodeView: OwnerQRCodeView = {
        let view = OwnerQRCodeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(ownerQRCodeView)
        ownerQRCodeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func initData() {
        ownerQRCodeView.delegate = self
    }
    
}

extension OwnerQRCodeViewController: OwnerQRCodeViewDelegate {
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func refresh() {
        
    }
}
