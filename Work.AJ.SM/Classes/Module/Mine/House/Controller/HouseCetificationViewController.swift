//
//  HouseCetificationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/10.
//

import UIKit
import SVProgressHUD

class HouseCertificationViewController: BaseViewController {

    var selectedCommunity: CommunityModel?
    var selectedBlock: BlockModel?
    var selectedCell: CellModel?
    var selectedUnit: UserUnitModel?

    private var userType: String = ""//身份类别 F家属 O业主 R租客

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        if let communityName = selectedCommunity?.name, let blockName = selectedBlock?.blockName, let cellName = selectedCell?.cellName, let unitName = selectedUnit?.unitNO {
            contentView.locationName.text = communityName + blockName + cellName + unitName
        }

        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    @objc
    func confirm() {
        let name = getMemberName()
        if name.isEmpty {
            SVProgressHUD.showInfo(withStatus: "姓名不能为空")
            return
        }
        let phone = getMemberPhoneNumber()
        if phone.isEmpty {
            SVProgressHUD.showInfo(withStatus: "手机号码不能为空")
            return
        } else {
            if !phone.jk.isValidMobile {
                SVProgressHUD.showInfo(withStatus: "手机号码格式错误")
                return
            }
        }
        let identityNumber = getMemberIdentityCardNumber()
        if identityNumber.isEmpty {
            SVProgressHUD.showInfo(withStatus: "身份证号码不能为空")
            return
        } else {
            if !identityNumber.jk.isValidIDCardNumStrict {
                SVProgressHUD.showInfo(withStatus: "身份证号码格式错误")
                return
            }
        }

        if userType.isEmpty {
            SVProgressHUD.showInfo(withStatus: "身份类别不能为空")
            return
        }

        if let userID = ud.userID, let communityID = selectedCommunity?.rid?.jk.intToString, let blockID = selectedBlock?.rid?.jk.intToString, let unitID = selectedUnit?.rid?.jk.intToString {
            let model = HouseCertificationModel.init(name: name, phone: phone, userIdentityCardNumber: identityNumber, userType: userType, communityID: communityID, blockID: blockID, unitID: unitID, userID: userID)
            SVProgressHUD.show(withStatus: "正在提交")
            MineAPI.houseAuthentication(data: model).defaultRequest { jsonData in
                SVProgressHUD.showSuccess(withStatus: "提交验证信息成功，请等待审核")
                SVProgressHUD.dismiss(withDelay: 2) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } failureCallback: { response in
                SVProgressHUD.showError(withStatus: response.message)
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "参数错误")
        }
    }

    func getMemberName() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CommonInputCell
        if let name = cell.commonInput.text {
            return name
        } else {
            return ""
        }
    }

    func getMemberPhoneNumber() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! CommonPhoneNumberCell
        if let PhoneNumber = cell.phoneInput.text {
            return PhoneNumber
        } else {
            return ""
        }
    }

    func getMemberIdentityCardNumber() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! CommonIDNumberInpuCell
        if let identityCardNumber = cell.IDNumberInput.text {
            return identityCardNumber
        } else {
            return ""
        }
    }

    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var contentView: HouseCetificationView = {
        let view = HouseCetificationView()
        return view
    }()
}

extension HouseCertificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            cell.accessoryType = .none
            cell.nameLabel.text = "姓名"
            if let name = ud.userRealName {
                cell.commonInput.text = name
                cell.commonInput.isEnabled = false
            } else {
                cell.placeholder = "请输入家人/成员姓名"
                cell.commonInput.isEnabled = true
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonPhoneNumberCellIdentifier, for: indexPath) as! CommonPhoneNumberCell
            cell.accessoryType = .none
            cell.nameLabel.text = "手机"
            if let mobile = ud.userMobile {
                cell.phoneInput.text = mobile
                cell.phoneInput.isEnabled = false
            } else {
                cell.placeholder = "请输入家人/成员手机号"
                cell.phoneInput.isEnabled = true
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonIDNumberInpuCellIdentifier, for: indexPath) as! CommonIDNumberInpuCell
            cell.accessoryType = .none
            cell.nameLabel.text = "身份证"
            cell.placeholder = "请输入家人/成员身份证号"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonSelectButtonCellIdentifier, for: indexPath) as! CommonSelectButtonCell
            cell.accessoryType = .none
            cell.nameLabel.text = "身份"
            cell.leftButtonName = "业主"
            cell.centerButtonName = "家人"
            cell.rightButtonName = "成员"
            cell.delegate = self
            cell.defaultValue = 0
            return cell
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

extension HouseCertificationViewController: CommonSelectButtonCellDelegate {

    func leftButtonSelected(_ isSelected: Bool) {
        userType = "O"
    }

    func centerButtonSelected(_ isSelected: Bool) {
        userType = "F"
    }

    func rightButtonSelected(_ isSelected: Bool) {
        userType = "R"
    }
}
