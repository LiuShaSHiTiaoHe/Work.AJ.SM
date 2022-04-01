//
//  OnBoardViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit
import SPPermissions

class OnBoardViewController: UIViewController {
    
    var swiftyOnboard: SwiftyOnboard!
    var titleArray: [String] = ["出入随心", "乘梯自由", "访客通行", "可视对讲"]
    var subTitleArray: [String] = ["支持蓝牙感应、人脸识别，开门更智能", "室内呼梯、选层，缩短等待时间，\n无接触防传染", "访客可通过二维码、密码通行，安全便捷", "随时与门禁设备视频通话，远程轻松开门"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .dark)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PermissionManager.shared.requestAllPermission()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    @objc func handleSkip() {
        endOnboard()
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == 3 {
            endOnboard()
        }else{
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
    }
    
    func endOnboard() {
        ud.onboardStatus = true
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.presentLogin()
    }
}

extension OnBoardViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 4
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return R.color.whiteColor()
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "image_onboard_\(index)")
        
        //Set the font and color for the labels:
        view.title.font = k34SysFont
        view.subTitle.font = k16Font
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        overlay.skipButton.setTitle("跳过", for: .normal)
        overlay.continueButton.setTitle("立即体验", for: .normal)
        overlay.continueButton.isHidden = true
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 || currentPage == 2.0{
            overlay.continueButton.isHidden = true
            overlay.skipButton.isHidden = false
            overlay.pageControl.isHidden = false
        } else {
            overlay.continueButton.isHidden = false
            overlay.pageControl.isHidden = true
            overlay.skipButton.isHidden = true
        }
    }
}


