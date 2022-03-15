//
//  OwnerQRCodeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

protocol OwnerQRCodeViewDelegate: NSObjectProtocol {
    func close()
    func refresh()
}

class OwnerQRCodeView: UIView {

    weak var delegate: OwnerQRCodeViewDelegate?
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_back_white(), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var backImage: UIImageView = {
        let view = UIImageView.init()
        view.isUserInteractionEnabled = true
        view.image = R.image.oqc_back_image()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.init()
        view.text = "一码通行"
        view.font = k24Font
        view.textColor = R.color.whiteColor()
        return view
    }()
    
    lazy var keyImage: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.oqc_key_image()
        return view
    }()
    
    lazy var contentBack: UIView = {
        let view = UIView.init()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel.init()
        view.textAlignment = .center
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel.init()
        view.textAlignment = .center
        view.textColor = R.color.maintextColor()
        view.text = "请在开门/乘梯时展示此二维码"
        return view
    }()
    
    lazy var qrcodeView: UIImageView = {
        let view = UIImageView.init()
        return view
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.oqc_refresh_image(), for: .normal)
        button.setImage(R.image.oqc_refresh_image(), for: .highlighted)
        button.setTitle("刷新", for: .normal)
        button.setTitleColor(R.color.themeColor(), for: .normal)
        button.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
    
    @objc
    func closeAction() {
        delegate?.close()
    }
    
    @objc
    func refreshAction() {
        delegate?.refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        
        self.addSubview(backImage)
        backImage.addSubview(closeButton)
        backImage.addSubview(titleLabel)
        backImage.addSubview(keyImage)
        
        self.addSubview(contentBack)
        contentBack.addSubview(nameLabel)
        contentBack.addSubview(tipsLabel)
        contentBack.addSubview(qrcodeView)
        contentBack.addSubview(refreshButton)
        
        backImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(224*kHeightScale)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(54)
            make.top.equalToSuperview().offset(90)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        keyImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-60)
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(126)
            make.height.equalTo(90)
        }
        
        contentBack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-kMargin*2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(30)
        }
        
        qrcodeView.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(277*kWidthScale)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.equalTo(qrcodeView.snp.bottom).offset(kMargin*2)
            make.centerX.equalToSuperview()
        }
        
    }

    func initData() {
        if let mobile = Defaults.username {
            let index = mobile.count - 4
            let str = mobile.jk.sub(from: index)
            nameLabel.text = "(尾号\(str)) 业主您好"
        }
    }
}
