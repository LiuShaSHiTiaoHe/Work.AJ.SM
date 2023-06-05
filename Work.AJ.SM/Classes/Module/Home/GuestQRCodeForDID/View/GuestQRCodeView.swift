//
//  GuestQRCodeView.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import UIKit
import SnapKit

class GuestQRCodeView: BaseView {

    override func initializeView() {
        let contentImageHeight = kScreenHeight - kTitleAndStateHeight - 100 - kMargin
        let topPartHeight = 150.0
        let qrCodeWidth = kScreenWidth - kMargin*2
        let qrCodeHeight = contentImageHeight - topPartHeight - 70 - 20
        
        addSubview(bgImageView)
        addSubview(headerView)
        addSubview(bgContentView)
        
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(locationLabel)
        bgContentView.addSubview(arriveLabel)
        bgContentView.addSubview(arriveTime)
        bgContentView.addSubview(validLabel)
        bgContentView.addSubview(validTime)
        bgContentView.addSubview(dashLine)
        bgContentView.addSubview(qrCodeView)

        addSubview(saveButton)
        addSubview(shareButton)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        bgContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalTo(headerView.snp.bottom).offset(kMargin)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(kMargin/2)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
        }
        
        arriveLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.bottom.equalTo(validLabel.snp.top).offset(-kMargin)
            make.height.equalTo(20)
        }
        
        arriveTime.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.centerY.equalTo(arriveLabel)
            make.top.equalTo(arriveLabel)
        }
        
        validLabel.snp.makeConstraints { make in
            make.left.equalTo(arriveLabel)
            make.bottom.equalTo(dashLine.snp.top).offset(-kMargin)
            make.height.equalTo(20)
        }
        
        validTime.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.centerY.equalTo(validLabel)
            make.top.equalTo(validLabel)
        }
        
        dashLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(topPartHeight + 30)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(min(qrCodeWidth, qrCodeHeight))
            make.top.equalTo(dashLine.snp.bottom).offset(kMargin)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview().offset(-kMargin*1.5)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(50)
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalTo(saveButton)
        }
    }
    
    override func layoutSubviews() {
        dashLine.jk.drawDashLine(strokeColor: R.color.themecolor()!)
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "邀请函"
        view.lineView.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.invitation_image_bg()
        return view
    }()
    
    lazy var bgContentView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 15.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "邀请您到访"
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.font = k15Font
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.text_title()
        view.font = k20Font
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    
    lazy var arriveLabel: UILabel = {
        let view = UILabel()
        view.text = "来访时间"
        view.textAlignment = .right
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var arriveTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = R.color.text_title()
        view.font = k18Font
        return view
    }()
    
    
    lazy var validLabel: UILabel = {
        let view = UILabel()
        view.text = "有效期至"
        view.textAlignment = .right
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var validTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = R.color.text_title()
        view.font = k18Font
        return view
    }()
    
    
    lazy var dashLine: UIImageView = {
        let view = UIImageView()
        return view
    }()

    
    lazy var qrCodeView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_white(), for: .normal)
        button.setTitle("保存到相册", for: .normal)
        button.setTitleColor(R.color.themecolor(), for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_blue(), for: .normal)
        button.setTitle("分享给访客", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        return button
    }()


}
