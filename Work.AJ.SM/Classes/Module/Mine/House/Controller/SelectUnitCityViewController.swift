//
//  SelectUnitCityViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/3.
//

import UIKit
import SVProgressHUD
import SPPermissions
import SnapKit

let UnitCityCellIdentifier = "UnitCityCellIdentifier"

protocol SelectUnitCityViewControllerDelegate: NSObjectProtocol {
    func selectCity(name: String)
}

class SelectUnitCityViewController: BaseViewController {

    weak var delegate: SelectUnitCityViewControllerDelegate?
    private var dataSource = Dictionary<String, Array<String>>()
    private var keysArray  = Array<String>()
    private var locationManager: LocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        locationManager = LocationManager.shared
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        currentLocation.locationButton.addTarget(self, action: #selector(reLocated), for: .touchUpInside)
        searchView.initViewType(true)
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        judgePermission()
    }
    
    func getAllCity() {
        MineRepository.shared.getAllCity {[weak self] cityArray in
            if cityArray.isEmpty {
                SVProgressHUD.showInfo(withStatus: "数据为空")
            }else{
                self?.dataSource = cityArray
                self?.keysArray = cityArray.allKeys().sorted{$0 < $1}
                self?.sortAllCity()
                self?.tableVeiw.reloadData()
            }
        }
    }
    
    func judgePermission() {
        if SPPermissions.Permission.locationWhenInUse.isPrecise {
            getAllCity()
            locationManager.requestLocation()
            locationManager.getCurrentCity = { [weak self] cityName in
                self?.currentLocation.locationName.text = cityName
            }
        }else{
            let permissions: [SPPermissions.Permission] = [.locationWhenInUse]
            let controller = SPPermissions.dialog(permissions)
            controller.delegate = self
            controller.present(on: self)
        }
    }
    
    @objc
    func reLocated() {
        judgePermission()
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(currentLocation)
        view.addSubview(tableVeiw)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(60)
        }
        
        currentLocation.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        tableVeiw.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(currentLocation.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "选择城市"
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        view.placeHolder = "请输入城市名或拼音"
        return view
    }()
    
    lazy var currentLocation: CurrentLocationView = {
        let view = CurrentLocationView()
        return view
    }()
    
    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        view.separatorStyle = .singleLine
        return view
    }()
    
    func sortAllCity() {
        let items = self.items()
        let configuration = SectionIndexViewConfiguration.init()
        configuration.adjustedContentInset = UIApplication.shared.statusBarFrame.size.height + 44
        self.tableVeiw.sectionIndexView(items: items, configuration: configuration)
    }

    private func items() -> [SectionIndexViewItemView] {
        var items = [SectionIndexViewItemView]()
        for title in self.keysArray {
            let item = SectionIndexViewItemView.init()
            item.title = title
            item.indicator = SectionIndexViewItemIndicator.init(title: title)
            items.append(item)
        }
        return items
    }
}

extension SelectUnitCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 25
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = dataSource[keysArray[section]]
        return values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitCityCellIdentifier, for: indexPath)
        if let values = dataSource[keysArray[indexPath.section]] {
            let name = values[indexPath.row]
            cell.textLabel?.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let values = dataSource[keysArray[indexPath.section]] {
            let name = values[indexPath.row]
            delegate?.selectCity(name: name)
        }
    }
    
}


extension SelectUnitCityViewController: SPPermissionsDelegate {
    
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) { }
    
    func didAllowPermission(_ permission: SPPermissions.Permission) {
        switch permission {
        case .locationWhenInUse:
            judgePermission()
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
