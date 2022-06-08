//
//  ElevatorConfigurationView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/7.
//

import UIKit

class ElevatorConfigurationView: BaseView {

    override func initData() {
        tipsLabel.text = HomeRepository.shared.getCurrentUnitName()
    }
    
    override func initializeView() {
        backgroundColor = R.color.bg()
        addSubview(headerView)
        addSubview(titleContentView)
        titleContentView.addSubview(locationIcon)
        titleContentView.addSubview(tipsLabel)
        addSubview(tableView)
        addSubview(confirmButton)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        titleContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(50)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(tipsLabel.snp.left).offset(-kMargin/2)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleContentView.snp.bottom).offset(kMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
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
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whitecolor()
        view.titleLabel.text = "电梯配置"
        view.titleLabel.textColor = R.color.blackcolor()
        return view
    }()
    
    lazy var titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        return view
    }()
    
    lazy var locationIcon: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_image_location()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.font = k15Font
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
 
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCellIdentifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.layer.cornerRadius = 20.0
        button.backgroundColor = R.color.themecolor()
        return button
    }()
    

}
