//
//  SettingViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/1.
//

import UIKit
import JKSwiftExtension
import SVProgressHUD
import Siren

class SettingViewController: BaseViewController {

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.maintextColor()
        view.backgroundColor = R.color.whiteColor()
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
            view.backgroundColor = R.color.backgroundColor()
            return view
        }else{
            let view = UITableView.init(frame: CGRect.zero, style: .grouped)
            view.register(SettingNoticeTableViewCell.self, forCellReuseIdentifier: SettingNoticeTableViewCellIdentifier)
            view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCellIdentifier)
            view.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.backgroundColor()
            return view
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
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
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "通用设置"
        headerView.titleLabel.textColor = R.color.maintextColor()
        
        tableView.delegate = self
        tableView.dataSource = self
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
//        let result = FileManager.jk.removefile(filePath: FileManager.jk.CachesDirectory())
//        if result.isSuccess {
//            SVProgressHUD.showSuccess(withStatus: "清理成功")
//            tableView.reloadRow(at: IndexPath.init(row: 0, section: 1), with: .none)
//        }else{
//            SVProgressHUD.showError(withStatus: result.error)
//        }
    }
    
    func checkUpdate() {
        MineAPI.versionCheck(type: "ios").defaultRequest { jsonData in
            if let updateStr = jsonData["data"]["IFFORCE"].string, let effectiveStr = jsonData["data"]["EFFECTIVESTATUS"].string {
                if effectiveStr == "T" {
                    if updateStr == "T" {
                        GDataManager.shared.checkAppStoreVersion(true, .immediately)
                    }else if updateStr == "F" {
                        GDataManager.shared.checkAppStoreVersion(false, .immediately)
                    }
                }
            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: response.message)
        }
    }
    
    func supportCall() {
        JKGlobalTools.callPhone(phoneNumber: kServiceSupportNumber) { flag in
            
        }
    }
    
    func aboutApp() {
        let vc = BaseWebViewController()
        vc.urlString = kAboutUsPageURLString
        self.navigationController?.pushViewController(vc, animated: true)
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
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingNoticeTableViewCellIdentifier, for: indexPath) as! SettingNoticeTableViewCell
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
                cell.switchView.isOn = ud.allowVisitorCall
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
