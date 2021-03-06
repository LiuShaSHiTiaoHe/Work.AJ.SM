//
//  SelectHouseLocationIndexCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/11.
//

import UIKit

let SelectHouseLocationIndexCellIdetifier = "SelectHouseLocationIndexCellIdetifier"

class SelectHouseLocationIndexCell: UICollectionViewCell {
    lazy var locationNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_title()
        view.textAlignment = .center
        view.backgroundColor = .clear
        view.font = k14Font
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        backgroundColor = R.color.whitecolor()
        contentView.addSubview(locationNameLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.right.equalToSuperview()
        }
    }
}
