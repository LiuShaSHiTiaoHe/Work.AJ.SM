//
//  NumberOfUseCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit

protocol NumberOfUseCellDelegate: NSObjectProtocol {
    func single(isSelected: Bool)
    func multi(isSelected: Bool)
}

let NumberOfUseCellIdentifier = "NumberOfUseCellIdentifier"

class NumberOfUseCell: UITableViewCell {

    weak var delegate: NumberOfUseCellDelegate?
    
    @objc
    func singleAction() {
        singleButton.isSelected = !singleButton.isSelected
        let state = singleButton.isSelected
        if state {
            singleButton.backgroundColor = R.color.themecolor()
            if multyButton.isSelected {
                multyButton.isSelected = false
                multyButton.backgroundColor = R.color.whitecolor()
            }
        }else{
            singleButton.backgroundColor = R.color.whitecolor()
        }
        delegate?.single(isSelected: state)
    }
    
    @objc
    func multiAction() {
        multyButton.isSelected = !multyButton.isSelected
        let state = multyButton.isSelected
        if state {
            multyButton.backgroundColor = R.color.themecolor()
            if singleButton.isSelected {
                singleButton.isSelected = false
                singleButton.backgroundColor = R.color.whitecolor()
            }
        }else{
            multyButton.backgroundColor = R.color.whitecolor()
        }
        delegate?.multi(isSelected: state)
    }
    
    func initializeView() {
        contentView.backgroundColor = R.color.whitecolor()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(singleButton)
        contentView.addSubview(multyButton)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        multyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        singleButton.snp.makeConstraints { make in
            make.right.equalTo(multyButton.snp.left).offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
    }
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "使用次数"
        return view
    }()
    
    lazy var singleButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("单次", for: .normal)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .selected)
        button.layer.borderColor = R.color.themecolor()!.cgColor
        button.layer.borderWidth = 1/kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var multyButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("无限次", for: .normal)
        button.titleLabel?.font = k12Font
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .selected)
        button.layer.borderColor = R.color.themecolor()!.cgColor
        button.layer.borderWidth = 1/kScale
        button.layer.cornerRadius = 4
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        singleButton.addTarget(self, action: #selector(singleAction), for: .touchUpInside)
        multyButton.addTarget(self, action: #selector(multiAction), for: .touchUpInside)
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
