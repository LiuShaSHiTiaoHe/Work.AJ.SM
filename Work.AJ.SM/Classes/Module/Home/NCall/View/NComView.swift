//
//  NComView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit

class NComView: BaseView {

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
        view.titleLabel.text = "N方对讲"
        view.rightButton.isHidden = false
        view.rightButton.setTitle("通话记录", for: .normal)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        return view
    }()
}
