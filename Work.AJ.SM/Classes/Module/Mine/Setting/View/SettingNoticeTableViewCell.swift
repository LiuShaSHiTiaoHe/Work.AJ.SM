//
//  SettingNoticeTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/1.
//

import UIKit


let SettingNoticeTableViewCellIdentifier = "SettingNoticeTableViewCellIdentifier"

class SettingNoticeTableViewCell: UITableViewCell {
    
    var row: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchView)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(kMargin)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.centerY.equalToSuperview()
        }
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k14Font
        view.textAlignment = .left
        return view
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch.init()
        view.tintColor = R.color.owner_greenColor()
        view.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return view
    }()
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        if let row = row {
            switch row {
            case 0:
                ud.inAppNotification = sender.isOn
                break
            case 1:
                ud.vibrationAvailable = sender.isOn
                break
            case 2:
                ud.ringtoneAvailable = sender.isOn
                break
            case 3:
                ud.allowVisitorCall = sender.isOn
                break
            default:
                break
            }
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
