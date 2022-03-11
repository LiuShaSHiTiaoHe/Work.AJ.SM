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

}

extension ResetPasswordViewController: ResetPasswordViewDelegate {
    func resetPasswordComfirm(mobile: String, code: String, newPassword: String) {
        
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
