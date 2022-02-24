//
//  MineViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class MineViewController: BaseViewController {

    private var dataSource: [MineModule] = []
    
    lazy var contentView: MineView = {
        let view = MineView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    func initData() {
        if let userID = ud.userID, let userInfo = HomeRepository.shared.getCurrentUser(), let name = userInfo.userName, let mobile = userInfo.mobile {
            contentView.nameLabel.text = name
            contentView.phoneLabel.text = mobile.jk.hidePhone()
        }
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        dataSource = MineRepository.shared.getMineModules()
        contentView.tableView.reloadData()
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSource.filter{$0.destination == .mine_0}.count
        case 1:
            return dataSource.filter{$0.destination == .mine_1}.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCellIdentifier, for: indexPath) as! MineTableViewCell
        switch indexPath.section {
        case 0:
            let module = dataSource.filter{$0.destination == .mine_0}.sorted { $0.index < $1.index}[indexPath.row]
            cell.titleName = module.name
            cell.iconName = module.icon
        case 1:
            let module = dataSource.filter{$0.destination == .mine_1}.sorted { $0.index < $1.index}[indexPath.row]
            cell.titleName = module.name
            cell.iconName = module.icon
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
