//
//  FaceUploadRoleSelectCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/16.
//

import UIKit

protocol FaceUploadRoleSelectCellDelegate: NSObjectProtocol {
    func firstButtonSelected(_ isSelected: Bool)
    func secondButtonSelected(_ isSelected: Bool)
    func thirdButtonSelected(_ isSelected: Bool)
    func fourthButtonSelected(_ isSelected: Bool)
}

let FaceUploadRoleSelectCellIdentifier = "FaceUploadRoleSelectCellIdentifier"

class FaceUploadRoleSelectCell: UITableViewCell {

    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    var firstButtonName: String = "" {
        didSet {
            if !firstButtonName.isEmpty {
                firstButton.isHidden = false
                firstButton.setTitle(firstButtonName, for: .normal)
            }
        }
    }

    var secondButtonName: String = "" {
        didSet {
            if !secondButtonName.isEmpty {
                secondButton.isHidden = false
                secondButton.setTitle(secondButtonName, for: .normal)
            }
        }
    }

    var thirdButtonName: String = "" {
        didSet {
            if !thirdButtonName.isEmpty {
                thirdButton.isHidden = false
                thirdButton.setTitle(thirdButtonName, for: .normal)
            }
        }
    }

    var fourthButtonName: String = "" {
        didSet {
            if !fourthButtonName.isEmpty {
                fourthButton.isHidden = false
                fourthButton.setTitle(fourthButtonName, for: .normal)
            }
        }
    }
    
    var defaultValue: Int = -1 {
        didSet {
            switch defaultValue {
            case 0:
                firstAction()
            case 1:
                secondAction()
            case 2:
                thirdAction()
            case 3:
                fourthAction()
            default:
                break
            }
        }
    }
    weak var delegate: FaceUploadRoleSelectCellDelegate?

    @objc
    func firstAction() {
        firstButton.isSelected.toggle()
        if firstButton.isSelected {
            firstButton.backgroundColor = R.color.themeColor()
            secondButton.isSelected = false
            thirdButton.isSelected = false
            fourthButton.isSelected = false
            secondButton.backgroundColor = R.color.whiteColor()
            thirdButton.backgroundColor = R.color.whiteColor()
            fourthButton.backgroundColor = R.color.whiteColor()
        } else {
            firstButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.firstButtonSelected(firstButton.isSelected)
    }

    @objc
    func secondAction() {
        secondButton.isSelected.toggle()
        if secondButton.isSelected {
            secondButton.backgroundColor = R.color.themeColor()
            firstButton.isSelected = false
            thirdButton.isSelected = false
            fourthButton.isSelected = false
            firstButton.backgroundColor = R.color.whiteColor()
            thirdButton.backgroundColor = R.color.whiteColor()
            fourthButton.backgroundColor = R.color.whiteColor()
        } else {
            secondButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.secondButtonSelected(secondButton.isSelected)
    }

    @objc
    func thirdAction() {
        thirdButton.isSelected.toggle()
        if thirdButton.isSelected {
            thirdButton.backgroundColor = R.color.themeColor()
            secondButton.isSelected = false
            firstButton.isSelected = false
            fourthButton.isSelected = false
            secondButton.backgroundColor = R.color.whiteColor()
            firstButton.backgroundColor = R.color.whiteColor()
            fourthButton.backgroundColor = R.color.whiteColor()
        } else {
            thirdButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.thirdButtonSelected(thirdButton.isSelected)
    }
    
    @objc
    func fourthAction() {
        fourthButton.isSelected.toggle()
        if fourthButton.isSelected {
            fourthButton.backgroundColor = R.color.themeColor()
            secondButton.isSelected = false
            thirdButton.isSelected = false
            firstButton.isSelected = false
            secondButton.backgroundColor = R.color.whiteColor()
            thirdButton.backgroundColor = R.color.whiteColor()
            firstButton.backgroundColor = R.color.whiteColor()
        } else {
            fourthButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.fourthButtonSelected(fourthButton.isSelected)
    }

    func initializeView() {
        contentView.backgroundColor = R.color.whiteColor()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(firstButton)
        contentView.addSubview(secondButton)
        contentView.addSubview(thirdButton)
        contentView.addSubview(fourthButton)
        
        firstButton.isHidden = true
        secondButton.isHidden = true
        thirdButton.isHidden = true
        fourthButton.isHidden = true
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }

        fourthButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(24)
        }

        thirdButton.snp.makeConstraints { make in
            make.right.equalTo(fourthButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(24)
        }

        secondButton.snp.makeConstraints { make in
            make.right.equalTo(thirdButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        
        firstButton.snp.makeConstraints { make in
            make.right.equalTo(secondButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(24)
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

    lazy var firstButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1 / kScale
        button.layer.cornerRadius = 4
        return button
    }()

    lazy var secondButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1 / kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1 / kScale
        button.layer.cornerRadius = 4
        return button
    }()

    lazy var fourthButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1 / kScale
        button.layer.cornerRadius = 4
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        firstButton.addTarget(self, action: #selector(firstAction), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondAction), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(thirdAction), for: .touchUpInside)
        fourthButton.addTarget(self, action: #selector(fourthAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
