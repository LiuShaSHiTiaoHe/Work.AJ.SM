//
//  AppUpdateView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/26.
//

import UIKit
import SwiftEntryKit
import SnapKit

class AppUpdateView: BaseView {
    
    private var version: String = ""
    private var isAutoCheck: Bool = false
    
    override func initData() {
        cancelButton.addTarget(self , action: #selector(cancleAction), for: .touchUpInside)
        confirmButton.addTarget(self , action: #selector(confirmAction), for: .touchUpInside)
    }
    
    @objc
    func cancleAction() {
        if isAutoCheck {
            AppUpgradeManager.shared.cacheCheckedVersion(version: version)
        }
        SwiftEntryKit.dismiss()
    }
    
    @objc
    func confirmAction() {
        if let url = URL.init(string: kAppStoreUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            SwiftEntryKit.dismiss()
            return
        }
    }
    
    func configData(autoCheck: Bool, remoteVersion: String, description: String, force: Bool) {
        if force {
            cancelButton.isHidden = true
            confirmButton.snp.remakeConstraints { make  in
                make.left.equalToSuperview().offset(kMargin)
                make.right.equalToSuperview().offset(-kMargin)
                make.bottom.equalToSuperview().offset(-kMargin)
                make.height.equalTo(50)
            }
        }
        isAutoCheck = autoCheck
        titleLabel.text = "发现新的版本"
        contentTextView.text = description
        version = remoteVersion
        versionLabel.text = "v\(version)"
    }
            
    override func initializeView(){
        self.addSubview(titleLabel)
        self.addSubview(versionLabel)
        self.addSubview(contentTextView)
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
                
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(kMargin)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin/2)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalToSuperview().offset(-kMargin - kMargin - 50)
        }

        cancelButton.snp.makeConstraints { make  in
            make.left.equalToSuperview().offset(kMargin)
            make.bottom.equalToSuperview().offset(-kMargin)
            make.height.equalTo(34)
            make.right.equalTo(self.snp.centerX).offset(-kMargin/2)
        }
        
        confirmButton.snp.makeConstraints { make  in
            make.left.equalTo(self.snp.centerX).offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalToSuperview().offset(-kMargin)
            make.height.equalTo(34)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = k20BoldFont
        label.textColor = R.color.text_title()
        label.textAlignment = .center
        return label
    }()
    
    lazy var versionLabel: UILabel = {
        let view = UILabel()
        view.font = k20Font
        view.textColor = R.color.text_content()
        view.textAlignment = .center
        return view
    }()
    
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.font = k16BoldFont
        view.textAlignment = .left
        view.textColor = R.color.text_title()
        view.backgroundColor = R.color.whitecolor()
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(R.color.themecolor(), for: .normal)
        btn.backgroundColor = R.color.whitecolor()
        btn.setTitle("取消", for: .normal)
        btn.jk.addBorder(borderWidth: 1, borderColor: R.color.themecolor()!)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(R.color.whitecolor(), for: .normal)
        btn.backgroundColor = R.color.themecolor()
        btn.setTitle("更新", for: .normal)
        btn.layer.cornerRadius = 5
        return btn
    }()
}

