//
//  BleCallElevatorView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/16.
//

import UIKit
import SwiftEntryKit

class BleCallElevatorView: BaseView {

    @objc
    func closeAction() {
        SwiftEntryKit.dismiss()
    }

    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_close_black(), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel.init()
        view.backgroundColor = R.color.bg_yellow()
        view.textColor = R.color.sub_yellow()
        view.font = k12Font
        view.textAlignment = .center
        view.text = "在2米范围内，才能使用蓝牙操作哦"
        return view
    }()

    lazy var imageView1: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.bce_device_image()
        return view
    }()

    lazy var statusImage: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var dashView: UILabel = {
        let view = UILabel()
        view.text = "-------------------------"
        view.font = k14Font
        view.textColor = R.color.themecolor()
        return view
    }()

    lazy var imageView2: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.bce_elevator_image()
        return view
    }()

    lazy var tips2Label: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.font = k12Font
        view.text = "请靠近电梯/门禁设备后再操作"
        return view
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.bce_send_image(), for: .normal)
        return button
    }()

    override func initializeView() {
        addSubview(closeButton)
        addSubview(tipsLabel)
        addSubview(imageView1)
        addSubview(statusImage)
        addSubview(dashView)
        addSubview(imageView2)
        addSubview(tips2Label)
        addSubview(sendButton)

        bringSubviewToFront(statusImage)
        statusImage.isHidden = true

        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin / 2)
            make.top.equalToSuperview().offset(kMargin / 2)
            make.width.height.equalTo(kMargin)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(50)
        }

        imageView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.width.equalTo(80)
            make.height.equalTo(54)
            make.top.equalToSuperview().offset(140)
        }

        dashView.snp.makeConstraints { make in
            make.left.equalTo(imageView1.snp.right).offset(kMargin / 2)
            make.height.equalTo(5)
            make.right.equalTo(imageView2.snp.left).offset(-kMargin / 2)
            make.centerY.equalTo(imageView1)
        }

        statusImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dashView)
            make.width.equalTo(35)
            make.height.equalTo(42)
        }

        imageView2.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(imageView1)
            make.width.equalTo(46)
            make.height.equalTo(86)
        }

        tips2Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-130)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(89)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kMargin / 2)
        }

    }


//    override func layoutSubviews() {
//        dashView.jk.drawDashLine(strokeColor: R.color.themecolor()!)
//    }

}
