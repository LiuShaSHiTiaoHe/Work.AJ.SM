//
//  RemoteOpenDoorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
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

        // Do any additional setup after loading the view.
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
        
    }
}

extension RemoteOpenDoorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteOpenDoorCellIdentifier, for: indexPath) as! RemoteOpenDoorCell
        let unitLock = dataSource[indexPath.row]
        cell.setUpData(model: unitLock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    

}
