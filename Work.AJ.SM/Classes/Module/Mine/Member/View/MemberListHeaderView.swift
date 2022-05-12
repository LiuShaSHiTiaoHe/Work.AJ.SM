//
//  MemberListHeaderView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit

class MemberListHeaderView: BaseView {

    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.ming_image_bg()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k20Font
        view.textColor = R.color.whiteColor()
        view.numberOfLines = 0
        return view
    }()
    
    override func initializeView() {
        self.addSubview(bgImageView)
        self.addSubview(locationLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
    }
    
    override func initData() {
        
    }

}
