//
//  ElevatorConfigurationSendDataViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/8.
//

import UIKit

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
            break
        case "写卡片扇区":
            break
        case "写群组号":
            break
        case "写入SN码":
            break
        case "写楼层配置":
            break
        default:
            break
        }
    }

}
