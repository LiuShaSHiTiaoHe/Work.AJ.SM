//
//  AddGuestQRCodeView.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import UIKit

class AddGuestQRCodeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        backgroundColor = R.color.bg()
        addSubview(headerView)
        addSubview(titleContentView)
        titleContentView.addSubview(locationIcon)
        titleContentView.addSubview(tipsLabel)
        addSubview(tableView)
        addSubview(desLabel)
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
            make.height.equalTo(200)
        }
        
        desLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(desLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
        locationIcon.isHidden = true
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whitecolor()
        view.titleLabel.text = "设置访客二维码"
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
        view.register(TimeSelectCell.self, forCellReuseIdentifier: TimeSelectCellIdentifier)
        view.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCellIdentifier)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        view.tableFooterView = UIView()
        return view
    }()
    
    lazy var desLabel: UILabel = {
        let view = UILabel()
        view.font = k15Font
        view.textColor = R.color.sub_red()
        view.numberOfLines = 0
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "温馨提示：\n\n如您拥有多楼层权限，请给访客填写指定的到访楼层；\n如您未填写指定到访楼层，则访客可访问您的所有楼层。"
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
