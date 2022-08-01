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
    
    override func initData() {
        cancelButton.addTarget(self , action: #selector(cancleAction), for: .touchUpInside)
        confirmButton.addTarget(self , action: #selector(confirmAction), for: .touchUpInside)
    }
    
    @objc
    func cancleAction() {
        let checkedVersions = ud.checkedAppVersions
        var temp = Array<String>.init(checkedVersions)
        temp.append(version)
        ud.checkedAppVersions = temp
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
    
    func configData(_ descString: String, _ force: Bool, _ latestVersion: String) {
        if force {
            cancelButton.isHidden = true
            confirmButton.snp.remakeConstraints { make  in
                make.left.equalToSuperview().offset(kMargin)
                make.right.equalToSuperview().offset(-kMargin)
                make.bottom.equalToSuperview().offset(-kMargin)
                make.height.equalTo(50)
            }
        }
        titleLabel.text = "发现新的版本"
        contentTextView.text = descString
        version = latestVersion
    }
            
    override func initializeView(){
        self.addSubview(titleLabel)
        self.addSubview(contentTextView)
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
                
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(kMargin)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
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
    
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.font = k16BoldFont
        view.textAlignment = .left
        view.textColor = R.color.text_content()
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

