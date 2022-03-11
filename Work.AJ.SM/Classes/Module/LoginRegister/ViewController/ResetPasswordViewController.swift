//
//  ResetPasswordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/14.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    lazy var resetPasswordView: ResetPasswordView = {
        let view = ResetPasswordView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        resetPasswordView.delegate = self
    }
    
    func initUI() {
        view.addSubview(resetPasswordView)
        
        resetPasswordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func checkMsgCode(_ mobile: String, _ code: String, _ password: String) {
        AuthenticationRepository.shared.checkMessageCode(mobile: mobile, code: code) {[weak self] errorMsg in
            guard let `self` = self else { return }
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }else{
                self.resetPassword(mobile, password)
            }
        }
    }
    
    
    func resetPassword(_ mobile: String, _ password: String) {
        AuthenticationRepository.shared.resetPassword(mobile: mobile, password: password) {[weak self] errorMsg in
            guard let `self` = self else { return }
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }else{
                SVProgressHUD.showSuccess(withStatus: "重置密码成功")
                DispatchQueue.main.asyncAfter(deadline: .now()+2 ){
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension ResetPasswordViewController: ResetPasswordViewDelegate {
    func resetPasswordComfirm(mobile: String, code: String, newPassword: String) {
        checkMsgCode(mobile, code, newPassword)
    }
    
    func resetPasswordClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendCode(mobile: String) {
        SVProgressHUD.show()
        AuthenticationRepository.shared.sendMessageCode(mobile) { errorMsg in
            if let errorMsg = errorMsg {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }else{
                SVProgressHUD.showSuccess(withStatus: "验证码已发送")
            }
        }
    }
}
