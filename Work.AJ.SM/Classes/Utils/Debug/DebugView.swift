//
//  DebugView.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/6/6.
//

import UIKit
import SnapKit
import SwiftEntryKit
import SVProgressHUD

class DebugView: BaseView {
    
    @objc
    private func closeView() {
        SwiftEntryKit.dismiss()
    }
    
    @objc
    private func confirmAction() {
        if let host = hostInput.text, !host.isEmpty, let servicePath = servicePathInput.text, !servicePath.isEmpty {
            logger.info("host ===> \(host) \n  servicePath ===> \(servicePath)")
            ud.appHost = host
            ud.appServicePath = servicePath
            SwiftEntryKit.dismiss(.displayed) {
                SVProgressHUD.showSuccess(withStatus: "保存成功")
            }
        } else {
            SVProgressHUD.showError(withStatus: "输入数据错误")
        }
    }
        
    override func initData() {
        
        servicePathInput.text = ud.appServicePath
        hostInput.text = ud.appHost
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
    }
    
    
    override func initializeView() {
        self.addSubview(titleLabel)
        self.addSubview(closeButton)
        self.addSubview(hostTipsLabel)
        self.addSubview(hostInput)
        self.addSubview(servicePathTipsLabel)
        self.addSubview(servicePathInput)
        self.addSubview(tipsLabel)
        self.addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin/2)
            make.left.equalToSuperview().offset(kMargin*3)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.height.equalTo(kMargin*2)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(titleLabel)
        }
        
        hostTipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*2)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*2)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        hostInput.snp.makeConstraints { make in
            make.left.right.equalTo(hostTipsLabel)
            make.height.equalTo(30)
            make.top.equalTo(hostTipsLabel.snp.bottom).offset(kMargin/2)
        }
        
        servicePathTipsLabel.snp.makeConstraints { make in
            make.left.right.equalTo(hostTipsLabel)
            make.height.equalTo(30)
            make.top.equalTo(hostInput.snp.bottom).offset(kMargin)
        }
        
        servicePathInput.snp.makeConstraints { make in
            make.left.right.equalTo(hostTipsLabel)
            make.height.equalTo(30)
            make.top.equalTo(servicePathTipsLabel.snp.bottom).offset(kMargin/2)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(confirmButton.snp.top).offset(-kMargin)
            make.top.equalTo(servicePathInput.snp.bottom).offset(kMargin/2)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.bottom.equalToSuperview().offset(-kMargin)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "测试包修改服务器地址"
        view.font = k18Font
        view.textAlignment = .center
        view.textColor = R.color.text_title()
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_close_black(), for: .normal)
        return button
    }()
    
    lazy var hostTipsLabel: UILabel = {
        let view = UILabel()
        view.text = "服务器地址"
        view.font = k14Font
        view.textAlignment = .left
        view.textColor = R.color.text_content()
        return view
    }()
    
    lazy var hostInput: UITextField = {
        let textfield = UITextField.init()
        textfield.placeholder = ud.appHost
        textfield.textColor = R.color.text_title()
        textfield.font = k16Font
        textfield.backgroundColor = R.color.bg_blue()
        return textfield
    }()
    

    lazy var servicePathTipsLabel: UILabel = {
        let view = UILabel()
        view.text = "ServicePath"
        view.font = k14Font
        view.textAlignment = .left
        view.textColor = R.color.text_content()
        return view
    }()
    
    lazy var servicePathInput: UITextField = {
        let textfield = UITextField.init()
        textfield.placeholder = ud.appServicePath
        textfield.textColor = R.color.text_title()
        textfield.font = k16Font
        textfield.backgroundColor = R.color.bg_blue()
        return textfield
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .left
        view.textColor = R.color.themecolor()
        view.font = k16Font
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = R.color.themecolor()
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = k16Font
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        return button
    }()
}
