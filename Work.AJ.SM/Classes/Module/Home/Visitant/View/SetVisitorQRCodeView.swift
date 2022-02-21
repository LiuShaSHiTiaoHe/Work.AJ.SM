//
//  SetVisitorQRCodeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit

class SetVisitorQRCodeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        self.addSubview(headerView)
        self.addSubview(titleContentView)
        titleContentView.addSubview(locationIcon)
        titleContentView.addSubview(tipsLabel)
        self.addSubview(tableView)
        
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
            make.right.equalTo(tipsLabel.snp.left)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleContentView.snp.bottom)
        }
        
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.text = "设置访客二维码"
        view.titleLabel.textColor = R.color.blackColor()
        return view
    }()
    
    lazy var titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var locationIcon: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_image_location()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k15Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
 
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SetVisitorQRCodeCell.self, forCellReuseIdentifier: SetVisitorQRCodeCellIdentifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    

}
