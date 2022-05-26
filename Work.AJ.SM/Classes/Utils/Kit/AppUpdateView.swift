//
//  AppUpdateView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/26.
//

import UIKit
import SwiftEntryKit

class AppUpdateView: BaseView {

    private var dataSource: AppStoreVersionModel.Results?
    
    override func initData() {
        cancelButton.addTarget(self , action: #selector(CancleAction), for: .touchUpInside)
        confirmButton.addTarget(self , action: #selector(confirmAction), for: .touchUpInside)
    }
    
    @objc
    func CancleAction() {
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
    
    func configData(_ model: AppStoreVersionModel.Results, _ force: Bool) {
        if force {
            cancelButton.isHidden = true
            confirmButton.snp.remakeConstraints { make  in
                make.left.equalToSuperview().offset(kMargin)
                make.right.equalToSuperview().offset(-kMargin)
                make.bottom.equalToSuperview().offset(-kMargin)
                make.height.equalTo(50)
            }
        }
        dataSource = model
        contentLabel.text = model.releaseNotes
    }
            
    override func initializeView(){
        self.addSubview(logoImageView)
        self.addSubview(contentLabel)
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
        
        logoImageView.snp.makeConstraints { make  in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make  in
            make.top.equalToSuperview().offset(200)
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

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView.init(image: R.image.base_image_updatebg())
        return imageView
    }()
    
    lazy var contentBg: UIView = {
        let view = UIView.init()
        view.backgroundColor = R.color.bg()
        return view
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel.init()
        label.font = k16Font
        label.textColor = R.color.text_content()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(R.color.themeColor(), for: .normal)
        btn.backgroundColor = R.color.whiteColor()
        btn.setTitle("取消", for: .normal)
        btn.jk.addBorder(borderWidth: 1, borderColor: R.color.themeColor()!)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(R.color.whiteColor(), for: .normal)
        btn.backgroundColor = R.color.themeColor()
        btn.setTitle("更新", for: .normal)
        btn.layer.cornerRadius = 5
        return btn
    }()
}

