//
//  RemoteOpenDoorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit
import SnapKit

let RemoteOpenDoorCellIdentifier = "RemoteOpenDoorCell"

class RemoteOpenDoorView: BaseView {

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
        view.titleLabel.text = "远程开门"
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whitecolor()
        view.titleLabel.textColor = R.color.blackcolor()
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
        view.textColor = R.color.themecolor()
        view.font = k15Font
        view.backgroundColor = R.color.bg()
        view.text = "请选择设备开门"
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
