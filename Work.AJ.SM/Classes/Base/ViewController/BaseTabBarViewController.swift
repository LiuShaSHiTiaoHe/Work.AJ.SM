//
//  BaseTabBarViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import ESTabBarController_swift
import Haptica

class BaseTabBarViewController: ESTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initUI() {
        let v1 = BaseNavigationController.init(rootViewController: HomeViewController())
        let v2 = BaseNavigationController.init(rootViewController: HomeViewController())
        v1.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "Home", image: UIImage.init(named: "tab_icon_home_gray"), selectedImage: UIImage.init(named: "tab_icon_home_blue"))
        v2.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "Setting", image: UIImage.init(named: "tab_icon_setting_gray"), selectedImage: UIImage.init(named: "tab_icon_setting_blue"))
        self.viewControllers = [v1, v2]
    }

    private func setupTabBar(){
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = R.color.backgroundColor()//tab_background_color
        if #available(iOS 15, *) {
            let bar = UITabBarAppearance.init()
            bar.backgroundColor = R.color.backgroundColor()//tab_background_color
            self.tabBar.scrollEdgeAppearance = bar
            self.tabBar.standardAppearance = bar
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.impact(.medium).generate()
    }
}
