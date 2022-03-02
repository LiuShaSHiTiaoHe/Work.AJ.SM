//
//  OpenDoorPasswordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit

class OpenDoorPasswordViewController: BaseViewController {

    var spacingWidth: CGFloat = 15.0
    private var boxSizeWidth: CGFloat = 0.0

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.maintextColor()
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.text = "设置开门密码"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "请输入开门密码"
        view.textAlignment = .center
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    private lazy var codeTextField: CodeTextField = {
        let temTextField = CodeTextField(codeLength: 6,
                                         characterSpacing: spacingWidth,
                                         validCharacterSet: CharacterSet(charactersIn: "0123456789"),
                                         characterLabelGenerator: { (_) -> LableRenderable in
                                            let label = StyleLabel(size: CGSize(width: boxSizeWidth, height: boxSizeWidth))
                                            label.style = Style.border(nomal: UIColor.gray, selected: R.color.themeColor()!)
                                            return label})
        temTextField.keyboardType = .numberPad
        temTextField.translatesAutoresizingMaskIntoConstraints = false
        temTextField.codeDelegate = self
        return temTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
    }
    
    func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }

}

extension OpenDoorPasswordViewController :CodeTextFieldDelegate {
    func codeTextField(_ sender: CodeTextField, valueChanged: String) {
        
    }
}
