//
//  UserAvatarCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/30.
//

import UIKit

let UserAvatarCellIdentifier = "UserAvatarCellIdentifier"

class UserAvatarCell: UITableViewCell {

    private func initializeView() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(arrowImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
        }
        
        avatar.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin*3)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin/2)
            make.width.equalTo(6)
            make.height.equalTo(11)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var nameLabel: UILabel = {
        let view = UILabel.init()
        view.font = k16Font
        view.textColor = R.color.maintextColor()
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
    
    lazy var arrowImageView: UIImageView = {
        let view = UIImageView.init()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
