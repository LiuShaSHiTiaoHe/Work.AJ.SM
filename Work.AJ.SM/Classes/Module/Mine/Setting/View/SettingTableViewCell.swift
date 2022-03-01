//
//  SettingTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/1.
//

import UIKit

let SettingTableViewCellIdentifier = "SettingTableViewCellIdentifier"

class SettingTableViewCell: UITableViewCell {

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
        contentView.addSubview(arrowImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin*2)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin/2)
            make.width.equalTo(6)
            make.height.equalTo(11)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = R.color.maintextColor()
        view.font = k14Font
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var arrowImageView: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.base_icon_rightarrow()
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
