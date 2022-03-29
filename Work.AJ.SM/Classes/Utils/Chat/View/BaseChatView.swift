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
}

class BaseChatView: BaseView {
    weak var delegate: BaseChatViewDelegate?
    var isCalled: Bool? {
        didSet {
            if let isCalled = isCalled {
                if isCalled {
                    refuseButton.isHidden = false
                    responseButton.isHidden = false
                    hangupButton.isHidden = true
                }else{
                    refuseButton.isHidden = true
                    responseButton.isHidden = true
                    hangupButton.isHidden = false
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
        refuseButton.isHidden = true
        responseButton.isHidden = true
        hangupButton.isHidden = false
        delegate?.responseAudioCall()
    }
    
    @objc
    private func hangupButtonAction() {
        delegate?.hangupAudioCall()
    }
    
    override func initData() {
        refuseButton.addTarget(self, action: #selector(refuseButtonAction), for: .touchUpInside)
        responseButton.addTarget(self, action: #selector(responseButtonAction), for: .touchUpInside)
        hangupButton.addTarget(self, action: #selector(hangupButtonAction), for: .touchUpInside)
    }
    
    override func initializeView() {
        self.addSubview(videoImageView)
        self.addSubview(nameLabel)
        self.addSubview(tipsLabel)
        self.addSubview(refuseButton)
        self.addSubview(responseButton)
        self.addSubview(hangupButton)
        
        hangupButton.isHidden = true
        
        videoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-kTitleAndStateHeight)
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
            make.right.equalTo(self.snp.centerX).offset(-60)
        }
        
        responseButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.left.equalTo(self.snp.centerX).offset(60)
        }
        
        hangupButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.centerX.equalToSuperview()
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
        view.textColor = R.color.whiteColor()
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
}
