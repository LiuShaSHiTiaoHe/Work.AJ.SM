//
//  CommonHeaderView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/15.
//

import UIKit
import SnapKit

class CommonHeaderView: UIView {
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_back_white(), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = k18Font
        label.textColor = R.color.whiteColor()
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = k14Font
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.lineColor()
        return view
    }()
    
    private func initializeView() {
        self.backgroundColor = R.color.themebackgroundColor()
        
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        self.addSubview(lineView)
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset((20 + kStateHeight - kOriginTitleAndStateHeight)/2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*3)
            make.centerY.equalTo(closeButton)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*4)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(closeButton)
            make.height.equalTo(30)
            make.width.equalTo(kMargin*3)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1/kScale)
        }
            
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
