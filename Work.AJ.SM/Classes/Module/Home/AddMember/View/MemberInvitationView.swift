//
//  MemberInvitationView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/23.
//

import UIKit

class MemberInvitationView: BaseView {

    override func initializeView() {
        addSubview(bgImageView)
        addSubview(headerView)
        addSubview(avatar)
        addSubview(bgContentView)
        bgContentView.addSubview(nameLabel)
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(locationLabel)
        bgContentView.addSubview(qrCodeView)
        bgContentView.addSubview(tipsLabel)
        bgContentView.addSubview(tips1Label)
        bgContentView.addSubview(tips2Label)
        addSubview(saveButton)
        addSubview(shareButton)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        bgContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalTo(headerView.snp.bottom).offset(35)
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
            make.width.equalTo(qrCodeView.snp.height)
            make.bottom.equalTo(tipsLabel.snp.top).offset(-kMargin)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.bottom.equalTo(tips1Label.snp.top).offset(-kMargin)
        }
        
        tips1Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.bottom.equalTo(tips2Label.snp.top)
        }
        
        tips2Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-kMargin/2)
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
        
        bringSubviewToFront(avatar)
    }
    
    lazy var headerView: CommonHeaderView = {
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
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.image = R.image.defaultavatar()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_title()
        view.font = k18Font
        view.textAlignment = .center
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "邀请您加入房间"
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.font = k15Font
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.text_title()
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
        view.textColor = R.color.text_info()
        return view
    }()
    
    lazy var tips1Label: UILabel = {
        let view = UILabel()
        view.text = "1.  微信识别二维码，选择“接受邀请”。"
        view.textAlignment = .left
        view.font = k12Font
        view.textColor = R.color.text_info()
        return view
    }()
    
    lazy var tips2Label: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k12Font
        view.numberOfLines = 2
        view.textColor = R.color.text_info()
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_white(), for: .normal)
        button.setTitle("保存到相册", for: .normal)
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.titleLabel?.font = k14Font
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.btn_image_bg_blue(), for: .normal)
        button.setTitle("分享给家人/成员", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.titleLabel?.font = k14Font
        return button
    }()



}
