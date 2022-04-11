//
//  BaseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import UIKit
import MJRefresh

class BaseViewController: UIViewController {

    private let noDataViewTag: Int = 404
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initUI()
        initData()
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    // MARK: - Functions
    
    // MARK: - GradientLayer
    func addlayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [R.color.themebackgroundColor()!.cgColor,UIColor.white.cgColor]
        gradientLayer.locations = [0.0,0.4,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint  = CGPoint.init(x: 0, y: 1.0)
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func refreshHeader(_ textColor: UIColor? = R.color.whiteColor()!) -> MJRefreshStateHeader {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        if let textColor = textColor {
            header.stateLabel!.textColor = textColor
        }else {
            header.stateLabel!.textColor = R.color.whiteColor()!
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        return header
    }
    
    // MARK: - Backbutton Action
    @objc
    func closeAction() {
        if self.isBeingPresented {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func initUI() {}
    func initData() {}
    
    // MARK: - HearderRefresh
    @objc func headerRefresh() {}
    
    // MARK: - PushAction
    func pushTo(viewController vc: UIViewController, isHideBottomBar: Bool = true, isAnimated: Bool = true) {
        vc.hidesBottomBarWhenPushed = isHideBottomBar
        self.navigationController?.pushViewController(vc, animated: isAnimated)
    }

}

extension BaseViewController {
    // MARK: - EmptyView
    func showNoDataView(_ type: EmptyDataType = .nodata, _ constraintView: UIView? = nil)  {
        let noDataView = NoDataView()
        noDataView.viewType = type
        noDataView.tag = noDataViewTag
        view.addSubview(noDataView)
        view.bringSubviewToFront(noDataView)
        if let view = constraintView {
            noDataView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(view.snp.bottom)
            }
        }else{
            noDataView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func hideNoDataView() {
        if let noDataView = view.subviews.first(where: { v in
            v.tag == noDataViewTag
        }) {
            noDataView.removeFromSuperview()
        }
    }
}
