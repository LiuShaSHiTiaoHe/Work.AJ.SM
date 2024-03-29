//
//  SetVisitorQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/21.
//

import UIKit
import PGDatePicker
import YYCategories
import SVProgressHUD

enum SelectTimeType {
    case arrive
    case valid
}

class SetVisitorQRCodeViewController: BaseViewController {

    private var arriveTime: Date?
    private var validTime: Date?
    private var timeType: SelectTimeType = .arrive
    
    lazy var contentView: SetVisitorQRCodeView = {
        let view = SetVisitorQRCodeView()
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
        datePicker?.maximumDate = NSDate.init().addingHours(18)//addingMonths(13)
        datePicker?.selectedDate = {[weak self] dateComponents in
            guard let `self` = self else { return }
            switch self.timeType {
            case .arrive:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.arriveTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 0, section: 0), with: .none)
            case .valid:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.validTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 1, section: 0), with: .none)
            }
        }
        present(datePickerManager, animated: false) {
            
        }
    }
    
    func defaultTime() {
        arriveTime = Date()
        validTime = NSDate().addingMinutes(30)
        contentView.tableView.reloadData()
    }
    
    @objc
    func confirm() {
        SVProgressHUD.show()
        if let validTime = validTime, let arriveTime = arriveTime {
            if let interval = validTime.jk.numberOfMinutes(from: arriveTime), interval >= 30 {
                if interval > kInviteGuestValidTimeInterval {
                    SVProgressHUD.showError(withStatus: "有效期超过限制")
                }else{
                    if let unit = HomeRepository.shared.getCurrentUnit(), let unitID = unit.unitid?.jk.intToString, let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let userID = ud.userID {
                        let arriveTimeString = arriveTime.jk.toformatterTimeString()
                        let validTimeString = validTime.jk.toformatterTimeString()
                        HomeAPI.getInvitationQRCode(unitID: unitID, arriveTime: arriveTimeString, validTime: validTimeString, communityID: communityID, blockID: blockID, userID: userID).defaultRequest { JsonData in
                            SVProgressHUD.dismiss()
                            if let data = JsonData["data"].dictionary, let qrcode = data["qrcode"]?.string {
                                DispatchQueue.main.async {
                                    let vc = QRCodeInvitationViewController()
                                    vc.arriveTime = arriveTime
                                    vc.validTime = validTime
                                    vc.qrCodeString = qrcode
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } failureCallback: { response in
                            logger.info("\(response.message)")
                            SVProgressHUD.showError(withStatus: "\(response.message)")
                        }
                    }else{
                        SVProgressHUD.showError(withStatus: "数据错误")
                    }
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: "有效期早于来访时间")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请选择来访时间")
        }
    }
}

extension SetVisitorQRCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeSelectCellIdentifier, for: indexPath) as! TimeSelectCell
        cell.accessoryType = .none
        switch indexPath.row {
        case 0:
            if let arriveTimeString = arriveTime?.jk.toformatterTimeString(formatter: "yyyy-MM-dd HH:mm") {
                cell.timeLabel.text = arriveTimeString
            }
            cell.nameLabel.text = "来访时间"
        case 1:
            if let validTimeString = validTime?.jk.toformatterTimeString(formatter: "yyyy-MM-dd HH:mm") {
                cell.timeLabel.text = validTimeString
            }
            cell.nameLabel.text = "有效期至"
        default:
            fatalError()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            timeType = .arrive
        case 1:
            timeType = .valid
        default:
            fatalError()
        }
        selectTime()
    }

}
