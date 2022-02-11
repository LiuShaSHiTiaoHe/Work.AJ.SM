//
//  PasswordInputView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/11.
//

import UIKit

class PasswordInputView: UIView {

    var errorMsg: String? {
        didSet {
            tipLabel.text = errorMsg
        }
    }
    private let titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = k16SysFont
        label.textColor = R.color.maintextColor()
        label.text = "密码"
        label.textAlignment = .left
        return label
    }()
    
    private(set) var textInput: UITextField = {
        let input = UITextField()
        input.font = k16Font
        input.placeholder = "请输入密码（长度6-12位）"
        input.clearButtonMode = .never
        input.autocorrectionType = .no
        input.isSecureTextEntry = true
        return input
    }()
    
    private let eyeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.login_secure(), for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        return button
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.separateColor()
        return view
    }()

    /// 展示一些错误的原因
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = k12Font
        label.textColor = R.color.errorRedColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        textInput.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        textInput.addTarget(self, action: #selector(textInputEditingEnd(_:)), for: .editingDidEnd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        self.backgroundColor = .clear
        
        self.addSubview(titleLabel)
        self.addSubview(textInput)
        self.addSubview(eyeButton)
        self.addSubview(seperator)
        self.addSubview(tipLabel)
        //5 + 30 + 5 + 1 + 5 + 10  56
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(kMargin/4)
            make.height.equalTo(30)
        }
        
        textInput.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalTo(titleLabel)
        }
        
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(textInput)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.width.height.equalTo(20)
        }
        
        seperator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1/kScale)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(textInput)
            make.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(seperator.snp.bottom).offset(kMargin/4)
        }
        
    }
    
    // MARK: -Actions
    @objc func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.seperator.backgroundColor = R.color.themeColor()
            self.titleLabel.textColor = R.color.themeColor()
            self.errorMsg = ""
        }
    }
    
    @objc func textInputEditingEnd(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.seperator.backgroundColor = R.color.separateColor()
            self.titleLabel.textColor = R.color.maintextColor()
            if sender.text?.count == 0 {
                self.cleanInput()
            }
        }
    }
    
    func cleanInput() {
        textInput.text = ""
    }
    
    @objc
    func showPassword() {
        
    }

}