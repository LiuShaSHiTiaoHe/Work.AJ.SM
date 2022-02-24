//
//  AddMemberViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import SVProgressHUD

enum FamilyMemberType {
    case initial
    case family
    case member
}

class AddMemberViewController: BaseViewController {

    private var memberType: FamilyMemberType = .initial
    
    lazy var contentView: AddMemberView = {
        let view = AddMemberView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    func initData() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        let location = HomeRepository.shared.getCurrentUnitName()
        contentView.tipsLabel.text = location
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func confirm() {
        
   
        
        let memberName = getMemberName()
        let memberPhone = getPhoneNumber()
        if memberName.isEmpty {
            SVProgressHUD.showError(withStatus: "请输入成员的姓名")
            return
        }
        
        if memberPhone.isEmpty {
            SVProgressHUD.showError(withStatus: "请输入成员的手机号码")
            return
        }
        if memberPhone.jk.isValidMobile {
            SVProgressHUD.showError(withStatus: "手机号码格式不正确")
            return
        }
        
        let vc = MemberInvitationViewController()
        vc.phone = memberPhone
        vc.qrCodeString = "anjiezhihuishequ"
        self.navigationController?.pushViewController(vc, animated: true)
        return
        
        
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let userID = unit.userid?.jk.intToString {
            MineAPI.addFamilyMember(communityID: communityID, unitID: unitID, userID: userID, name: memberName, phone: memberPhone).defaultRequest { jsonData in
                
            } failureCallback: { response in
                SVProgressHUD.showError(withStatus: "\(response.message)")
            }

        }
    }
    
    func getMemberName() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CommonInputCell
        if let name = cell.commonInput.text {
            return name
        }else{
            return ""
        }
    }
    
    func getPhoneNumber() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! InvitationPhoneNumberCell
        if let number = cell.phoneInput.text {
            return number
        }else{
            return ""
        }
    }
}

extension AddMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            cell.accessoryType = .none
            cell.nameLabel.text = "姓名"
            cell.placeholder = "请输入家人/成员姓名"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InvitationPhoneNumberCellIdentifier, for: indexPath) as! InvitationPhoneNumberCell
            cell.accessoryType = .none
            cell.nameLabel.text = "手机号"
            cell.placeholder = "请输入家人/成员手机号"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonSelectButtonCellIdentifier, for: indexPath) as! CommonSelectButtonCell
            cell.accessoryType = .none
            cell.nameLabel.text = "身份"
            cell.firstButtonName = "家人"
            cell.secondButtonName = "成员"
            cell.delegate = self
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

extension AddMemberViewController: CommonSelectButtonCellDelegate {
    func first(isSelected: Bool) {
        if isSelected {
            memberType = .family
        }else{
            memberType = .initial
        }
    }
    
    func second(isSelected: Bool) {
        if isSelected {
            memberType = .member
        }else{
            memberType = .initial
        }
    }
    
    
}
