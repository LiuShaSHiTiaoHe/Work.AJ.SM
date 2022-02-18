//
//  RemoteOpenDoorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit

class RemoteOpenDoorViewController: BaseViewController {

    private var dataSource: [UnitLockModel] = []
    
    lazy var openDoorView: RemoteOpenDoorView = {
        let view = RemoteOpenDoorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    override func initUI() {
        view.addSubview(openDoorView)
        openDoorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func initData() {
        dataSource = HomeRepository.shared.getCurrentLocks()
        
        openDoorView.tableView.register(RemoteOpenDoorCell.self, forCellReuseIdentifier: RemoteOpenDoorCellIdentifier)
        openDoorView.tableView.delegate = self
        openDoorView.tableView.dataSource = self
    }
}

extension RemoteOpenDoorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteOpenDoorCellIdentifier, for: indexPath) as! RemoteOpenDoorCell
        let unitLock = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    

}
