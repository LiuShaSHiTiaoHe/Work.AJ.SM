//
//  OpenDoorPasswordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit
import SVProgressHUD

class OpenDoorPasswordViewController: BaseViewController {

    private var spacingWidth: CGFloat = 15.0
    private var boxSizeWidth: CGFloat = 0.0
    private var firstPassword: String = ""

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.text_title()
        view.backgroundColor = R.color.whitecolor()
        view.titleLabel.text = "设置开门密码"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "请输入开门密码"
        view.textAlignment = .center
        view.font = k14Font
        view.textColor = R.color.text_title()
        return view
    }()
    
    private lazy var codeTextField: CodeTextField = {
        let temTextField = CodeTextField(codeLength: 6,
                                         characterSpacing: spacingWidth,
                                         validCharacterSet: CharacterSet(charactersIn: "0123456789"),
                                         characterLabelGenerator: { (_) -> LableRenderable in
                                            let label = StyleLabel(size: CGSize(width: boxSizeWidth, height: boxSizeWidth))
                                            label.style = Style.border(nomal: UIColor.gray, selected: R.color.themecolor()!)
                                            return label})
        temTextField.keyboardType = .numberPad
        temTextField.translatesAutoresizingMaskIntoConstraints = false
        temTextField.codeDelegate = self
        return temTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showKeyboardView()
    }
    
    override func initUI() {
        adjustBoxWidth()
        view.backgroundColor = R.color.whitecolor()
        view.addSubview(headerView)
        view.addSubview(tipsLabel)
        view.addSubview(codeTextField)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(headerView.snp.bottom).offset(kMargin*2)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(120)
            make.left.equalToSuperview().offset(spacingWidth)
            make.right.equalToSuperview().offset(-spacingWidth)
            make.height.equalTo(boxSizeWidth)
        }
    }
    
    func adjustBoxWidth() {
        let box = (kScreenWidth - spacingWidth*7)/6
        if box > 50 {
            boxSizeWidth = 50
            spacingWidth = (kScreenWidth - boxSizeWidth * 6)/7
        }else{
            if box < 30 {
                boxSizeWidth = (kScreenWidth - 5*7)/6
                spacingWidth = 5
            }else{
                boxSizeWidth = box
            }
        }
    }
    
    func showKeyboardView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.codeTextField.becomeFirstResponder()
        }
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    func resetKit() {
        codeTextField.text = ""
        codeTextField.updateLabels()
    }
    
    func setOwnerPassword(_ password: String) {
        MineRepository.shared.setOwnerPassword(password) { errorMsg in
            if !errorMsg.isEmpty {
                SVProgressHUD.showError(withStatus: errorMsg)
            }else{
                NotificationCenter.default.post(name: .kUserUpdateOpenDoorPassword, object: nil)
                ud.personalOpenDoorPasswordStatus = true
                SVProgressHUD.showSuccess(withStatus: "设置成功")
                SVProgressHUD.dismiss(withDelay: 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}

extension OpenDoorPasswordViewController :CodeTextFieldDelegate {
    func codeTextField(_ sender: CodeTextField, valueChanged: String) {
        if valueChanged.count == sender.codeLength {
            if firstPassword.isEmpty {
                firstPassword = valueChanged
                resetKit()
                SVProgressHUD.showInfo(withStatus: "请再次输入")
            }else{
                if firstPassword == valueChanged {
                    codeTextField.resignFirstResponder()
                    setOwnerPassword(firstPassword)
                }else{
                    SVProgressHUD.showError(withStatus: "两次输入不一致，请重新设置")
                    firstPassword = ""
                    resetKit()
                }
            }
        }
    }
}
