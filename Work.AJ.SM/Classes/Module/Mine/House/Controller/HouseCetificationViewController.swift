//
//  HouseCetificationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/10.
//

import UIKit

enum HouseCertificationRole {
case owner
    case family
    case guset
}

class HouseCertificationViewController: BaseViewController {
    
    var selectedCommunity: CommunityModel?
    var selectedBlock: BlockModel?
    var selectedCell: CellModel?
    var selectedUnit: UserUnitModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        if let communityName = selectedCommunity?.name, let blockName = selectedBlock?.blockName, let cellName = selectedCell?.cellName, let unitName = selectedUnit?.rid?.jk.intToString {
            contentView.locationName.text = communityName + blockName + cellName + unitName
        }
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    @objc
    func confirm() {
        
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
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
            cell.placeholder = "请输入家人/成员姓名"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonPhoneNumberCellIdentifier, for: indexPath) as! CommonPhoneNumberCell
            cell.accessoryType = .none
            cell.nameLabel.text = "手机"
            cell.placeholder = "请输入家人/成员手机号"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComminIDNumberInpuCellIdentifier, for: indexPath) as! ComminIDNumberInpuCell
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
    func letfButtonSelected(_ isSelected: Bool) {
        
    }
    
    func centerButtonSelected(_ isSelected: Bool) {
        
    }
    
    func rightButtonSelected(_ isSelected: Bool) {
        
    }
}
