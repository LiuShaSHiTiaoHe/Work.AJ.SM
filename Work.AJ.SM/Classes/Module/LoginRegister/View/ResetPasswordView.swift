//
//  ResetPasswordView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/14.
//

import UIKit
import SnapKit

protocol ResetPasswordViewDelegate: NSObjectProtocol {
    func resetPasswordComfirm(mobile: String, code: String, newPassword: String)
    func resetPasswordClose()
    func sendCode(mobile: String)
}

class ResetPasswordView: UIView {
    
    private let inputHeight: CGFloat = 56.0
    weak var delegate: ResetPasswordViewDelegate?
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themebackgroundColor()
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.login_back(), for: .normal)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "重置密码"
        view.font = k16Font
        view.textColor = R.color.whiteColor()
        view.textAlignment = .center
        return view
    }()
    
    lazy var inputContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = R.color.whiteColor()
        view.jk.addShadow(shadowColor: R.color.themeColor()!, shadowOffset: .zero, shadowOpacity: 0.2, shadowRadius: 10)
        return view
    }()
    
    lazy var mobileInput: MobileInputView = {
        let view = MobileInputView()
        return view
    }()
    
    lazy var codeInput: VerificationCodeInputView = {
        let view = VerificationCodeInputView()
        return view
    }()
    
    lazy var passwordInput: PasswordInputView = {
        let view = PasswordInputView()
        return view
    }()
    
    lazy var comfirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("重置密码", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.titleLabel?.font = k18Font
        button.backgroundColor = R.color.themeColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(comfirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        self.backgroundColor = R.color.themebackgroundColor()
        
        self.addSubview(headerView)
        headerView.addSubview(closeButton)
        headerView.addSubview(titleLabel)
        self.addSubview(inputContentView)
        inputContentView.addSubview(mobileInput)
        inputContentView.addSubview(codeInput)
        inputContentView.addSubview(passwordInput)
        inputContentView.addSubview(comfirmButton)
        
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset((20 + kStateHeight - kOriginTitleAndStateHeight)/2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*3)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.height.equalTo(30)
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
        inputContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(headerView.snp.bottom).offset(kMargin)
            make.bottom.equalToSuperview().offset(-kMargin*3)
        }
        
        mobileInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin)
            make.height.equalTo(inputHeight)
        }
        
        codeInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(mobileInput.snp.bottom).offset(kMargin/2)
            make.height.equalTo(inputHeight)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(codeInput.snp.bottom).offset(kMargin/2)
            make.height.equalTo(inputHeight)
        }
        
        comfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*2)
            make.right.equalToSuperview().offset(-kMargin*2)
            make.height.equalTo(43)
            make.top.equalTo(passwordInput.snp.bottom).offset(kMargin*2)
        }
        
    }
    
    func initData() {
        codeInput.delegate = self
    }
    
    @objc
    func comfirmButtonAction() {
        var resetMobile = ""
        var resetCode = ""
        var newPassword = ""
        if let mobile = mobileInput.inputString, mobile.jk.isValidMobile {
            resetMobile = mobile
        }else{
            mobileInput.errorMsg = "请填写正确的手机号码"
            return
        }
        if let code = codeInput.inputString {
            resetCode = code
        }else{
            codeInput.errorMsg = "请输入验证码"
            return
        }
        if let password = passwordInput.inputString, password.count >= 6, password.count <= 12 {
            newPassword = password
        }else{
            passwordInput.errorMsg = "请设置正确格式的密码"
            return
        }
        delegate?.resetPasswordComfirm(mobile: resetMobile, code: resetCode, newPassword: newPassword)
    }
    
    @objc
    func closeButtonAction() {
        delegate?.resetPasswordClose()
    }
    
}

extension ResetPasswordView: VerificationCodeInputViewDelegate {
    func sendCodeButtonPressed() {
        if let phoneNumber = mobileInput.inputString, !phoneNumber.isEmpty {
            if phoneNumber.jk.isValidMobile {
                codeInput.startCountDown()
                delegate?.sendCode(mobile: phoneNumber)
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入手机号码")
        }
    }
}
