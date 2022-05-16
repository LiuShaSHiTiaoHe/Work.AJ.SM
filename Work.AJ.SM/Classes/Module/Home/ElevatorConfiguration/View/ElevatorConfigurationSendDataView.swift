//
//  ElevatorConfigurationSendDataView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/8.
//

import UIKit

class ElevatorConfigurationSendDataView: BaseView {

    var dataString: String? {
        didSet{
            if let dataString = dataString {
                tipsLabel.text = dataString
            }
        }
    }
    
    override func initializeView() {
        addSubview(headerView)
        addSubview(tipsLabel)
        addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.text = "电梯配置"
        view.titleLabel.textColor = R.color.blackColor()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k16Font
        view.backgroundColor = R.color.backgroundColor()
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.backgroundColor()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "configurationSendDataCellIdentifier")
        return view
    }()

}
