//
//  InvitationView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit
import SnapKit

class QRCodeInvitationView: BaseView {
    
    override func initializeView() {
        self.addSubview(bgImageView)
        self.addSubview(hearderView)
        self.addSubview(bgContentView)
        
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(locationLabel)
        bgContentView.addSubview(arriveLabel)
        bgContentView.addSubview(arriveTime)
        bgContentView.addSubview(validLabel)
        bgContentView.addSubview(validTime)
        bgContentView.addSubview(qrCodeView)
        
        self.addSubview(saveButton)
        self.addSubview(shareButton)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hearderView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        bgContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalTo(hearderView.snp.bottom).offset(kMargin)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(kMargin)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
        }
        
        arriveLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalToSuperview().offset(130)
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
            make.top.equalTo(arriveLabel.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
        
        validTime.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.centerY.equalTo(validLabel)
            make.top.equalTo(validLabel)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kMargin*1.5)
            make.width.height.equalTo(290)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview().offset(-kMargin)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(50)
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalTo(saveButton)
        }
        
        
    }
    
    lazy var hearderView: CommonHeaderView = {
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
        view.image = R.image.invitation_image_contentbg()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "邀请您到访"
        view.textColor = R.color.maintextColor()
        view.textAlignment = .center
        view.font = k15Font
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.maintextColor()
        view.font = k18Font
        view.textAlignment = .center
        return view
    }()
    
    lazy var arriveLabel: UILabel = {
        let view = UILabel()
        view.text = "来访时间"
        view.textAlignment = .right
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var arriveTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = R.color.maintextColor()
        view.font = k18Font
        return view
    }()
    
    
    lazy var validLabel: UILabel = {
        let view = UILabel()
        view.text = "有效期至"
        view.textAlignment = .right
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var validTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = R.color.maintextColor()
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
        button.setTitleColor(R.color.themeColor(), for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_blue(), for: .normal)
        button.setTitle("分享给访客", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        return button
    }()


}
