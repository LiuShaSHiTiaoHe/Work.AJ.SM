//
//  MineView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

class MineView: BaseView {

    lazy var headerView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.image = R.image.defaultavatar()
        view.layer.corner(30)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k18Font
        view.textColor = R.color.whiteColor()
        return view
    }()
    
    lazy var phoneLabel: UILabel = {
        let view = UILabel()
        view.font = k18Font
        view.textColor = R.color.whiteColor()
        return view
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.mine_notice_icon()!, for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        if #available(iOS 13.0, *) {
            let view = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
            view.register(MineTableViewCell.self, forCellReuseIdentifier: MineTableViewCellIdentifier)
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.bg()
            return view
        } else {
            // Fallback on earlier versions
            let view = UITableView.init(frame: CGRect.zero, style: .grouped)
            view.register(MineTableViewCell.self, forCellReuseIdentifier: MineTableViewCellIdentifier)
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.bg()
            return view
        }
    }()
    
    override func initializeView(){
        addSubview(headerView)
        headerView.addSubview(avatar)
        headerView.addSubview(nameLabel)
        headerView.addSubview(phoneLabel)
        headerView.addSubview(messageButton)
        addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight + 60)
        }
        
        avatar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*2)
            make.bottom.equalToSuperview().offset(-kMargin)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(avatar)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(avatar.snp.bottom)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(avatar)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    override func initData() {
        headerView.isUserInteractionEnabled = true
    }

}
