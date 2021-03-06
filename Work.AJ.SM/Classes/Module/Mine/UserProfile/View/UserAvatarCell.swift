//
//  UserAvatarCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/30.
//

import UIKit

let UserAvatarCellIdentifier = "UserAvatarCellIdentifier"

class UserAvatarCell: UITableViewCell {

    private func initializeView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatar)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
        }
        
        avatar.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    lazy var nameLabel: UILabel = {
        let view = UILabel.init()
        view.font = k16Font
        view.textColor = R.color.text_title()
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
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
