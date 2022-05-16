//
//  customPageView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/25/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SnapKit

open class SwiftyOnboardPage: UIView {
    
    public var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    public var subTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    public var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func set(style: SwiftyOnboardStyle) {
        title.textColor = R.color.onboardtitleColor()
        subTitle.textColor = R.color.onboardtitleColor()
    }
    
    func setUp() {
        addSubview(imageView)
        addSubview(title)
        addSubview(subTitle)

        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.top.equalToSuperview().offset(100)
        }
        
        subTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(60)
            make.top.equalTo(title.snp.bottom).offset(kMargin)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(267)
            make.top.equalTo(subTitle.snp.bottom).offset(60)
        }
    }
}
