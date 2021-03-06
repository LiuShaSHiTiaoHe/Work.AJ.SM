//
//  HomeModuleCell.swift
//  SmartCommunity
//
//  Created by Anjie on 2022/1/4.
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
        label.textColor = R.color.text_title()
        label.adjustsFontSizeToFitWidth = true
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
        backgroundColor = R.color.whitecolor()
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImage.snp.right).offset(kMargin/2)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin / 2)

        }
        layer.cornerRadius = 10
        jk.addShadow(shadowColor: R.color.bg_theme()!, shadowOffset: CGSize.init(width: 0, height: 0), shadowOpacity: 0.3, shadowRadius: 4)
    }

    func initData(_ model: HomePageFunctionModule) {
        iconImage.image = UIImage(named: model.icon)
        nameLabel.text = model.name
    }

}
