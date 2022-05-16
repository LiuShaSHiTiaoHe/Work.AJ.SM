//
//  customOverlayView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/26/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

open class SwiftyOnboardOverlay: UIView {
    
    open var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = R.color.onboardtitleColor()
        return pageControl
    }()
    
    open var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = k16Font
        button.backgroundColor = R.color.themeColor()
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    open var skipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = k16Font
        button.setTitleColor(R.color.onboardtitleColor(), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = R.color.onboardtitleColor()!.cgColor
        button.layer.borderWidth = 1/kScale
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    open func set(style: SwiftyOnboardStyle) {
        skipButton.setTitleColor(R.color.onboardtitleColor(), for: .normal)
        pageControl.currentPageIndicatorTintColor = R.color.themeColor()
    }
    
    open func page(count: Int) {
        pageControl.numberOfPages = count
    }
    
    open func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
    func setUp() {
        addSubview(pageControl)
        addSubview(continueButton)
        addSubview(skipButton)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-kMargin*2)
            make.height.equalTo(30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-kMargin*2)
        }
        
        skipButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.top.equalToSuperview().offset(60)
        }
    }
    
}
