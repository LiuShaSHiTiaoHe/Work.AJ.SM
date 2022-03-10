//
//  SetVisitorPasswordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit
import PGDatePicker
import YYCategories
import SVProgressHUD

enum VisitTimes {
    case single
    case multy
    case initial
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

        // Do any additional setup after loading the view.
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
        let location = HomeRepository.shared.getCurrentUnitName()
        contentView.tipsLabel.text = location
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        defaultTime()
    }
    
    func selectTime() {
        let datePickerManager = PGDatePickManager.init()
        datePickerManager.isShadeBackground = true
        datePickerManager.style = .sheet
        datePickerManager.cancelButtonTextColor = R.color.errorRedColor()
        datePickerManager.confirmButtonTextColor = R.color.themeColor()
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
        datePicker?.textColorOfSelectedRow = R.color.themeColor()
        datePicker?.textFontOfSelectedRow = k18Font
        datePicker?.lineBackgroundColor = R.color.themeColor()
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = NSDate.init().addingMonths(13)
        datePicker?.selectedDate = {[weak self] dateComponents in
            guard let `self` = self else { return }
            switch self.timeType {
            case .arrive:
                self.arriveTime = dateComponents?.date
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 0, section: 0), with: .none)
            case .valid:
                self.validTime = dateComponents?.date
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 1, section: 0), with: .none)
            }
        }
        self.present(datePickerManager, animated: true) {
            
        }
    }
    
    func defaultTime() {
        arriveTime = Date()
        validTime = NSDate().addingMinutes(30)
        contentView.tableView.reloadData()
    }
    
    @objc
    func confirm() {
        if let validTime = validTime, let arriveTime = arriveTime {
            let phoneNumber = getVisitorPhoneNumber()
            if phoneNumber.isEmpty {
                SVProgressHUD.showError(withStatus: "请输入访客的手机号码")
                return
            }else{
                if !phoneNumber.jk.isValidMobile {
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
                        let vc = PasswordInvitationViewController()
                        vc.arriveTime = arriveTime
                        vc.validTime = validTime
                        vc.visitTimes = visitTimes
                        vc.phoneNumber = phoneNumber
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                SVProgressHUD.showError(withStatus: "有效期早于来访时间")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请选择来访时间")
        }
    }

    func getVisitorPhoneNumber() -> String {
        let cell = contentView.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CommonPhoneNumberCell
        if let number = cell.phoneInput.text {
            return number
        }else{
            return ""
        }
    }
}

extension SetVisitorPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonPhoneNumberCellIdentifier, for: indexPath) as! CommonPhoneNumberCell
            cell.placeholder = "请输入访客手机号"
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
            self.selectTime()
        case 2:
            timeType = .valid
            self.selectTime()
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
    
    func multy(isSelected: Bool) {
        if isSelected {
            visitTimes = .multy
        }else{
            visitTimes = .initial
        }
    }
}
