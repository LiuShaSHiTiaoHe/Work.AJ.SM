//
//  LoginViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/11.
//

import UIKit
import SVProgressHUD

class LoginViewController: BaseViewController {
    
    lazy var loginView: LoginView = {
        let view = LoginView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        initData()
    }
    override func initUI() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func initData() {
        loginView.delegate = self
    }

}


extension LoginViewController: LoginViewDelegate {
    
    func login(mobile: String, password: String) {
        SVProgressHUD.show()
        AuthenticationAPI.login(mobile: mobile, passWord: password).defaultRequest { JsonData  in
            SVProgressHUD.dismiss()
            if let data = JsonData["data"].rawString(), let userInfo = JsonData["map"].rawString(), let units = [UnitModel](JSONString: data), let userModel = UserModel(JSONString: userInfo) {
                Defaults.username = mobile
                ud.userMobile = mobile
                Defaults.userRealName = userModel.realName
                Defaults.userID = userModel.rid
                GDataManager.shared.setupDataBase()
                RealmTools.addList(units) {}
                RealmTools.add(userModel) {}
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.resetRootViewController()
                }

            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: "\(response.message)")
        }

    }
    
    func forgetPassword(mobile: String?) {
        let vc = ResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func register(mobile: String, code: String, password: String) {
        
    }
    
    func sendCode(mobile: String) {
        
    }

    func showPrivacy() {
        
    }
    
    func showTermsOfServices() {
        
    }
    
    
}
