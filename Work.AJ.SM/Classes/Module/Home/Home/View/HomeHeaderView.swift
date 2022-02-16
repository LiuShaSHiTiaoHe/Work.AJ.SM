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
        cycleView.placeholderImage = R.image.home_banner()
        cycleView.scrollDirection = .horizontal
        cycleView.backgroundColor = R.color.backgroundColor()
        cycleView.bannerImageViewContentMode = .scaleToFill
        cycleView.delegate = self
        cycleView.layer.cornerRadius = 10
        cycleView.clipsToBounds = true
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
        let imageView = UIImageView.init(image: R.image.icon_notice())
        return imageView
    }()
    
    private lazy var textCycleBackground: UIView = {
        let view = UIView.init()
        view.backgroundColor = R.color.contentColor()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(ads: [AdsModel], notice: [NoticeModel]) {
        var urlStrings = [String]()
        var noticeStrings = [String]()

        if !ads.isEmpty {
            ads.forEach { model in
                if let url = model.adurl, !url.isEmpty, url.jk.verifyUrl() {
                    urlStrings.append(url)
                }
            }
        }
        if !notice.isEmpty {
            notice.forEach { model in
                if let notice = model.noticetitle {
                    noticeStrings.append(notice)
                }
            }
        }
        
        self.imageCycleScrollView.imageURLStringsGroup = urlStrings
        self.textCycleScrollView.titlesGroup = noticeStrings.isEmpty ? ["暂无公告"] : noticeStrings
    }
    
    private func initUI() {
        self.addSubview(imageCycleScrollView)
        self.addSubview(textCycleBackground)
        textCycleBackground.addSubview(iconImage)
        textCycleBackground.addSubview(textCycleScrollView)

        textCycleBackground.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview()//.offset(kMargin)
            make.height.equalTo(kMargin*2)
        }
        
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        textCycleScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMargin*2)
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        imageCycleScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(textCycleBackground.snp.bottom).offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        textCycleBackground.jk.addShadow(shadowColor: R.color.blackColor()!, shadowOffset: CGSize.init(width: 0, height: 0), shadowOpacity: 0.2, shadowRadius: 10)
    }
        
}

extension HomeHeaderView: SDCycleScrollViewDelegate {}
