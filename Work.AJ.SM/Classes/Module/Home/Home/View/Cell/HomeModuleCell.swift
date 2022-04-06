//
//  HomeModuleCell.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2022/1/4.
//

import UIKit

let HomeModuleCellIdentifier = "HomeModuleCellIdentifier"

class HomeModuleCell: UICollectionViewCell {
    
    let iconImage: UIImageView = {
        let icon = UIImageView.init()
        return icon
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = k16Font
        label.textColor = R.color.blackColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        self.backgroundColor = R.color.whiteColor()
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImage.snp.right).offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview()
            
        }
        self.layer.cornerRadius = 10
        self.jk.addShadow(shadowColor: R.color.themebackgroundColor()!, shadowOffset: CGSize.init(width: 0, height: 0), shadowOpacity: 0.3, shadowRadius: 4)
    }
    
    func initData(_ model: HomePageFunctionModule) {
        iconImage.image = UIImage(named: model.icon)
        nameLabel.text = model.name
    }
    
}
