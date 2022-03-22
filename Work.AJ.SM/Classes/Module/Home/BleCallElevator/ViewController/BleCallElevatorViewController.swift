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
    
    override func initData() {
        contentView.sendButton.addTarget(self, action: #selector(sendBleData), for: .touchUpInside)
    }
    
    @objc
    func sendBleData(){
        let sendStatus = BLEAdvertisingManager.shared.openDoor()
        contentView.statusImage.isHidden = false
        if sendStatus {
            contentView.statusImage.image = R.image.bce_success_image()
            contentView.tips2Label.text = "已呼梯！请稍候…"
        }else{
            contentView.statusImage.image = R.image.bce_failed_image()
            contentView.tips2Label.text = "呼梯失败，请重试！"
        }
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
