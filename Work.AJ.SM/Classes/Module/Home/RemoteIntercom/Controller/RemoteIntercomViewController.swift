//
//  RemoteIntercomViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit
import SVProgressHUD

class RemoteIntercomViewController: BaseViewController {

    private var dataSource: [UnitLockModel] = []
    
    lazy var contentView: RemoteIntercomView = {
        let view = RemoteIntercomView()
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
        contentView.tableView.register(RemoteOpenDoorCell.self, forCellReuseIdentifier: RemoteOpenDoorCellIdentifier)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        HomeRepository.shared.getAllLocks { [weak self] models in
            guard let `self` = self else { return }
            self.dataSource = models
            self.contentView.tableView.reloadData()
        }
    }
    
}

extension RemoteIntercomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteOpenDoorCellIdentifier, for: indexPath) as! RemoteOpenDoorCell
        let unitLock = dataSource[indexPath.row]
        cell.setUpData(model: unitLock)
        cell.openDoorButton.isHidden = true
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
}

extension RemoteIntercomViewController: RemoteOpenDoorCellDelegate{
    func openDoor(_ lockModel: UnitLockModel) {
        if let lockMac = lockModel.lockmac {
            HomeRepository.shared.openDoorViaPush(lockMac) { errorMsg in
                if errorMsg.isEmpty {
                    SVProgressHUD.showSuccess(withStatus: "开门成功")
                }else{
                    SVProgressHUD.showInfo(withStatus: errorMsg)
                }
            }
        }
    }
    
    func camera(_ lockModel: UnitLockModel) {
        if let lockMac = lockModel.lockmac, let lockID = lockModel.lockID?.jk.intToString, let lockName = lockModel.lockname {
            PermissionManager.permissionRequest(.microphone) {[weak self] authorized in
                guard let self = self else { return }
                if authorized {
                    self.startAgoraCall(lockID, lockMac, lockName)
                }else{
                    SVProgressHUD.showInfo(withStatus: "请打开系统麦克风权限")
                }
            }
        }
    }
}
