//
//  BaseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import UIKit
import MJRefresh

class BaseViewController: UIViewController {

    open private(set) lazy var refreshHeader: MJRefreshStateHeader = {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        header.stateLabel!.textColor = R.color.whiteColor()
        header.lastUpdatedTimeLabel?.isHidden = true
//        header.stateLabel?.isHidden = true
//        header.setTitle(kConstAPPNameString, for: .idle)
//        header.setTitle(kConstAPPNameString, for: .pulling)
//        header.setTitle(kConstAPPNameString, for: .refreshing)
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = R.color.backgroundColor()
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        initUI()
//        addlayer()
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    func addlayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [R.color.themebackgroundColor()!.cgColor,UIColor.white.cgColor]
        gradientLayer.locations = [0.0,0.4,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint  = CGPoint.init(x: 0, y: 1.0)
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func initUI() {}
    
    @objc func headerRefresh() {}

}
