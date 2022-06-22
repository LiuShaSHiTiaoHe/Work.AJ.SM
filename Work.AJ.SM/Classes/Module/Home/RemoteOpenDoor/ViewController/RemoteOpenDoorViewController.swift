//
//  RemoteOpenDoorViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/18.
//

import UIKit
import SVProgressHUD

class RemoteOpenDoorViewController: BaseViewController {

    private var dataSource: [UnitLockModel] = []
    
    lazy var contentView: RemoteOpenDoorView = {
        let view = RemoteOpenDoorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        SVProgressHUD.show()
        HomeRepository.shared.getAllLocks { [weak self] models in
            SVProgressHUD.dismiss()
            guard let `self` = self else { return }
            self.dataSource = models
            self.contentView.tableView.reloadData()
        }
        // MARK: - PageID = 1 远程开门 2 门禁对讲
        HomeRepository.shared.getSpecificPageNotice(with: "1") { [weak self] errorMsg, notice in
            guard let `self` = self else { return }
            if notice.isEmpty {
                self.contentView.offlineTipsText = kDefaultRemoteOpenDoorTips
            } else {
                self.contentView.offlineTipsText = notice
            }
        }
    }
}

extension RemoteOpenDoorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteOpenDoorCellIdentifier, for: indexPath) as! RemoteOpenDoorCell
        let unitLock = dataSource[indexPath.row]
        cell.setUpData(model: unitLock)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    

}

extension RemoteOpenDoorViewController: RemoteOpenDoorCellDelegate {
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

        if let lockMac = lockModel.lockmac {
            PermissionManager.permissionRequest(.microphone) { authorized in
                if authorized {
                    let vc = VideoChatViewController.init(startCall: lockMac)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    SVProgressHUD.showInfo(withStatus: "请打开系统麦克风权限")
                }
            }
        }
    }
}
