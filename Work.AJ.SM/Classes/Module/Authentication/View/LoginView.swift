//
//  LoginView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/11.
//

import UIKit
import BetterSegmentedControl
import JKSwiftExtension
import SVProgressHUD
import ActiveLabel

protocol LoginViewDelegate: NSObjectProtocol {
    func login(mobile: String, password: String)
    func forgetPassword(mobile: String?)
    func register(mobile: String, code: String, password: String)
    func sendCode(mobile: String)
    func showTermsOfServices()
    func showPrivacy()
}

enum loginOrRegisterType {
    case login
    case register
}

class LoginView: BaseView {

    private let inputHeight: CGFloat = 66.0
    weak var delegate: LoginViewDelegate?
    private var viewType: loginOrRegisterType = .login

    func configurePolicyLabel() {
        let customType1 = ActiveType.custom(pattern: "《用户协议》")
        let customType2 = ActiveType.custom(pattern: "《隐私声明》")
        policyLabel.enabledTypes.append(customType1)
        policyLabel.enabledTypes.append(customType2)
        policyLabel.customize { label in
            label.text = "已阅读并同意《用户协议》和《隐私声明》"
            label.font = k12Font
            label.numberOfLines = 0
            label.textColor = R.color.text_info()
            label.customColor[customType1] = R.color.themecolor()
            label.customColor[customType2] = R.color.themecolor()
            label.customSelectedColor[customType1] = R.color.themecolor()
            label.customSelectedColor[customType2] = R.color.themecolor()
            label.handleCustomTap(for: customType1) { element in
                self.delegate?.showTermsOfServices()
            }
            label.handleCustomTap(for: customType2) { element in
                self.delegate?.showPrivacy()
            }
        }
    }

    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            viewType = .login
            loginInputContentView.isHidden = false
            registerInputContentView.isHidden = true
            confirmButton.setTitle("登录", for: .normal)
            inputContentView.snp.updateConstraints { make in
                make.height.equalTo(345)
            }
        } else {
            viewType = .register
            loginInputContentView.isHidden = true
            registerInputContentView.isHidden = false
            confirmButton.setTitle("注册", for: .normal)
            inputContentView.snp.updateConstraints { make in
                make.height.equalTo(405)
            }
        }
    }

    @objc
    func forgetPassword() {
        delegate?.forgetPassword(mobile: "")
    }

    @objc
    func policyCheckBox() {
        registerCheckButton.isSelected = !registerCheckButton.isSelected
    }

    @objc
    func confirmButtonAction() {
        hideKeyboard()
        switch viewType {
        case .login:
            var loginMobile = ""
            var loginPassword = ""
            // MARK: - 暂时放开手机号码严格校验。
            if let mobile = loginMobileInputView.inputString, mobile.aj_isMobileNumber {
                loginMobile = mobile
            } else {
                loginMobileInputView.errorMsg = "请填写正确的手机号码"
                return
            }
            if let password = loginPasswordInputView.inputString, !password.isEmpty {
                loginPassword = password
            } else {
                loginPasswordInputView.errorMsg = "密码格式错误"
                return
            }
            delegate?.login(mobile: loginMobile, password: loginPassword)
        case .register:
            if !registerCheckButton.isSelected {
                SVProgressHUD.showInfo(withStatus: "请同意服务以及隐私协议")
                return
            }
            var registerMobile = ""
            var registerCode = ""
            var registerPassword = ""
            // MARK: - 暂时放开手机号码严格校验。
            if let mobile = registerMobileInputView.inputString, mobile.aj_isMobileNumber {
                registerMobile = mobile
            } else {
                loginMobileInputView.errorMsg = "请填写正确的手机号码"
                return
            }
            if let code = registerCodeInputView.inputString {
                registerCode = code
            } else {
                registerCodeInputView.errorMsg = "请输入验证码"
                return
            }
            if let password = registerPasswordInputView.inputString, password.count >= 6, password.count <= 12 {
                registerPassword = password
            } else {
                registerPasswordInputView.errorMsg = "请设置正确格式的密码"
                return
            }
            if !registerCode.isEmpty && !registerCode.isEmpty && !registerPassword.isEmpty {
                delegate?.register(mobile: registerMobile, code: registerCode, password: registerPassword)
            }
        }
    }

    override func initData() {
        configurePolicyLabel()
        registerCodeInputView.delegate = self
        loginPasswordInputView.textInput.delegate = self
        registerPasswordInputView.textInput.delegate = self
    }


    lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.login_content_image()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let label = UILabel.init()
        label.text = "欢迎使用"
        label.textColor = R.color.whitecolor()
        label.textAlignment = .left
        label.font = k34Font
        return label
    }()

    lazy var appNameLabel: UILabel = {
        let label = UILabel.init()
        label.text = "安杰智慧社区"
        label.textColor = R.color.whitecolor()
        label.textAlignment = .left
        label.font = k20Font
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.login_tips_icon()
        return view
    }()

    lazy var inputContentView: UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = 10
        view.backgroundColor = R.color.whitecolor()
        view.jk.addShadow(shadowColor: R.color.themecolor()!, shadowOffset: .zero, shadowOpacity: 0.2, shadowRadius: 10)
        return view
    }()

    lazy var segment: BetterSegmentedControl = {
        let seg = BetterSegmentedControl.init()
        seg.segments = LabelSegment.segments(withTitles: ["账号登录", "账号注册"],
                normalFont: k18Font,
                normalTextColor: R.color.text_info(),
                selectedFont: k18Font,
                selectedTextColor: R.color.themecolor())
        seg.setOptions([.backgroundColor(R.color.whitecolor()!), .indicatorViewBackgroundColor(R.color.whitecolor()!), .cornerRadius(5)])
        seg.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        return seg
    }()

    // MARK: - LoginView
    lazy var loginInputContentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var loginMobileInputView: MobileInputView = {
        let view = MobileInputView.init()
        return view
    }()

    lazy var loginPasswordInputView: PasswordInputView = {
        let view = PasswordInputView.init()
        view.placeHolders = "请输入密码"
        return view
    }()

    lazy var forgetPasswordButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("忘记密码?", for: .normal)
        button.titleLabel?.font = k14Font
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
        return button
    }()

    // MARK: - RegisterView
    lazy var registerInputContentView: UIView = {
        let view = UIView.init()
        return view
    }()

    lazy var registerMobileInputView: MobileInputView = {
        let view = MobileInputView.init()
        return view
    }()

    lazy var registerCodeInputView: VerificationCodeInputView = {
        let view = VerificationCodeInputView.init()
        return view
    }()

    lazy var registerPasswordInputView: PasswordInputView = {
        let view = PasswordInputView.init()
        return view
    }()

    lazy var registerCheckButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.login_checkbox_uncheck(), for: .normal)
        button.setImage(R.image.login_checkbox_checked(), for: .selected)
        button.setImage(R.image.login_checkbox_checked(), for: .highlighted)
        button.addTarget(self, action: #selector(policyCheckBox), for: .touchUpInside)
        return button
    }()

    private let policyLabel = ActiveLabel()

    // MARK: - Confirm Button
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.titleLabel?.font = k18Font
        button.backgroundColor = R.color.themecolor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()

    override func initializeView() {
        backgroundColor = R.color.whitecolor()
        addSubview(backgroundImage)
        addSubview(tipsLabel)
        addSubview(appNameLabel)
        addSubview(iconImageView)
        addSubview(inputContentView)
        inputContentView.addSubview(segment)
        inputContentView.addSubview(loginInputContentView)
        loginInputContentView.addSubview(loginMobileInputView)
        loginInputContentView.addSubview(loginPasswordInputView)
        loginInputContentView.addSubview(forgetPasswordButton)
        inputContentView.addSubview(registerInputContentView)
        registerInputContentView.addSubview(registerMobileInputView)
        registerInputContentView.addSubview(registerCodeInputView)
        registerInputContentView.addSubview(registerPasswordInputView)
        registerInputContentView.addSubview(registerCheckButton)
        registerInputContentView.addSubview(policyLabel)
        inputContentView.addSubview(confirmButton)
        registerInputContentView.isHidden = true
        bringSubviewToFront(iconImageView)

        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(kScreenWidth * 278 / 375)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin * 2)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(90)
        }

        appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(tipsLabel)
            make.right.equalTo(tipsLabel)
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin / 2)
            make.height.equalTo(20)
        }

        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin * 1.5)
            make.width.equalTo(150)
            make.height.equalTo(160)
            make.top.equalTo(50)
        }

        inputContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(192)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(345)
        }

        segment.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }

        //login
        loginInputContentView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(kMargin)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(inputHeight * 2 + kMargin + 20 + kMargin / 2)
        }

        loginMobileInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin / 2)
            make.height.equalTo(inputHeight)
        }

        loginPasswordInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(inputHeight)
            make.top.equalTo(loginMobileInputView.snp.bottom).offset(kMargin / 2)
        }

        forgetPasswordButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(120)
            make.top.equalTo(loginPasswordInputView.snp.bottom).offset(kMargin / 4)
        }

        //register
        registerInputContentView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(kMargin)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(inputHeight * 3 + kMargin + kMargin / 2 + 20 + kMargin / 2)
        }

        registerMobileInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin / 2)
            make.height.equalTo(inputHeight)
        }

        registerCodeInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(inputHeight)
            make.top.equalTo(registerMobileInputView.snp.bottom).offset(kMargin / 2)
        }

        registerPasswordInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(inputHeight)
            make.top.equalTo(registerCodeInputView.snp.bottom).offset(kMargin / 2)
        }

        registerCheckButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(20)
            make.top.equalTo(registerPasswordInputView.snp.bottom).offset(kMargin / 2)
        }

        policyLabel.snp.makeConstraints { make in
            make.left.equalTo(registerCheckButton.snp.right).offset(kMargin / 4)
            make.right.equalToSuperview()
            make.centerY.equalTo(registerCheckButton)
            make.height.equalTo(22)
        }

        confirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(43)
            make.bottom.equalToSuperview().offset(-kMargin)
        }
    }
}

extension LoginView: VerificationCodeInputViewDelegate {
    func sendCodeButtonPressed() {
        if let phoneNumber = registerMobileInputView.inputString, !phoneNumber.isEmpty {
            if phoneNumber.aj_isMobileNumber {
                registerCodeInputView.startCountDown()
                delegate?.sendCode(mobile: phoneNumber)
            } else {
                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "请输入手机号码")
        }
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(loginPasswordInputView.textInput) {
            confirmButtonAction()
            return true
        } else if textField.isEqual(registerPasswordInputView.textInput) {
            confirmButtonAction()
            return true
        }
        return false
    }
}
