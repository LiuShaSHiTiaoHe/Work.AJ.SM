//
//  BaseChatView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit

protocol BaseChatViewDelegate: NSObjectProtocol {
    func refuseAudioCall()
    func responseAudioCall()
    func hangupAudioCall()
    func openDoorInCall()
}

class BaseChatView: BaseView {
    weak var delegate: BaseChatViewDelegate?
    var isCalled: Bool? {
        didSet {
            if let isVideoCall = isVideoCall {
                if let isCalled = isCalled {
                    updateButtons(isVideoCall, !isCalled)
                }
            }else{
                fatalError("isVideo must set before isCalled")
            }
        }
    }
    
    var isVideoCall: Bool?
    
    private func updateButtons(_ isVideo: Bool, _ isCaller: Bool) {
        if isVideo {
            if isCaller {
                refuseButton.isHidden = true
                responseButton.isHidden = true
                hangupButton.isHidden = false
                openDoorButton.isHidden = false
            }else{
                refuseButton.isHidden = false
                responseButton.isHidden = false
                hangupButton.isHidden = true
                openDoorButton.isHidden = true
            }
        }else{
            openDoorButton.isHidden = true
            if isCaller {
                refuseButton.isHidden = true
                responseButton.isHidden = true
                hangupButton.isHidden = false
                hangupButton.snp.updateConstraints { make in
                    make.centerX.equalToSuperview().offset(0)
                }
            }else{
                refuseButton.isHidden = false
                responseButton.isHidden = false
                hangupButton.isHidden = true
            }
        }
    }
    
    private func response2Call() {
        if let isVideoCall = isVideoCall {
            if isVideoCall{
                refuseButton.isHidden = true
                responseButton.isHidden = true
                hangupButton.isHidden = false
                openDoorButton.isHidden = false
            }else{
                refuseButton.isHidden = true
                responseButton.isHidden = true
                hangupButton.isHidden = false
                hangupButton.snp.updateConstraints { make in
                    make.centerX.equalToSuperview().offset(0)
                }
            }
        }
    }
    
    @objc
    private func refuseButtonAction() {
        delegate?.refuseAudioCall()
    }
    
    @objc
    private func responseButtonAction() {
        response2Call()
        delegate?.responseAudioCall()
    }
    
    @objc
    private func hangupButtonAction() {
        delegate?.hangupAudioCall()
    }
    
    @objc
    private func openDoorAction() {
        delegate?.openDoorInCall()
    }
    
    override func initData() {
        refuseButton.addTarget(self, action: #selector(refuseButtonAction), for: .touchUpInside)
        responseButton.addTarget(self, action: #selector(responseButtonAction), for: .touchUpInside)
        hangupButton.addTarget(self, action: #selector(hangupButtonAction), for: .touchUpInside)
        openDoorButton.addTarget(self, action: #selector(openDoorAction), for: .touchUpInside)
        
        refuseButton.isExclusiveTouch = true
        responseButton.isExclusiveTouch = true
        hangupButton.isExclusiveTouch = true
        openDoorButton.isExclusiveTouch = true
    }
    
    override func initializeView() {
        self.addSubview(videoImageView)
        self.addSubview(nameLabel)
        self.addSubview(tipsLabel)
        self.addSubview(refuseButton)
        self.addSubview(responseButton)
        self.addSubview(hangupButton)
        self.addSubview(openDoorButton)
                
        videoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kTitleAndStateHeight)
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        refuseButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.right.equalTo(self.snp.centerX).offset(-80)
        }
        
        responseButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.left.equalTo(self.snp.centerX).offset(80)
        }
        
        hangupButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.centerX.equalToSuperview().offset(-80)
        }
        
        openDoorButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.centerX.equalToSuperview().offset(80)
        }
    }
    
    lazy var videoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = R.color.backgroundColor()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k18Font
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k14Font
        view.textColor = R.color.family_yellowColor()
        return view
    }()
    
    lazy var refuseButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.chat_refuse_image(), for: .normal)
        button.layer.corner(40.0)
        return button
    }()
    
    lazy var responseButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.chat_response_image(), for: .normal)
        button.layer.corner(40.0)
        return button
    }()
    
    lazy var hangupButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.chat_hangup_image(), for: .normal)
        button.layer.corner(40.0)
        return button
    }()
    
    lazy var openDoorButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.chat_opendoor_image(), for: .normal)
        button.layer.corner(40.0)
        return button
    }()
}
