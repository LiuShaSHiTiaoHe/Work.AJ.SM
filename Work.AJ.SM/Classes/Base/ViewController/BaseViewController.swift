//
//  BaseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.backgroundColor()
        self.navigationController?.hidesBottomBarWhenPushed = true
        
        initUI()
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    func initUI() {}
    

}
