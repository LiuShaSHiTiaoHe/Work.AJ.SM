//
//  UserProfileInputViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/31.
//

import UIKit
import SVProgressHUD

protocol UserProfileInputViewControllerDelegate: NSObjectProtocol {
    func userProfileInput(_ value: String, _ type: UserProfileInputType)
}

class UserProfileInputViewController: BaseViewController {

    var type: UserProfileInputType = .nickName
    var value: String?
    weak var delegate: UserProfileInputViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textfield.becomeFirstResponder()
    }
    
    override func initData() {
        switch type {
        case .nickName:
            headerView.titleLabel.text = "昵称"
        case .realName:
            headerView.titleLabel.text = "真实姓名"
        }
        textfield.text = value
    }
    
    @objc
    func confirmAction() {
        if let inputString = textfield.text {
            delegate?.userProfileInput(inputString, type)
            self.navigationController?.popViewController(animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入内容")
        }
    }
    
    // MARK: - UI
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(inputBgView)
        inputBgView.addSubview(textfield)
        view.addSubview(confirmButton)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        inputBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(40)
            make.top.equalTo(headerView.snp.bottom).offset(kMargin*2)
        }
        
        textfield.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.themeColor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        view.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return view
    }()
    
    lazy var inputBgView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.corner(5)
        return view
    }()
    
    lazy var textfield: UITextField = {
        let view = UITextField.init()
        view.backgroundColor = R.color.whiteColor()
        view.textColor = R.color.maintextColor()
        view.font = k16Font
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("确认", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()

}
