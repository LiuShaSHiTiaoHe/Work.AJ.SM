//
//  LoginViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/11.
//

import UIKit

class LoginViewController: BaseViewController {
    
    lazy var loginView: LoginView = {
        let view = LoginView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    override func initUI() {
        addlayer()
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

}
