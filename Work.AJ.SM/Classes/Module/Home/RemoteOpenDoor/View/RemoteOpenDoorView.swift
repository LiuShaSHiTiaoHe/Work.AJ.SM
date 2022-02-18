//
//  RemoteOpenDoorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit

class RemoteOpenDoorView: BaseView {

    override func initializeView(){
        
    }
    
    override func initData() {
        
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "远程开门"
        view.closeButton.setImage(R.image.common_close_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        return view
    }()
    
    lazy var offlineTipsContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.familyB_yellowColor()
        return view
    }()
    
    lazy var offlineTipsLogo: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var offlineTips: UILabel = {
        let view = UILabel()
        view.textColor = R.color.family_yellowColor()
        view.font = k12Font
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(RemoteOpenDoorCell.self, forCellReuseIdentifier: "RemoteOpenDoorCell")
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
}
