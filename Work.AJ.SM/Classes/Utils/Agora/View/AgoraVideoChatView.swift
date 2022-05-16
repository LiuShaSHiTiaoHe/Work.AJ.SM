//
//  AgoraVideoChatView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/27.
//

import UIKit

class AgoraVideoChatView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        self.backgroundColor = R.color.themeColor()
        self.addSubview(remoteVideo)
        self.addSubview(localVideo)
        self.addSubview(micButton)
        self.addSubview(hangupButton)
        self.addSubview(openDoorButton)
        
        remoteVideo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        localVideo.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.top.equalToSuperview().offset(kTitleAndStateHeight + 50)
            make.right.equalToSuperview().offset(-kMargin * 3)
        }
        
        hangupButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
            make.width.height.equalTo(60)
        }
        
        micButton.snp.makeConstraints { make in
            make.centerY.equalTo(hangupButton)
            make.width.height.equalTo(40)
            make.right.equalTo(hangupButton.snp.left).offset(-kMargin*2)
        }
        
        openDoorButton.snp.makeConstraints { make in
            make.centerY.equalTo(hangupButton)
            make.width.height.equalTo(40)
            make.left.equalTo(hangupButton.snp.right).offset(kMargin*2)
        }
    }
    
    lazy var localVideo: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var remoteVideo: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var micButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_mute_image(), for: .normal)
        button.setImage(R.image.chat_mute_pressed_image(), for: .selected)
        return button
    }()
    
    lazy var hangupButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_hangup_image(), for: .normal)
        return button
    }()
    
    lazy var openDoorButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_opendoor_image(), for: .normal)
        return button
    }()
}
