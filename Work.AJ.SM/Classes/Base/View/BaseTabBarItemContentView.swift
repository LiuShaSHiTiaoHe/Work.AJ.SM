//
//  BaseTabBarItemContentView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import ESTabBarController_swift

class BaseTabBarItemContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = R.color.tabbarColor()!
        highlightTextColor = R.color.themeColor()!
        iconColor = R.color.tabbarColor()!
        highlightIconColor = R.color.themeColor()!
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BouncesTabBarContentView: BaseTabBarItemContentView {

    public var duration = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}

