//
//  LoginViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/11.
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
    }

    override func initUI() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        #if DEBUG
        loginView.iconImageView.isUserInteractionEnabled = true
        let tapPress = UITapGestureRecognizer(target: self, action: #selector(showDebugView))
        tapPress.numberOfTapsRequired = 2
        loginView.iconImageView.addGestureRecognizer(tapPress)
        #endif
    }

    override func initData() {
        loginView.delegate = self
    }
    
    @objc
    private func showDebugView() {
        let aView = DebugView.init()
        var attributes = EntryKitCustomAttributes.bottomFloat.attributes
        attributes.screenInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.entryBackground = .color(color: .white)
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .constant(value: 420)
        )
        SwiftEntryKit.display(entry: aView, using: attributes)
    }

}


extension LoginViewController: LoginViewDelegate {

    func login(mobile: String, password: String) {
        SVProgressHUD.show()
        AuthenticationRepository.shared.login(mobile: mobile, password: password) { errorMsg in
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            } else {
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.resetRootViewController()
                }
            }
        }
    }

    func forgetPassword(mobile: String?) {
        let vc = ResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

    func register(mobile: String, code: String, password: String) {
        SVProgressHUD.show()
        AuthenticationRepository.shared.register(mobile: mobile, passWord: password, code: code) { errorMsg in
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            } else {
                SVProgressHUD.showSuccess(withStatus: "注册成功")
                AuthenticationRepository.shared.autoLogin(mobile: mobile, password: password) { errorMsg in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.resetRootViewController()
                    }
                }
            }
        }
    }

    func sendCode(mobile: String) {
        SVProgressHUD.show()
        AuthenticationRepository.shared.sendMessageCode(mobile) { errorMsg in
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            } else {
                SVProgressHUD.showSuccess(withStatus: "验证码已发送")
            }
        }
    }

    func showPrivacy() {
        let vc = BaseWebViewController.init()
        vc.urlString = kPrivacyPageURLString
        navigationController?.pushViewController(vc, animated: true)
    }

    func showTermsOfServices() {
        let vc = BaseWebViewController.init()
        vc.urlString = kUserAgreementURLString
        navigationController?.pushViewController(vc, animated: true)
    }


}
