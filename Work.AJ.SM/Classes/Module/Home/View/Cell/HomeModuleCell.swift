//
//  HomeModuleCell.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2022/1/4.
//

import UIKit

class HomeModuleCell: UICollectionViewCell {
    
    let iconImage: UIImageView = {
        let icon = UIImageView.init()
        return icon
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
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
        contentView.addSubviews([iconImage, nameLabel])
        self.backgroundColor = R.color.whiteColor()
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImage.snp.right).offset(kMargin/2)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin)
            
        }
        self.layer.cornerRadius = 10
        self.addShadow(ofColor: .gray, radius: 4, offset: CGSize.init(width: 0, height: 0), opacity: 0.3)
    }
    
    func initData(_ model: HomePageFunctionModule) {
        iconImage.image = UIImage(named: model.icon)
        nameLabel.text = model.name
    }
    
}
