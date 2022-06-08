//
//  NComRecordView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/12.
//

import UIKit

class NComRecordView: BaseView {
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
        view.titleLabel.text = "通话记录"
        view.titleLabel.textColor = R.color.whitecolor()
        view.backgroundColor = R.color.themecolor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        view.register(NComRecordCell.self, forCellReuseIdentifier: NComRecordCellIdentifier)
        return view
    }()
}
