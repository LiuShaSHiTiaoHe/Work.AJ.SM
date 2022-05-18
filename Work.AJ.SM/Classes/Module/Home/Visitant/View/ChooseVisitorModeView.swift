//
//  ChooseVisitorModeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit
import SwiftEntryKit
import SnapKit

protocol ChooseVisitorModeDelegate: NSObjectProtocol {
    func qrcode()
    func password()
}

class ChooseVisitorModeView: BaseView {

    weak var delegate: ChooseVisitorModeDelegate?
    private var isPasswordEnable: Bool = false
    private var isQRCodeEnable: Bool = false
    
    @objc
    func closeAction() {
        SwiftEntryKit.dismiss()
    }
    
    @objc
    func chooseQrcode() {
        delegate?.qrcode()
    }
    
    @objc
    func choosePassword() {
        delegate?.password()
    }
    
    override func initializeView() {

        if let unit = HomeRepository.shared.getCurrentUnit() {
            isPasswordEnable = HomeRepository.shared.isVisitorPasswordEnable(unit)
            isQRCodeEnable = HomeRepository.shared.isVisitorQrCodeEnable(unit)
        }
        if !isPasswordEnable && !isQRCodeEnable {
            return
        }
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(qrcodeButton)
        addSubview(qrcodeTitle)
        addSubview(passwordButton)
        addSubview(passwordTitle)
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(closeButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        if isPasswordEnable && isQRCodeEnable {
            qrcodeButton.snp.makeConstraints { make in
                make.width.height.equalTo(65)
                make.centerX.equalTo(snp.centerX).dividedBy(2)
                make.centerY.equalToSuperview()
            }
            
            qrcodeTitle.snp.makeConstraints { make in
                make.centerX.equalTo(qrcodeButton)
                make.top.equalTo(qrcodeButton.snp.bottom).offset(kMargin/2)
                make.height.equalTo(30)
            }
            
            passwordButton.snp.makeConstraints { make in
                make.centerX.equalTo(snp.centerX).multipliedBy(1.5)
                make.width.height.equalTo(65)
                make.top.equalTo(qrcodeButton)
            }
            
            passwordTitle.snp.makeConstraints { make in
                make.centerX.equalTo(passwordButton)
                make.top.equalTo(passwordButton.snp.bottom).offset(kMargin/2)
                make.height.equalTo(30)
            }
        }else{
            if !isPasswordEnable {
                passwordButton.isHidden = true
                passwordTitle.isHidden = true
                qrcodeButton.snp.makeConstraints { make in
                    make.width.height.equalTo(65)
                    make.centerX.equalTo(snp.centerX)
                    make.centerY.equalToSuperview()
                }
                
                qrcodeTitle.snp.makeConstraints { make in
                    make.centerX.equalTo(qrcodeButton)
                    make.top.equalTo(qrcodeButton.snp.bottom).offset(kMargin/2)
                    make.height.equalTo(30)
                }
                
            }else if !isQRCodeEnable {
                qrcodeButton.isHidden = true
                qrcodeTitle.isHidden = true
                
                passwordButton.snp.makeConstraints { make in
                    make.width.height.equalTo(65)
                    make.centerX.equalTo(snp.centerX)
                    make.centerY.equalToSuperview()
                }
                
                passwordTitle.snp.makeConstraints { make in
                    make.centerX.equalTo(passwordButton)
                    make.top.equalTo(passwordButton.snp.bottom).offset(kMargin/2)
                    make.height.equalTo(30)
                }
            }
        }
        
    }

    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_close_black(), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.blackColor()
        view.font = k16Font
        view.text = "请选择合适的访客方式"
        view.textAlignment = .center
        return view
    }()
    
    lazy var qrcodeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.visitor_image_qrcode(), for: .normal)
        button.addTarget(self, action: #selector(chooseQrcode), for: .touchUpInside)
        return button
    }()
    
    lazy var qrcodeTitle: UILabel = {
        let view = UILabel.init()
        view.text = "访客二维码"
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var passwordButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.visitor_image_password(), for: .normal)
        button.addTarget(self, action: #selector(choosePassword), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordTitle: UILabel = {
        let view = UILabel.init()
        view.text = "访客密码"
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
        
}
