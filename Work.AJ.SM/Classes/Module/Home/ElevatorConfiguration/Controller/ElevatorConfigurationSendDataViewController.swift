//
//  ElevatorConfigurationSendDataViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/8.
//

import UIKit
import SVProgressHUD
import JKSwiftExtension

class ElevatorConfigurationSendDataViewController: BaseViewController {

    var elevator: ConfigurationLifts?
    var configurationData: ConfigurationCommunity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: ElevatorConfigurationSendDataView = {
        let view = ElevatorConfigurationSendDataView()
        return view
    }()

}

extension ElevatorConfigurationSendDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ElevatorConfigurationDefines.shared.functions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "configurationSendDataCellIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = ElevatorConfigurationDefines.shared.functions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let functionName = ElevatorConfigurationDefines.shared.functions[indexPath.row]
        switch functionName {
        case "写密码":
            if let password = configurationData?.blockSecret, !password.isEmpty {
                let data = "510BB6*5A"
                writeData(data, password)
            }else{
                SVProgressHUD.showInfo(withStatus: "未获取到密码数据")
            }
    
        case "写卡片扇区":
            if let cardSector = configurationData?.useBlocks, !cardSector.isEmpty {
                let data = "5106B8*5A"
                let sector = cardSector.count%2 == 0 ? cardSector : "0" + cardSector
                writeData(data, sector)
            }else{
                SVProgressHUD.showInfo(withStatus: "未获取到扇区数据")
            }
    
        case "写群组号":
            if let groupNum = elevator?.cellGroupID?.jk.intToString, !groupNum.isEmpty {
                let data = "5106B4*5A"
                let gnum = groupNum.count%2 == 0 ? groupNum : "0" + groupNum
                writeData(data, gnum)
            }else{
                SVProgressHUD.showInfo(withStatus: "未获取到群组数据")
            }
    
        case "写入SN码":
            if let snNumber = elevator?.liftSN, !snNumber.isEmpty {
                if snNumber.count < 15 {
                    SVProgressHUD.showInfo(withStatus: "获取到错误的SN数据")
                }else{
                    let data = "510FD1*5A"
                    let snLength = snNumber.count
                    let sn = snNumber.jk.sub(start: snLength - 10, length: 10)
                    writeData(data, sn.bytes.toHexString())
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "未获取到SN数据")
            }
            break
        case "写楼层配置":
            break
        default:
            break
        }
    }

    private func writeData(_ data: String, _ para: String){
        updateTips(para)
        BLEAdvertisingManager.shared.sendElevatorConfigData(data, para)
    }
    
    private func updateTips(_ tips: String){
        contentView.tipsLabel.text = tips
    }
}
