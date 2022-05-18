//
//  RemoteIntercomView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit

class RemoteIntercomView: BaseView {

    override func initializeView(){
        addSubview(headerView)
        addSubview(offlineTipsContentView)
        offlineTipsContentView.addSubview(offlineTipsLogo)
        offlineTipsContentView.addSubview(offlineTips)
        addSubview(tipsLabel)
        addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        offlineTipsContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(40)
        }
        
        offlineTipsLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(18)
        }
        
        offlineTips.snp.makeConstraints { make in
            make.left.equalTo(offlineTipsLogo.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(offlineTipsContentView.snp.bottom)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "门禁对讲"
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.textColor = R.color.blackColor()
        return view
    }()
    
    lazy var offlineTipsContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bg_yellow()
        return view
    }()
    
    lazy var offlineTipsLogo: UIImageView = {
        let view = UIImageView()
        view.image = R.image.common_info_yellow()
        return view
    }()
    
    lazy var offlineTips: UILabel = {
        let view = UILabel()
        view.textColor = R.color.sub_yellow()
        view.font = k12Font
        view.text = "设备离线状态下，无法远程开门和视频通话"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = R.color.themeColor()
        view.font = k15Font
        view.backgroundColor = R.color.bg()
        view.text = "请选择视频通话的门禁设备"
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(RemoteOpenDoorCell.self, forCellReuseIdentifier: RemoteOpenDoorCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        return view
    }()
}
