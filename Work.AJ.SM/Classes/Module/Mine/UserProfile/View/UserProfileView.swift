//
//  UserProfileView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit

class UserProfileView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "用户信息"
        view.titleLabel.textColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        view.backgroundColor = R.color.themeColor()
        return view
    }()
    
    

}
