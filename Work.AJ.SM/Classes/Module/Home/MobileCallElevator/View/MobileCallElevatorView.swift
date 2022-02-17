//
//  MobileCallElevatorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit

class MobileCallElevatorView: UIView {

    let cellidentifier = "MCECollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        
    }
    
    func initializeView() {
       
        
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.rightButton.isHidden = true
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "乘梯选层"
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        return view
    }()
    
    lazy var elevatorTitle: UILabel = {
        let view = UILabel()
        view.textColor = R.color.blackColor()
        view.font = k15Font
        view.textAlignment = .center
        return view
    }()
    
    lazy var elevatorLocation: UILabel = {
        let view = UILabel()
        view.textColor = R.color.blackColor()
        view.font = k15Font
        view.textAlignment = .center
        return view
    }()
    
    lazy var downArrow: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.themeColor()
        view.font = k15Font
        view.textAlignment = .center
        view.text = "请移步至电梯厅，再选择目的楼层"
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin/2, left: kMargin/2, bottom: kMargin/2, right: kMargin/2)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceVertical = true
        c.backgroundColor = UIColor.clear
        c.register(MCECollectionViewCell.self, forCellWithReuseIdentifier: cellidentifier)
        return c
    }()
    
}
