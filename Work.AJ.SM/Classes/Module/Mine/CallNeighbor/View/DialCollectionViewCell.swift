//
//  DailCollectionViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit

let DialCollectionViewCellCellIdentifier = "DialCollectionViewCellCellIdentifier"

class DialCollectionViewCell: UICollectionViewCell {

    let nameLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = k28Font
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
        contentView.addSubview(nameLabel)
        backgroundColor = R.color.whiteColor()

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin)
            make.bottom.equalToSuperview().offset(-kMargin)

        }
//        self.layer.cornerRadius = 10
//        self.jk.addShadow(shadowColor: R.color.themebackgroundColor()!, shadowOffset: CGSize.init(width: 0, height: 0), shadowOpacity: 0.3, shadowRadius: 4)
    }
}
