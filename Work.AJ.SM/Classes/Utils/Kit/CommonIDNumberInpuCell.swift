//
//  CommonIDNumberInpuCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/10.
//

import UIKit

let CommonIDNumberInpuCellIdentifier = "CommonIDNumberInpuCellIdentifier"

class CommonIDNumberInpuCell: UITableViewCell {

    var placeholder: String? {
        didSet {
            IDNumberInput.placeholder = placeholder
        }
    }

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()

    lazy var IDNumberInput: UITextField = {
        let view = UITextField.init()
        view.textColor = R.color.text_info()
        view.font = k14Font
        view.textAlignment = .right
        return view
    }()

    lazy var errorMsg: UILabel = {
        let view = UILabel()
        view.textColor = R.color.sub_red()
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
        selectionStyle = .none
        contentView.backgroundColor = R.color.whitecolor()
        contentView.addSubview(nameLabel)
        contentView.addSubview(IDNumberInput)
        contentView.addSubview(errorMsg)

        errorMsg.isHidden = true

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }

        IDNumberInput.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(30)
            make.left.equalTo(contentView.snp.centerX).offset(-kMargin)
            make.centerY.equalToSuperview()
        }

        errorMsg.snp.makeConstraints { make in
            make.right.equalTo(IDNumberInput)
            make.top.equalTo(IDNumberInput.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(200)
        }

        errorMsg.isHidden = true

        IDNumberInput.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        IDNumberInput.addTarget(self, action: #selector(textInputEditingEnd(_:)), for: .editingDidEnd)
    }

    @objc func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.clearErrorMsg()
        }
    }

    @objc func textInputEditingEnd(_ sender: UITextField) {
        DispatchQueue.main.async {
            if let phoneNumber = sender.text {
                if phoneNumber.count == 0 {
                    self.showErrorMsg("身份证号不能为空")
                } else {
                    if phoneNumber.jk.isValidIDCardNumStrict {
                        self.clearErrorMsg()
                    } else {
                        self.showErrorMsg("请填写正确的身份证号")
                    }
                }
            } else {
                self.showErrorMsg("请填写正确的身份证号")
            }

        }
    }

    func showErrorMsg(_ msg: String) {
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
