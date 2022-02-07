//
//  HomeHeaderView.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2022/1/4.
//

import UIKit
import SDCycleScrollView

class HomeHeaderView: UICollectionReusableView {

    private lazy var imageCycleScrollView: SDCycleScrollView = {
        let cycleView = SDCycleScrollView.init()
        cycleView.placeholderImage = UIImage(named: "home_banner")
        cycleView.scrollDirection = .horizontal
        cycleView.backgroundColor = R.color.backgroundColor()
        cycleView.bannerImageViewContentMode = .scaleToFill
        cycleView.delegate = self
        return cycleView
    }()
    
    private lazy var textCycleScrollView: SDCycleScrollView = {
        let cycleView = SDCycleScrollView.init()
        cycleView.onlyDisplayText = true
        cycleView.scrollDirection = .vertical
        cycleView.disableScrollGesture()
        cycleView.backgroundColor = R.color.contentColor()
        cycleView.titleLabelTextColor = R.color.secondtextColor()
        cycleView.titleLabelBackgroundColor = R.color.contentColor()
        cycleView.titleLabelTextFont = k12BoldFont
        cycleView.autoScrollTimeInterval = 4
        cycleView.delegate = self
        return cycleView
    }()
    
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "icon_notice"))
        return imageView
    }()
    
    private lazy var textCycleBackground: UIView = {
        let view = UIView.init()
        view.backgroundColor = R.color.contentColor()
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.addSubview(imageCycleScrollView)
        self.addSubview(textCycleBackground)
        textCycleBackground.addSubview(iconImage)
        textCycleBackground.addSubview(textCycleScrollView)

        imageCycleScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kMargin*1.5)
        }

        textCycleBackground.snp.makeConstraints { make in
            make.left.equalTo(imageCycleScrollView.snp.left).offset(kMargin/2)
            make.right.equalTo(imageCycleScrollView.snp.right).offset(-kMargin/2)
            make.bottom.equalToSuperview()
            make.height.equalTo(kMargin*1.2)
        }
        
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        textCycleScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMargin*2)
            make.right.equalToSuperview().offset(-kMargin/4)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        textCycleBackground.addShadow(ofColor: .gray, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 0.2)
    }
        
}

extension HomeHeaderView: SDCycleScrollViewDelegate {}
