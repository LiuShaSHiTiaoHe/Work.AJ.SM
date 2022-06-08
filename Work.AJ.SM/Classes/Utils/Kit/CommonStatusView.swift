//
//  CommonSuccessView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import UIKit

enum CommonStatusType {
    case normal
    case success
    case failed
}

class CommonStatusView: BaseView {

    var type: CommonStatusType? {
        didSet {
            if let type = type {
                switch type {
                case .normal:
                    imageView.image = R.image.common_success_image()
                case .success:
                    imageView.image = R.image.common_success_image()
                case .failed:
                    imageView.image = R.image.common_failed_image()
                }
            }
        }
    }

    var statusStr: String? {
        didSet {
            if let statusStr = statusStr {
                statusLabel.text = statusStr
            }
        }
    }

    var tipsStr: String? {
        didSet {
            if let tipsStr = tipsStr {
                tipsLabel.text = tipsStr
            }
        }
    }


    override func initData() {

    }

    override func initializeView() {
        addSubview(imageView)
        addSubview(statusLabel)
        addSubview(tipsLabel)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            make.top.equalTo(66)
        }

        statusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalTo(imageView.snp.bottom).offset(kMargin)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalTo(statusLabel.snp.bottom).offset(kMargin)
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        return view
    }()

    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.font = k18Font
        view.textColor = R.color.text_title()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.font = k12Font
        view.textColor = R.color.text_title()
        return view
    }()

}
