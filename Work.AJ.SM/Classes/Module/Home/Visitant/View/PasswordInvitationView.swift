//
//  PasswordInvitationView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/22.
//

import UIKit

class PasswordInvitationView: BaseView {
    
    var isValid: Bool? {
        didSet {
            if let isValid = isValid {
                statusLabel.isHidden = false
                if isValid {
                    statusLabel.text = "有效"
                    statusLabel.backgroundColor = R.color.sub_green()
                    invalidTips.isHidden = true
                    invalidIcon.isHidden = true
                    passwordTipsLabel.isHidden = false
                    passwordLabel.isHidden = false
                }else{
                    statusLabel.text = "已过期"
                    statusLabel.backgroundColor = R.color.text_info()
                    invalidTips.isHidden = false
                    invalidIcon.isHidden = false
                    passwordTipsLabel.isHidden = true
                    passwordLabel.isHidden = true
                    hideShareButtons()
                }
            }else{
                statusLabel.isHidden = true
                invalidTips.isHidden = true
                invalidIcon.isHidden = true
                passwordTipsLabel.isHidden = false
                passwordLabel.isHidden = false
            }
        }
    }
    
    func hideShareButtons() {
        saveButton.isHidden = true
        shareButton.isHidden = true
    }
        
    override func initializeView() {
        
        let topPartHeight = 240.0
        
        addSubview(bgImageView)
        addSubview(headerView)
        addSubview(bgContentView)
        
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(statusLabel)
        bgContentView.addSubview(locationLabel)
        bgContentView.addSubview(arriveLabel)
        bgContentView.addSubview(arriveTime)
        bgContentView.addSubview(validLabel)
        bgContentView.addSubview(validTime)
        bgContentView.addSubview(timesLabel)
        bgContentView.addSubview(visitTimes)
        bgContentView.addSubview(dashLine)
        bgContentView.addSubview(passwordTipsLabel)
        bgContentView.addSubview(passwordLabel)
        bgContentView.addSubview(invalidIcon)
        bgContentView.addSubview(invalidTips)
        
        addSubview(saveButton)
        addSubview(shareButton)
        
        statusLabel.isHidden = true
        invalidTips.isHidden = true
        invalidIcon.isHidden = true
        
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
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(kMargin/2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(kMargin)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(50)
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
        
        timesLabel.snp.makeConstraints { make in
            make.left.equalTo(arriveLabel)
            make.top.equalTo(validLabel.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
        
        visitTimes.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.centerY.equalTo(timesLabel)
            make.top.equalTo(timesLabel)
        }

        dashLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(topPartHeight + 30)
        }
        
        passwordTipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-kMargin)
            make.right.equalToSuperview().offset(kMargin)
            make.top.equalTo(dashLine.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(60)
            make.top.equalTo(passwordTipsLabel.snp.bottom).offset(kMargin*2)
        }
        
        invalidIcon.snp.makeConstraints { make in
            make.right.equalTo(invalidTips.snp.left).offset(-kMargin/2)
            make.width.height.equalTo(20)
            make.centerY.equalTo(invalidTips)
        }
        
        invalidTips.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(passwordLabel.snp.centerY).offset(-kMargin)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
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
    
    //状态标签
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.whitecolor()
        view.font = k14Font
        view.jk.addCorner(conrners: UIRectCorner.topRight, radius: 15.0)
        view.jk.addCorner(conrners: UIRectCorner.bottomRight, radius: 15.0)
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.text_title()
        view.font = k18Font
        view.numberOfLines = 0
        view.textAlignment = .center
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
    
    
    lazy var timesLabel: UILabel = {
        let view = UILabel()
        view.text = "使用次数"
        view.textAlignment = .right
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var visitTimes: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = R.color.text_title()
        view.font = k18Font
        return view
    }()
    
    lazy var dashLine: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var passwordTipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = R.color.text_title()
        view.font = k18Font
        view.text = "访客密码"
        return view
    }()
    
    lazy var passwordLabel: UILabel = {
        let view = UILabel()
        view.font = k34Font
        view.textAlignment = .center
        view.textColor = R.color.themecolor()
        return view
    }()
    
    lazy var invalidIcon: UIImageView = {
        let view = UIImageView.init(image: R.image.common_error_red())
        return view
    }()
    
    lazy var invalidTips: UILabel = {
        let view = UILabel()
        view.text = "访客密码已过期"
        view.font = k18Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
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
