//
//  BleOpenDoorStyleCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit

let BleOpenDoorStyleCellIdentifier = "BleOpenDoorStyleCellIdentifier"

class BleOpenDoorStyleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(switchView)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.top.equalToSuperview().offset(kMargin)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
        }
    }
    
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k16Font
        view.textAlignment = .left
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch.init()
        view.tintColor = R.color.owner_greenColor()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
