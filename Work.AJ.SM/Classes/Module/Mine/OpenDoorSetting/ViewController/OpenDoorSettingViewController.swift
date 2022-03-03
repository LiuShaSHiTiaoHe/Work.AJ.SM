//
//  OpenDoorSettingViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit

class OpenDoorSettingViewController: BaseViewController {

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.maintextColor()
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.text = "开门设置"
        return view
    }()
    
    lazy var tableView: UITableView = {
        if #available(iOS 13.0, *) {
            let view = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
            view.register(BleOpenDoorStyleCell.self, forCellReuseIdentifier: BleOpenDoorStyleCellIdentifier)
            view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCellIdentifier)
            view.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
            view.separatorStyle = .singleLine
            view.backgroundColor = R.color.backgroundColor()
            return view
        }else{
            let view = UITableView.init(frame: CGRect.zero, style: .grouped)
            view.register(BleOpenDoorStyleCell.self, forCellReuseIdentifier: BleOpenDoorStyleCellIdentifier)
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
        initData()
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
    
    func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension OpenDoorSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellIdentifier, for: indexPath) as! SettingTableViewCell
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "个人开门密码"
                if !ud.personalOpenDoorPasswordStatus {
                    cell.tipsLabel.text = "密码还未设置"
                }
            default:
                break
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BleOpenDoorStyleCellIdentifier, for: indexPath) as! BleOpenDoorStyleCell
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "自动感应开门"
                cell.tipsLabel.text = "开启后，经过设备时将自动开门/呼梯"
                break
            case 1:
                cell.nameLabel.text = "手机摇一摇开门"
                cell.tipsLabel.text = "开启后，摇一摇手机即可开门/呼梯"
                break
            case 2:
                cell.nameLabel.text = "按键开门"
                cell.tipsLabel.text = "开启后，在首页点击“蓝牙呼梯”可开门/呼梯"
                break
            default:
                break
            }
            if ud.openDoorStyle == indexPath.row {
                cell.switchView.isOn = true
            }else{
                cell.switchView.isOn = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60.0
        }
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "蓝牙开门模式"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                let vc = OpenDoorPasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                break
            case 1:
                break
            case 2:
                break
            default:
                break
            }
        default:
            break
        }
    }
}
