//
//  MemberListCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit
import SnapKit

let MemberListCellIdentifier = "MemberListCell"

protocol MemberListCellDelegate: NSObjectProtocol {
    func deleteMember()
}

class MemberListCell: UITableViewCell {

    weak var delegate: MemberListCellDelegate?
    
    var data: MemberModel? {
        didSet {
            if let member = data {
                if let userType = member.userType {
                    if userType == "O" {
                        memberType.text = "业主"
                        memberType.textColor = R.color.owner_greenColor()
                        memberType.backgroundColor = R.color.ownerB_greenColor()
                    }
                    if userType == "F" {
                        memberType.text = "家属"
                        memberType.textColor = R.color.family_yellowColor()
                        memberType.backgroundColor = R.color.familyB_yellowColor()
                    }
                    if userType == "R" {
                        memberType.text = "访客"
                        memberType.textColor = R.color.family_yellowColor()
                        memberType.backgroundColor = R.color.familyB_yellowColor()
                    }
                }
                if let realName = member.realName, !realName.isEmpty {
                    nameLabel.text = realName
                }else{
                    if let userName = member.userName, !userName.isEmpty {
                        nameLabel.text = userName
                    }else{
                        nameLabel.text = "用户"
                    }
                }
                if let phone = member.mobile {
                    phoneLabel.text = phone.jk.hidePhone()
                }
                
                if let cUserID = ud.userID,let userID = member.userID?.jk.intToString  {
                    if cUserID == userID {
                        roleLabel.isHidden = false
                        deleteButton.isHidden = true
                        roleLabel.text = "本人"
                    }else{
                        roleLabel.isHidden = true
                        deleteButton.isHidden = false
                    }
                }else{
                    roleLabel.isHidden = true
                    deleteButton.isHidden = true
                }
                
                if let status = member.state {
                    switch status {
                    case "P":
                        statusLabel.text = "待审核"
                    case "N":
                        statusLabel.text = "已认证"
                    case "H":
                        statusLabel.text = "失效"
                    case "E":
                        statusLabel.text = "过期"
                    default:
                        break
                    }
                }
            }

        }
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        contentView.addSubview(bgView)
        bgView.addSubview(memberType)
        bgView.addSubview(nameLabel)
        bgView.addSubview(phoneLabel)
        bgView.addSubview(statusLabel)
        bgView.addSubview(roleLabel)
        bgView.addSubview(deleteButton)
        roleLabel.isHidden = true
        
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        memberType.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(20)
            make.width.equalTo(30)
            make.top.equalToSuperview().offset(23)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(memberType.snp.right).offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.width.equalTo(kMargin*2)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
        }
        
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var memberType: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = k12Font
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = k15Font
        label.textColor = R.color.maintextColor()
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel.init()
        label.font = k15Font
        label.textColor = R.color.maintextColor()
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel.init()
        label.font = k15Font
        label.textColor = R.color.maintextColor()
        return label
    }()
    
    lazy var roleLabel: UILabel = {
        let label = UILabel.init()
        label.font = k15Font
        label.textColor = R.color.maintextColor()
        label.textAlignment = .right
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.base_icon_trash(), for: .normal)
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()
    
    
    @objc
    func deleteAction() {
        delegate?.deleteMember()
    }
    
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
