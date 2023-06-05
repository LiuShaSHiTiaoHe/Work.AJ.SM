//
//  AddGuestQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import PGDatePicker
import SVProgressHUD
import UIKit
import YYCategories

class AddGuestQRCodeViewController: BaseViewController {
    private var arriveTime: Date?
    private var validTime: Date?
    private var timeType: SelectTimeType = .arrive

    lazy var contentView: AddGuestQRCodeView = {
        let view = AddGuestQRCodeView()
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
        contentView.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        defaultTime()
    }

    func selectTime() {
        let datePickerManager = PGDatePickManager()
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
        datePicker?.maximumDate = NSDate().addingHours(12) // addingMonths(13)
        datePicker?.selectedDate = { [weak self] dateComponents in
            guard let `self` = self else { return }
            switch self.timeType {
            case .arrive:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.arriveTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath(row: 0, section: 0), with: .none)
            case .valid:
                if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                    self.validTime = selectDate
                }
                self.contentView.tableView.reloadRow(at: IndexPath(row: 1, section: 0), with: .none)
            }
        }
        present(datePickerManager, animated: false) {}
    }

    func defaultTime() {
        arriveTime = Date()
        validTime = NSDate().addingMinutes(30)
        contentView.tableView.reloadData()
    }

    @objc
    func confirm() {
        let cell = contentView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! CommonInputCell
        var floors = [String]()
        if let floor = cell.commonInput.text {
            floors.append(floor)
        }
        if let validTime = validTime, let arriveTime = arriveTime {
            if let interval = validTime.jk.numberOfMinutes(from: arriveTime), interval >= 30 {
                if interval > 12 * 60 {
                    SVProgressHUD.showError(withStatus: "有效期超过限制")
                } else {
                    DispatchQueue.main.async {
                        let vc = GuestQRCodeViewController()
                        vc.arriveTime = arriveTime
                        vc.validTime = validTime
                        if !floors.isEmpty {
                            vc.floor = floors.first
                        }
                        vc.qrCodeImage = QRCodeManager.shared.generateGuestQRCode(arriveTime.timeIntervalSince1970.jk.int,
                                                                                  validTime.timeIntervalSince1970.jk.int, floors)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                SVProgressHUD.showError(withStatus: "有效期早于来访时间")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请选择来访时间")
        }
    }
}

extension AddGuestQRCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            cell.accessoryType = .none
            cell.nameLabel.text = "到访楼层(选填)"
            cell.commonInput.placeholder = "请填写到访楼层"
            return cell
        default:
            fatalError()
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            timeType = .arrive
            selectTime()
        case 1:
            timeType = .valid
            selectTime()
        case 2: break
        default:
            fatalError()
        }
    }
}
