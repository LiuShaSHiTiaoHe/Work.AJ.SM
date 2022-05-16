//
//  HouseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/15.
//

import UIKit
import SVProgressHUD

class HouseViewController: BaseViewController {

    var units: [UnitModel] = []
    private var initialUnitID: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let unitID = Defaults.currentUnitID {
            initialUnitID = unitID
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.mj_header?.beginRefreshing()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let unitID = Defaults.currentUnitID, initialUnitID != unitID {
            NotificationCenter.default.post(name: .kCurrentUnitChanged, object: nil)
        }
    }

    override func initData() {
        headerView.rightButton.isHidden = true
        headerView.rightButton.addTarget(self, action: #selector(addHouse), for: .touchUpInside)
        headerView.titleLabel.text = "我的房屋"
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
    }


    @objc
    func addHouse() {
        navigationController?.pushViewController(SelectUnitBlockViewController(), animated: true)
    }

    override func headerRefresh() {
        MineRepository.shared.getAllUnits { [weak self] errorMsg in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            if errorMsg.isEmpty {
                self.units.removeAll()
                self.units.append(contentsOf: RealmTools.objects(UnitModel()))
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: errorMsg)
                self.showNoDataView(.nohouse, self.headerView)
            }
        }
    }

    // MARK: - UI
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView.init()
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(HouseCell.self, forCellReuseIdentifier: "HouseCell")
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        view.mj_header = refreshHeader(R.color.blackColor())
        return view
    }()

    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加房屋", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addHouse), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()

    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
        }

        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }


}

extension HouseViewController: HouseCellDelegate {
    func chooseCurrentUnit(unitID: Int) {
        Defaults.currentUnitID = unitID
        tableView.reloadData()
    }
}

extension HouseViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
        let unit = units[indexPath.row]
        cell.unit = unit
        cell.isSelectHouse = false
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
        view.backgroundColor = R.color.backgroundColor()
        view.text = "如需加快房屋审核，请联系物业"
        view.textAlignment = .center
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        view.backgroundColor = R.color.backgroundColor()
        return view
    }

}

