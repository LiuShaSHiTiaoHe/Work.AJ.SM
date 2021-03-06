//
//  VerificationCodeInputView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/11.
//

import UIKit

protocol VerificationCodeInputViewDelegate: NSObjectProtocol {
    func sendCodeButtonPressed()
}

class VerificationCodeInputView: UIView {

    weak var delegate: VerificationCodeInputViewDelegate?

    var errorMsg: String? {
        didSet {
            tipLabel.text = errorMsg
        }
    }

    var inputString: String? {
        get {
            return textInput.text
        }
    }

    var placeHolders: String = "" {
        didSet {
            textInput.placeholder = placeHolders
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = k16Font
        label.textColor = R.color.text_title()
        label.text = "验证码"
        label.textAlignment = .left
        return label
    }()

    private(set) var textInput: UITextField = {
        let input = UITextField()
        input.font = k14Font
        input.placeholder = "请输入密码"
        input.clearButtonMode = .never
        input.autocorrectionType = .no
        input.keyboardType = .numberPad
        return input
    }()

    private let sendCodeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("发送验证码", for: .normal)
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .right
        return button
    }()

    lazy var countDownLabel: CountdownLabel = {
        let label = CountdownLabel.init()
        label.timeFormat = "ss"
        label.textAlignment = .right
        label.textColor = R.color.themecolor()
        label.font = k16Font
        label.animationType = .Evaporate
        label.countdownDelegate = self
        return label
    }()

    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.separator()
        return view
    }()

    /// 展示一些错误的原因
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = k10Font
        label.textColor = R.color.sub_red()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        sendCodeButton.addTarget(self, action: #selector(sendCodeButtonAction), for: .touchUpInside)
        textInput.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        textInput.addTarget(self, action: #selector(textInputEditingEnd(_:)), for: .editingDidEnd)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        backgroundColor = .clear

        addSubview(titleLabel)
        addSubview(textInput)
        addSubview(sendCodeButton)
        addSubview(countDownLabel)
        addSubview(seperator)
        addSubview(tipLabel)
        countDownLabel.isHidden = true
        //5 + 30 + 5 + 1 + 5 + 10  56
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(kMargin / 4)
            make.height.equalTo(30)
        }

        textInput.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(kMargin / 2)
            make.right.equalToSuperview().offset(-100)
            make.centerY.equalTo(titleLabel)
        }

        sendCodeButton.snp.makeConstraints { make in
            make.left.equalTo(textInput.snp.right).offset(kMargin / 2)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin / 2)
            make.centerY.equalTo(textInput)
        }

        countDownLabel.snp.makeConstraints { make in
            make.edges.equalTo(sendCodeButton)
        }

        seperator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin / 4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1 / kScale)
        }

        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(textInput)
            make.right.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(seperator.snp.bottom).offset(kMargin / 4)
        }

    }

    // MARK: -Actions
    @objc private func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.seperator.backgroundColor = R.color.themecolor()
            self.titleLabel.textColor = R.color.themecolor()
        }
    }

    @objc private func textInputEditingEnd(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.seperator.backgroundColor = R.color.separator()
            self.titleLabel.textColor = R.color.text_title()
            if sender.text?.count == 0 {
                self.cleanInput()
            }
        }
    }

    private func cleanInput() {
        textInput.text = ""
    }

    ///发送验证码
    @objc
    private func sendCodeButtonAction() {
        delegate?.sendCodeButtonPressed()
    }

    private func setupCountDownTime(_ minutes: TimeInterval) {
        sendCodeButton.isHidden = true
        countDownLabel.isHidden = false
        countDownLabel.dispose()
        countDownLabel.setCountDownTime(minutes: minutes)
        countDownLabel.start {
        }
    }

    func startCountDown() {
        setupCountDownTime(59)
    }
}

extension VerificationCodeInputView: CountdownLabelDelegate {
    func countdownFinished() {
        sendCodeButton.setTitle("重新发送", for: .normal)
        sendCodeButton.isHidden = false
        countDownLabel.isHidden = true
    }
}
