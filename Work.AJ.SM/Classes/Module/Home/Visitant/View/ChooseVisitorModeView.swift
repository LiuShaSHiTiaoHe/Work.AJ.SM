//
//  ChooseVisitorModeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit
import SwiftEntryKit

protocol ChooseVisitorModeDelegate: NSObjectProtocol {
    func qrcode()
    func password()
}

class ChooseVisitorModeView: UIView {

    weak var delegate: ChooseVisitorModeDelegate?
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_close_black(), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.textColor = R.color.blackColor()
        view.font = k16Font
        view.text = "请选择合适的访客方式"
        view.textAlignment = .center
        return view
    }()
    
    lazy var qrcodeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.visitor_image_qrcode(), for: .normal)
        button.addTarget(self, action: #selector(chooseQrcode), for: .touchUpInside)
        return button
    }()
    
    lazy var qrcodeTitle: UILabel = {
        let view = UILabel.init()
        view.text = "访客二维码"
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .center
        return view
    }()
    
    lazy var passwordButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.visitor_image_password(), for: .normal)
        button.addTarget(self, action: #selector(choosePassword), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordTitle: UILabel = {
        let view = UILabel.init()
        view.text = "访客密码"
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    @objc
    func closeAction() {
        SwiftEntryKit.dismiss()
    }
    
    @objc
    func chooseQrcode() {
        delegate?.qrcode()
    }
    
    @objc
    func choosePassword() {
        delegate?.password()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {

        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        self.addSubview(qrcodeButton)
        self.addSubview(qrcodeTitle)
        self.addSubview(passwordButton)
        self.addSubview(passwordTitle)
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(closeButton.snp.bottom)
            make.height.equalTo(20)
        }
        
        qrcodeButton.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.centerX.equalTo(self.snp.centerX).dividedBy(2)
            make.centerY.equalToSuperview()
        }
        
        qrcodeTitle.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.top.equalTo(qrcodeButton.snp.bottom).offset(kMargin/2)
            make.height.equalTo(30)
        }
        
        passwordButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX).multipliedBy(1.5)
            make.width.height.equalTo(65)
            make.top.equalTo(qrcodeButton)
        }
        
        passwordTitle.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX)
            make.right.equalToSuperview()
            make.top.equalTo(passwordButton.snp.bottom).offset(kMargin/2)
            make.height.equalTo(30)
        }
    }

}
