//
//  CommonSelectButtonCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

protocol CommonSelectButtonCellDelegate: NSObjectProtocol {
    func letfButtonSelected(_ isSelected: Bool)
    func centerButtonSelected(_ isSelected: Bool)
    func rightButtonSelected(_ isSelected: Bool)
    
}

let CommonSelectButtonCellIdentifier = "CommonSelectButtonCellIdentifier"

class CommonSelectButtonCell: UITableViewCell {

    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var leftButtonName: String = ""{
        didSet {
            if !leftButtonName.isEmpty {
                leftButton.setTitle(leftButtonName, for: .normal)
            }
        }
    }
    
    var centerButtonName: String = "" {
        didSet {
            if !centerButtonName.isEmpty {
                centerButton.setTitle(centerButtonName, for: .normal)
            }
        }
    }
    
    var rightButtonName: String = ""{
        didSet {
            if !rightButtonName.isEmpty{
                rightButton.setTitle(rightButtonName, for: .normal)
            }
        }
    }
    
    weak var delegate: CommonSelectButtonCellDelegate?
    
    @objc
    func leftAction() {
        leftButton.isSelected = !leftButton.isSelected
        let state = leftButton.isSelected
        if state {
            leftButton.backgroundColor = R.color.themeColor()
            if rightButton.isSelected {
                rightButton.isSelected = false
                rightButton.backgroundColor = R.color.whiteColor()
            }
            if centerButton.isSelected {
                centerButton.isSelected = false
                centerButton.backgroundColor = R.color.whiteColor()
            }
        }else{
            leftButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.letfButtonSelected(state)
    }
    
    @objc
    func centerAction() {
        centerButton.isSelected = !centerButton.isSelected
        let state = centerButton.isSelected
        if state {
            centerButton.backgroundColor = R.color.themeColor()
            if rightButton.isSelected {
                rightButton.isSelected = false
                rightButton.backgroundColor = R.color.whiteColor()
            }
            
            if leftButton.isSelected {
                leftButton.isSelected = false
                leftButton.backgroundColor = R.color.whiteColor()
            }
            
        }else{
            centerButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.centerButtonSelected(state)
    }
    
    @objc
    func rightAction() {
        rightButton.isSelected = !rightButton.isSelected
        let state = rightButton.isSelected
        if state {
            rightButton.backgroundColor = R.color.themeColor()
            if leftButton.isSelected {
                leftButton.isSelected = false
                leftButton.backgroundColor = R.color.whiteColor()
            }
            if centerButton.isSelected {
                centerButton.isSelected = false
                centerButton.backgroundColor = R.color.whiteColor()
            }
        }else{
            rightButton.backgroundColor = R.color.whiteColor()
        }
        delegate?.rightButtonSelected(state)
    }
    
    func initializeView() {
        self.contentView.backgroundColor = R.color.whiteColor()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(centerButton)
        contentView.addSubview(rightButton)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        centerButton.snp.makeConstraints { make in
            make.right.equalTo(rightButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        leftButton.snp.makeConstraints { make in
            make.right.equalTo(centerButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
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
    
    lazy var leftButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1/kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var centerButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1/kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .selected)
        button.layer.borderColor = R.color.themeColor()!.cgColor
        button.layer.borderWidth = 1/kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(centerAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
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
