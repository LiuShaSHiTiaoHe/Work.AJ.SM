//
//  BaseView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit
import IQKeyboardManagerSwift

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(){}
    
    func initData() {}

    func hideKeyboard() {
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    func addlayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [R.color.themebackgroundColor()!.cgColor,UIColor.white.cgColor]
        gradientLayer.locations = [0.0,0.4,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint  = CGPoint.init(x: 0, y: 1.0)
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
