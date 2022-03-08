//
//  SelectUnitBlockViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/8.
//

import UIKit
import SPPermissions
import SVProgressHUD

class SelectUnitBlockViewController: BaseViewController {

    private var cityName: String? {
        didSet {
            searchView.title = cityName
            getCityCommunitiesData()
        }
    }
    private var locationManager: LocationManager!

    private var communityDataSource: [CommunityModel] = []
    private var selectedCommunity: CommunityModel?
    private var blockDataSource: [BlockModel] = []
    private var selectedBlock: BlockModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        locationManager = LocationManager.shared
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        searchView.initViewType(false)
        searchView.titleButton.addTarget(self, action: #selector(moveToSelectCity), for: .touchUpInside)
        leftTableVeiw.delegate = self
        leftTableVeiw.dataSource = self
        rightTableVeiw.delegate = self
        rightTableVeiw.dataSource = self
        judgePermission()
    }
    
    func getCityCommunitiesData() {
        if let cityName = cityName {
            SVProgressHUD.show()
            MineRepository.shared.getCommunityWithCityName(cityName) {[weak self] models in
                SVProgressHUD.dismiss()
                guard let `self` = self else { return }
                if models.count > 0 {
                    self.communityDataSource = models
                    self.selectedCommunity = models[0]
                    self.leftTableVeiw.reloadData()
                    self.getBlocksData()
                }else{
                    self.blockDataSource.removeAll()
                    self.rightTableVeiw.reloadData()
                }
            }
        }
    }
    
    func getBlocksData() {
        if let selectedCommunity = selectedCommunity, let communityID = selectedCommunity.rid?.jk.intToString {
            MineRepository.shared.getBlocksWithCommunityID(communityID) {[weak self] models in
                guard let `self` = self else { return }
                if models.count > 0 {
                    self.blockDataSource = models
                    self.rightTableVeiw.reloadData()
                }
            }
        }
    }
    
    func judgePermission() {
        if SPPermissions.Permission.locationWhenInUse.isPrecise {
            SVProgressHUD.show()
            locationManager.requestLocation()
            locationManager.getCurrentCity = { [weak self] city in
                SVProgressHUD.dismiss()
                var tempCity = "南京"
                if !city.isEmpty {
                    tempCity = city
                }
                self?.searchView.title = tempCity
                self?.cityName = tempCity
            }
        }else{
            let permissions: [SPPermissions.Permission] = [.locationWhenInUse]
            let controller = SPPermissions.dialog(permissions)
            controller.delegate = self
            controller.present(on: self)
        }
    }
    
    @objc
    func moveToSelectCity() {
        let vc = SelectUnitCityViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(tipsLabel)
        view.addSubview(leftTableVeiw)
        view.addSubview(rightTableVeiw)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(40)
        }
        
        leftTableVeiw.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(view.snp.centerX)
            make.top.equalTo(tipsLabel.snp.bottom)
        }
        
        rightTableVeiw.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "选择小区/楼栋"
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        view.placeHolder = "请输入城市名或拼音"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "请选择小区/楼栋"
        view.font = k14Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var leftTableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        return view
    }()
    
    lazy var rightTableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        return view
    }()
}


extension SelectUnitBlockViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableVeiw {
            return communityDataSource.count
        }else if tableView == rightTableVeiw {
            return blockDataSource.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableVeiw {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectUnitCellIdentifier, for: indexPath) as! SelectUnitCell
            let model = communityDataSource[indexPath.row]
            if model.rid == selectedCommunity?.rid {
                cell.backgroundColor = R.color.whiteColor()
                cell.horizonLine.isHidden = false
                cell.locationName.textColor = R.color.themeColor()
            }else{
                cell.backgroundColor = R.color.backgroundColor()
                cell.horizonLine.isHidden = true
                cell.locationName.textColor = R.color.maintextColor()
            }
            cell.locationName.text = model.name
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectUnitCellIdentifier, for: indexPath) as! SelectUnitCell
            let model = blockDataSource[indexPath.row]
            cell.backgroundColor = R.color.backgroundColor()
            cell.horizonLine.isHidden = true
            cell.locationName.textColor = R.color.maintextColor()
            cell.locationName.text = model.blockName
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == leftTableVeiw {
            self.selectedCommunity = communityDataSource[indexPath.row]
            self.leftTableVeiw.reloadData()
            getBlocksData()
        }
    }
}


extension SelectUnitBlockViewController: SPPermissionsDelegate {
    
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

extension SelectUnitBlockViewController: SelectUnitCityViewControllerDelegate {
    func selectCity(name: String) {
        cityName = name
    }
}
