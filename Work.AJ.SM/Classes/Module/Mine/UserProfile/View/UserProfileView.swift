//
//  UserProfileView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit

class UserProfileView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        addSubview(headerView)
        addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "用户信息"
        view.titleLabel.textColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        view.backgroundColor = R.color.themeColor()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.backgroundColor()
        view.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCellIdentifier)
        view.register(UserAvatarCell.self, forCellReuseIdentifier: UserAvatarCellIdentifier)
        return view
    }()
    
    

}
