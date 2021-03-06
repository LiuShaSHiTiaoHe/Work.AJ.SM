//
//  MCECollectionViewCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/17.
//

import UIKit

class MCECollectionViewCell: UICollectionViewCell {
    
    lazy var elevatorName: UILabel = {
        let view = UILabel()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1/kScale
        view.layer.borderColor = R.color.text_info()!.cgColor
        view.textColor = R.color.text_info()
        view.textAlignment = .center
        view.font = k28Font
        view.backgroundColor = .clear
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
        backgroundColor = R.color.bg()
        contentView.addSubview(elevatorName)
        
        elevatorName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.right.equalToSuperview().offset(-8)
        }
        
        layer.cornerRadius = 10.0
    }

}
