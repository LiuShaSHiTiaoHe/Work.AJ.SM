//
//  HouseViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/15.
//

import UIKit
import SVProgressHUD
import SPPermissions

class HouseViewController: BaseViewController {

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
    
    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加房屋", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addHouse), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
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
    
    override func initData() {
        headerView.rightButton.isHidden = true
        headerView.rightButton.addTarget(self, action: #selector(addHouse), for: .touchUpInside)
        headerView.titleLabel.text = "我的房屋"
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
        MineRepository.shared.getAllUnits { [weak self] errorMsg in
            guard let `self` = self else { return }
            if errorMsg.isEmpty {
                self.units.removeAll()
                self.units.append(contentsOf: RealmTools.objects(UnitModel()))
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: errorMsg)
            }
        }
    }
    
    
    @objc
    func addHouse(){
        if SPPermissions.Permission.locationWhenInUse.isPrecise {
            self.navigationController?.pushViewController(SelectUnitCityViewController(), animated: true)
        }else{
            let permissions: [SPPermissions.Permission] = [.locationWhenInUse]
            let controller = SPPermissions.dialog(permissions)
            controller.titleText = "需要授权"
            controller.headerText = "授权请求"
            controller.footerText = "为了提供更好的服务, App 需要如下权限. 请参考每个权限的说明."
            controller.dataSource = self
            controller.delegate = self
            controller.present(on: self)
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
        
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "如需加快房屋审核，请联系物业"
    }
}

extension HouseViewController: SPPermissionsDelegate, SPPermissionsDataSource {
    func deniedAlertTexts(for permission: SPPermissions.Permission) -> SPPermissionsDeniedAlertTexts? {
        let texts = SPPermissionsDeniedAlertTexts()
        texts.titleText = "已拒绝授权"
        texts.descriptionText = "请跳转至设置并允许授权"
        texts.actionText = "设置"
        texts.cancelText = "取消"
        return texts
    }
    
    
    func configure(_ cell: SPPermissionsTableViewCell, for permission: SPPermissions.Permission) {
            
            // Here you can customise cell, like texts or colors.
            cell.permissionTitleLabel.text = "使用 App 期间访问位置"
            cell.permissionDescriptionLabel.text = "访问您的位置"
    }
    
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) { }
    
    func didAllowPermission(_ permission: SPPermissions.Permission) {
        switch permission {
        case .locationWhenInUse:
            self.navigationController?.pushViewController(SelectUnitCityViewController(), animated: true)
            break
        default:
            break
        }
    }
    
    func didDeniedPermission(_ permission: SPPermissions.Permission) {
        switch permission {
        case .locationWhenInUse:
            SVProgressHUD.showInfo(withStatus: "需要您的位置信息")
            break
        default:
            break
        }
    }
}
