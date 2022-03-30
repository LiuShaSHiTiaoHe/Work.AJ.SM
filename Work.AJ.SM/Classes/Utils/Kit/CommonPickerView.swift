//
//  CommonPickerView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/30.
//

import UIKit
import SwiftUI

class CommonPickerView: BaseView {

    override func initData() {
        
    }
    
    override func initializeView() {
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        self.addSubview(pickerView)
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.top.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin/2)
            make.centerY.equalTo(leftButton)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(leftButton)
            make.left.equalTo(leftButton.snp.right)
            make.right.equalTo(rightButton.snp.left)
            make.height.equalTo(30)
        }
        
        pickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(leftButton.snp.bottom).offset(5)
        }
    }
    
    lazy var leftButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k14Font
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView.init()
        return view
    }()
}
