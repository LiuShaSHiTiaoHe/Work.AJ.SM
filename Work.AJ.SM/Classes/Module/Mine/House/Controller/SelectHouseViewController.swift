//
//  SelectHouseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit

class SelectHouseViewController: BaseViewController {

    var units: [UnitModel] = []
    private var initialUnitID: Int = 0
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView.init()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(HouseCell.self, forCellReuseIdentifier: "HouseCell")
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let unitID = Defaults.currentUnitID {
            initialUnitID = unitID
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let unitID = Defaults.currentUnitID, initialUnitID != unitID {
            NotificationCenter.default.post(name: .kCurrentUnitChanged, object: nil)
        }
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    override func initData() {
        headerView.rightButton.setTitle("添加", for: .normal)
        headerView.rightButton.addTarget(self, action: #selector(addHouse), for: .touchUpInside)
        headerView.titleLabel.text = "选择房屋"
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
        MineRepository.shared.getAllSelectableUnit { [weak self]  models in
            guard let `self` = self else { return }
            if models.isEmpty {
                SVProgressHUD.showError(withStatus: "数据为空")
            }else{
                self.units.removeAll()
                self.units.append(contentsOf: models)
                self.tableView.reloadData()
            }
        }
    }
    
    
    @objc
    func addHouse(){
        
    }


}

extension SelectHouseViewController: HouseCellDelegate {
    func chooseCurrentUnit(unitID: Int) {
        Defaults.currentUnitID = unitID
        tableView.reloadData()
    }
}

extension SelectHouseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
        let unit = units[indexPath.row]
        cell.unit = unit
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let unit = units[indexPath.row]
//        if let unitID = unit.unitid {
//            Defaults.currentUnitID = unitID
//            tableView.reloadData()
//        }
//    }
    
}
