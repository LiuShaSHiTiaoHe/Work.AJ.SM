//
//  ElevatorMaskConfigurationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/5.
//

import UIKit

class ElevatorMaskConfigurationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        
    }
    
    override func initUI() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(kMargin/2)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "写配置卡"
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(ElevatorMaskConfigurationCell.self, forCellReuseIdentifier: ElevatorMaskConfigurationCellIdentifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.layer.cornerRadius = 20.0
        button.backgroundColor = R.color.themecolor()
        return button
    }()

}
