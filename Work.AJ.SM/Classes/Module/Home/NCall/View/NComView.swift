//
//  NComView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/12.
//

import UIKit

class NComView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        self.addSubview(headerView)
        self.addSubview(tableView)
        
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
        view.titleLabel.text = "N方对讲"
        view.rightButton.isHidden = false
        view.rightButton.setTitle("记录", for: .normal)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
}
