//
//  CommonPhoneNumberCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit

let CommonPhoneNumberCellIdentifier = "CommonPhoneNumberCellIdentifier"

class CommonPhoneNumberCell: UITableViewCell {

    var placeholder: String? {
        didSet {
            phoneInput.placeholder = placeholder
        }
    }
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var phoneInput: UITextField = {
        let view = UITextField.init()
        view.textColor = R.color.secondtextColor()
        view.font = k14Font
        view.textAlignment = .right
        view.keyboardType = .phonePad
        return view
    }()
    
    lazy var errorMsg: UILabel = {
        let view = UILabel()
        view.textColor = R.color.errorRedColor()
        view.font = k11Font
        view.textAlignment = .right
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        self.selectionStyle = .none
        contentView.backgroundColor = R.color.whiteColor()
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneInput)
        contentView.addSubview(errorMsg)
        
        errorMsg.isHidden = true
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        phoneInput.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(30)
            make.left.equalTo(contentView.snp.centerX).offset(-kMargin)
            make.centerY.equalToSuperview()
        }
        
        errorMsg.snp.makeConstraints { make in
            make.right.equalTo(phoneInput)
            make.top.equalTo(phoneInput.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        errorMsg.isHidden = true
        
        phoneInput.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        phoneInput.addTarget(self, action: #selector(textInputEditingEnd(_:)), for: .editingDidEnd)
    }
    
    @objc func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.clearErrorMsg()
        }
    }
    
    @objc func textInputEditingEnd(_ sender: UITextField) {
        DispatchQueue.main.async {
            if let phoneNumber = sender.text {
                if phoneNumber.count == 0  {
                    self.showErrorMsg("手机号不能为空")
                }else{
                    if phoneNumber.jk.isValidMobile {
                        self.clearErrorMsg()
                    }else{
                        self.showErrorMsg("请填写正确的手机号")
                    }
                }
            }else{
                self.showErrorMsg("请填写正确的手机号")
            }
 
        }
    }
    
    func showErrorMsg(_ msg: String){
        errorMsg.isHidden = false
        errorMsg.text = msg
    }
    
    func clearErrorMsg() {
        errorMsg.isHidden = true
        errorMsg.text = ""
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
