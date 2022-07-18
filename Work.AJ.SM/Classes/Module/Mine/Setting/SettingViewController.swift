//
//  SettingViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/1.
//

import UIKit
import JKSwiftExtension
import SVProgressHUD

class SettingViewController: BaseViewController {

    // MARK: - 是否显示允许访客呼叫到手机的模块
    private var showAllowVisitorCallSwitch: Bool = true
    // MARK: - 允许访客呼叫的状态记录
    private var isAllowVisitorCall: Bool {
        set {
            ud.allowVisitorCall = newValue
        }
        get {
            return ud.allowVisitorCall
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "通用设置"
        headerView.titleLabel.textColor = R.color.text_title()
        // MARK: - 允许访客呼叫到手机 这个选项是否显示
        if let unit = HomeRepository.shared.getCurrentUnit() {
            showAllowVisitorCallSwitch = HomeRepository.shared.isVisitorCallUserMobileEnable(unit)
            if showAllowVisitorCallSwitch {
                readAllowVisitorCallStatus()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func readAllowVisitorCallStatus() {
        MineRepository.shared.getUserDoNotDisturbStatus { [weak self] status in
            guard let self = self else { return }
            let operateStatus = status ? "F" : "T"
            self.isAllowVisitorCall = status
            self.tableView.reloadData()
        }
    }
    
    func updateAllowVisitorCallStatus(_ status: Bool) {
        let operateStatus = status ? "F" : "T"
        MineRepository.shared.updateUserDoNotDisturbStatus(operateStatus) { [weak self] errorMsg in
            guard let self = self else { return }
            if errorMsg.isEmpty {
                self.isAllowVisitorCall = status
                SVProgressHUD.showSuccess(withStatus: "操作成功")
            }else{
                SVProgressHUD.showError(withStatus: errorMsg)
            }
            self.tableView.reloadData()
        }
    }
    
    func cleanCache() {
        CacheManager.normal.removeAllCache()
        CacheManager.liftrecord.removeAllCache()
        CacheManager.network.removeAllCache()
        SVProgressHUD.show(withStatus: "正在清理...")
        SVProgressHUD.dismiss(withDelay: 1) {
            DispatchQueue.main.async {
                SVProgressHUD.showSuccess(withStatus: "清理成功")
                self.tableView.reloadRow(at: IndexPath.init(row: 0, section: 1), with: .none)
            }
        }
    }
    
    func checkUpdate() {
        GDataManager.shared.checkAppUpdate()
    }
    
    func supportCall() {
        JKGlobalTools.callPhone(phoneNumber: kServiceSupportNumber) { flag in
            
        }
    }
    
    func aboutApp() {
        let vc = BaseWebViewController()
        vc.urlString = kAboutUsPageURLString
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func logOut() {
        let alert = UIAlertController.init(title: "退出登录", message: "", preferredStyle: .alert)
        alert.addAction("取消", .cancel) { }
        alert.addAction("确定", .destructive) {
            SVProgressHUD.show(withStatus: "正在登出...")
            GDataManager.shared.clearAccount()
            SVProgressHUD.dismiss(withDelay: 2) {
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        alert.show()
    }
    
    func deleteAccount() {
        let alert = UIAlertController.init(title: "注销", message: "注销之后，无法再使用此账号登录，需要重新注册账号，请谨慎操作。", preferredStyle: .alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel) { action in }
        let confirmAction = UIAlertAction.init(title: "注销", style: .destructive) { action in
            if let userID = ud.userID {
                SVProgressHUD.show(withStatus: "正在注销...")
                MineAPI.deleteAccount(userID: userID).defaultRequest { jsonData in
                    SVProgressHUD.showInfo(withStatus: "注销成功")
                    GDataManager.shared.clearAccount()
                    SVProgressHUD.dismiss(withDelay: 2) {
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.present(vc, animated: true, completion: nil)
                    }
                } failureCallback: { response in
                    SVProgressHUD.showError(withStatus: response.message)
                }
            }
        }
        alert.addAction(action: cancleAction)
        alert.addAction(action: confirmAction)
        alert.show()
    }
    
    // MARK: - UI
    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.text_title()
        view.backgroundColor = R.color.whitecolor()
        view.titleLabel.text = "通用设置"
        return view
    }()
    
    lazy var tableView: UITableView = {
        if #available(iOS 13.0, *) {
            let view = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
            view.register(SettingNoticeTableViewCell.self, forCellReuseIdentifier: SettingNoticeTableViewCellIdentifier)
            view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCellIdentifier)
            view.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.bg()
            return view
        }else{
            let view = UITableView.init(frame: CGRect.zero, style: .grouped)
            view.register(SettingNoticeTableViewCell.self, forCellReuseIdentifier: SettingNoticeTableViewCellIdentifier)
            view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCellIdentifier)
            view.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.bg()
            return view
        }
    }()
}

extension SettingViewController: SettingNoticeTableViewCellDelegate {
    func settingSwitchChanged(_ row: Int, _ status: Bool) {
        switch row {
        case 3:
            updateAllowVisitorCallStatus(status)
            break
        default:
            break
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if showAllowVisitorCallSwitch {
                return 4
            }else{
                return 3
            }
        } else if section == 1 {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNoticeTableViewCellIdentifier, for: indexPath) as! SettingNoticeTableViewCell
            cell.selectionStyle = .none
            cell.row = indexPath.row
            cell.delegate = self
            switch indexPath.row {
            case 0:
                cell.iconImageView.image = R.image.setting_icon_notification()
                cell.nameLabel.text = "通知栏显示"
                cell.switchView.isOn = ud.inAppNotification
            case 1:
                cell.iconImageView.image = R.image.setting_icon_vibration()
                cell.nameLabel.text = "振动"
                cell.switchView.isOn = ud.vibrationAvailable
            case 2:
                cell.iconImageView.image = R.image.setting_icon_ringtone()
                cell.nameLabel.text = "响铃"
                cell.switchView.isOn = ud.ringtoneAvailable
            case 3:
                cell.iconImageView.image = R.image.setting_icon_phone()
                cell.nameLabel.text = "允许访客呼叫您手机"
                cell.switchView.isOn = isAllowVisitorCall
            default:
                break
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellIdentifier, for: indexPath) as! SettingTableViewCell
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "清除缓存"
                let size = CacheManager.normal.totalCost + CacheManager.network.totalCost + CacheManager.liftrecord.totalCost
                cell.tipsLabel.text = FileManager.jk.covertUInt64ToString(with: UInt64(size))
                break
            case 1:
                cell.nameLabel.text = "检查新版本"
                cell.tipsLabel.text = Bundle.jk.appVersion
                break
            case 2:
                cell.nameLabel.text = "客服热线"
                cell.tipsLabel.text = kServiceSupportNumber
                break
            case 3:
                cell.nameLabel.text = "关于"
                cell.tipsLabel.text = ""
                break
            case 4:
                cell.nameLabel.text = "退出登录"
                cell.tipsLabel.text = ""
                break
            case 5:
                cell.nameLabel.text = "注销账号"
                cell.tipsLabel.text = "注销后无法恢复"
                break
            default:
                break
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "消息提醒设置"
        }else if section == 1 {
            return "更多设置"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            break
        case 1:
            switch indexPath.row{
            case 0:
                cleanCache()
            case 1:
                checkUpdate()
            case 2:
                supportCall()
            case 3:
                aboutApp()
            case 4:
                logOut()
            case 5:
                deleteAccount()
            default:
                break
            }
        default:
            break
        }
    }
}
