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
        label.font = k12Font
        label.textColor = R.color.secondtextColor()
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
        self.backgroundColor = .white
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-kMargin/2)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-kMargin)
        }
        self.layer.cornerRadius = 15
        self.addShadow(ofColor: .gray, radius: 4, offset: CGSize.init(width: 0, height: 0), opacity: 0.1)
    }
    
    func initData(_ model: HomePageFunctionModule) {
        iconImage.image = UIImage(named: model.icon)
        nameLabel.text = model.name
    }
    
}
