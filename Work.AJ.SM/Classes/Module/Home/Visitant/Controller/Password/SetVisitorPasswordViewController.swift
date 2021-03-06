//
//  SetVisitorPasswordViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/22.
//

import UIKit
import PGDatePicker
import YYCategories
import SVProgressHUD

enum VisitTimes: String {//T为多次有效，F为1次有效
    case single = "F"
    case multi = "T"
    case initial = ""
}

class SetVisitorPasswordViewController: BaseViewController {

    private var arriveTime: Date?
    private var validTime: Date?
    private var timeType: SelectTimeType = .arrive
    private var visitTimes: VisitTimes = .initial
    
    lazy var contentView: SetVisitorPasswordView = {
        let view = SetVisitorPasswordView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        let location = HomeRepository.shared.getCurrentHouseName()
        contentView.tipsLabel.text = location
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        defaultTime()
    }
    
    func selectTime() {
        let datePickerManager = PGDatePickManager.init()
        datePickerManager.isShadeBackground = true
        datePickerManager.style = .sheet
        datePickerManager.cancelButtonTextColor = R.color.sub_red()
        datePickerManager.confirmButtonTextColor = R.color.themecolor()
        let datePicker = datePickerManager.datePicker
        datePicker?.datePickerType = .line
        datePicker?.datePickerMode = .dateHourMinute
        datePicker?.language = "zh-Hans"
        switch timeType {
        case .arrive:
            datePickerManager.title = "来访时间"
        case .valid:
            datePickerManager.title = "有效期至"
        }
        datePicker?.textColorOfSelectedRow = R.color.themecolor()
        datePicker?.textFontOfSelectedRow = k18Font
        datePicker?.lineBackgroundColor = R.color.themecolor()
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = NSDate.init().addingMonths(13)
        datePicker?.selectedDate = {[weak self] dateComponents in
            guard let `self` = self else { return }
            switch self.timeType {
            case .arrive:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.arriveTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 1, section: 0), with: .none)
            case .valid:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.validTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 2, section: 0), with: .none)
            }
        }
        present(datePickerManager, animated: true) {}
    }
    
    func defaultTime() {
        arriveTime = Date()
        validTime = NSDate().addingMinutes(30)
        contentView.tableView.reloadData()
    }
    
    func getVisitorPhoneNumber() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CommonPhoneNumberCell
        if let number = cell.phoneInput.text {
            return number
        }else{
            return ""
        }
    }
    
    func go2InvitationView(_ validTime: Date, _ arriveTime: Date, _ phoneNumber: String, _ password: String) {
        let vc = PasswordInvitationViewController()
        vc.arriveTime = arriveTime
        vc.validTime = validTime
        vc.visitTimes = visitTimes
        vc.phoneNumber = phoneNumber
        vc.password = password
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func generatePassword(_ validTime: Date, _ arriveTime: Date, _ phoneNumber: String) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let userID = unit.userid?.jk.intToString{
            let sDate = arriveTime.jk.toformatterTimeString()
            let eDate = validTime.jk.toformatterTimeString()
            HomeAPI.generateVisitorPassword(communityID: communityID, blockID: blockID, unitID: unitID, userID: userID, phone: phoneNumber, sDate: sDate, eDate: eDate, type: visitTimes.rawValue).defaultRequest { jsonData in
                if let data = jsonData["data"].dictionary, let password = data["PASSWORD"]?.string {
                    SVProgressHUD.showSuccess(withStatus: "提交成功")
                    SVProgressHUD.dismiss(withDelay: 2) {
                        self.go2InvitationView(validTime, arriveTime, phoneNumber, password)
                    }
                }
            } failureCallback: { response in
                SVProgressHUD.showSuccess(withStatus: "\(response.message)")
            }
        }
    }
    @objc
    func confirm() {
        if let validTime = validTime, let arriveTime = arriveTime {
            let phoneNumber = getVisitorPhoneNumber()
            if phoneNumber.isEmpty {
                SVProgressHUD.showError(withStatus: "请输入访客的手机号码")
                return
            }else{
                if !phoneNumber.aj_isMobileNumber {
                    SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
                    return
                }
            }
            if let interval = validTime.jk.numberOfMinutes(from: arriveTime), interval >= 30 {
                if interval > 12*60*60 {
                    SVProgressHUD.showError(withStatus: "有效期超出限值")
                }else{
                    if visitTimes == .initial {
                        SVProgressHUD.showError(withStatus: "选择使用次数")
                    }else{
                        generatePassword(validTime, arriveTime, phoneNumber)
                    }
                }
            }else{
                SVProgressHUD.showError(withStatus: "有效期最少为30分钟")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请选择来访时间")
        }
    }

    
}

extension SetVisitorPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonPhoneNumberCellIdentifier, for: indexPath) as! CommonPhoneNumberCell
            cell.placeholder = "请输入访客手机号"
            cell.nameLabel.text = "手机号"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeSelectCellIdentifier, for: indexPath) as! TimeSelectCell
            cell.accessoryType = .none
            if let arriveTimeString = arriveTime?.jk.toformatterTimeString(formatter: "yyyy-MM-dd HH:mm") {
                cell.timeLabel.text = arriveTimeString
            }
            cell.nameLabel.text = "来访时间"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeSelectCellIdentifier, for: indexPath) as! TimeSelectCell
            cell.accessoryType = .none
            if let validTimeString = validTime?.jk.toformatterTimeString(formatter: "yyyy-MM-dd HH:mm") {
                cell.timeLabel.text = validTimeString
            }
            cell.nameLabel.text = "有效期至"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfUseCellIdentifier, for: indexPath) as! NumberOfUseCell
            cell.accessoryType = .none
            cell.delegate = self
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            break
        case 1:
            timeType = .arrive
            selectTime()
        case 2:
            timeType = .valid
            selectTime()
        case 3:
            break
        default:
            fatalError()
        }
    }

}

extension SetVisitorPasswordViewController: NumberOfUseCellDelegate {
    func single(isSelected: Bool) {
        if isSelected {
            visitTimes = .single
        }else{
            visitTimes = .initial
        }
    }
    
    func multi(isSelected: Bool) {
        if isSelected {
            visitTimes = .multi
        }else{
            visitTimes = .initial
        }
    }
}
