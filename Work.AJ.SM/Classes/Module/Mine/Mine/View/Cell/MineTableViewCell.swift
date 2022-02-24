//
//  MineTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import SnapKit

let MineTableViewCellIdentifier = "MineTableViewCellIdentifier"

class MineTableViewCell: UITableViewCell {
    
    var iconName: String? {
        didSet {
            if let iconName = iconName {
                iconImageView.image = UIImage.init(named: iconName)
            }
        }
    }
    
    var titleName: String? {
        didSet {
            if let titleName = titleName {
                titleLabel.text = titleName
            }
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.font = k14Font
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_icon_rightarrow()
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
        contentView.backgroundColor = R.color.whiteColor()
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(arrowImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
            make.left.equalToSuperview().offset(kMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*3)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(11)
            make.right.equalToSuperview().offset(-kMargin)
        }
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
