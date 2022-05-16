//
//  AgoraCallingView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/27.
//

import UIKit

class AgoraCallingView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        self.backgroundColor = .systemBlue
        self.addSubview(headImageView)
        self.addSubview(numberLabel)
        self.addSubview(declineButton)
        self.addSubview(acceptButton)
        self.addSubview(hangupButton)
                
        headImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kTitleAndStateHeight + 50)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImageView.snp.bottom).offset(kMargin)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        declineButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-100)
            make.right.equalTo(self.snp.centerX).offset(-50)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(declineButton)
            make.left.equalTo(self.snp.centerX).offset(50)
        }
        
        hangupButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(declineButton)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var headImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.defaultavatar()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_refuse_image(), for: .normal)
        return button
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_response_image(), for: .normal)
        return button
    }()
    
    lazy var hangupButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_hangup_image(), for: .normal)
        return button
    }()
    
    let aureolaView = AureolaView(color: UIColor(red: 173.0 / 255.0,
                                                         green: 211.0 / 255.0,
                                                         blue: 252.0 / 255.0, alpha: 1))
}
