//
//  MemberInvitationView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

class MemberInvitationView: BaseView {

    override func initializeView() {
        self.addSubview(bgImageView)
        self.addSubview(hearderView)
        self.addSubview(avatar)
        self.addSubview(bgContentView)
        bgContentView.addSubview(nameLabel)
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(locationLabel)
        bgContentView.addSubview(qrCodeView)
        bgContentView.addSubview(tipsLabel)
        bgContentView.addSubview(tips1Label)
        bgContentView.addSubview(tips2Label)
        self.addSubview(saveButton)
        self.addSubview(shareButton)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hearderView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(hearderView.snp.bottom)
        }
        
        bgContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalTo(hearderView.snp.bottom).offset(35)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(kMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(kMargin)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
        }

        qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(kMargin)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(290)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.top.equalTo(qrCodeView.snp.bottom).offset(kMargin)
        }
        
        tips1Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin)
        }
        
        tips2Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.top.equalTo(tips1Label.snp.bottom)
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
        
        self.bringSubviewToFront(avatar)
    }
    
    lazy var hearderView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "邀请函"
        view.titleLabel.textAlignment = .center
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
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.image = R.image.defaultavatar()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k18Font
        view.textAlignment = .center
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "邀请您加入房间"
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
    
    lazy var qrCodeView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "----------------   加入房屋   ----------------"
        view.font = k12Font
        view.textAlignment = .center
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var tips1Label: UILabel = {
        let view = UILabel()
        view.text = "1.  微信识别二维码，选择“接受邀请”。"
        view.textAlignment = .left
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var tips2Label: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k12Font
        view.numberOfLines = 2
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_white(), for: .normal)
        button.setTitle("保存到相册", for: .normal)
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.titleLabel?.font = k14Font
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_blue(), for: .normal)
        button.setTitle("分享给家人/成员", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.titleLabel?.font = k14Font
        return button
    }()



}
