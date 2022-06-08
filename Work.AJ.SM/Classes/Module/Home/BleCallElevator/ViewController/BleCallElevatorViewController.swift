//
//  BleCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit
import SVProgressHUD

class BleCallElevatorViewController: BaseViewController {

    lazy var contentView: BleCallElevatorView = {
        let view = BleCallElevatorView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        contentView.sendButton.addTarget(self, action: #selector(sendBleData), for: .touchUpInside)
        let _ = BLEAdvertisingManager.shared
    }

    @objc
    func sendBleData() {
        PermissionManager.permissionRequest(.bluetooth) { [weak self] authorized in
            guard let self = self else {
                return
            }
            if authorized {
                let manager = BLEAdvertisingManager.shared
                let sendStatus = manager.openDoor()
                self.contentView.statusImage.isHidden = false
                if sendStatus {
                    self.contentView.statusImage.image = R.image.bce_success_image()
                    self.contentView.tips2Label.text = "已呼梯/开门！请稍候…"
                } else {
                    self.contentView.statusImage.image = R.image.bce_failed_image()
                    self.contentView.tips2Label.text = "呼梯/开门失败，请重试！"
                }
            } else {
                SVProgressHUD.showInfo(withStatus: "请打开蓝牙权限")
            }
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
