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
    private var blockDataSource: [BlockModel] = []
    private var cellDataSource: [CellModel] = []
    private var unitDataSource: [UserUnitModel] = []
    
    private var selectedCommunity: CommunityModel?{
        didSet {
            updateLocationTips()
        }
    }
    private var selectedBlock: BlockModel?{
        didSet {
            updateLocationTips()
        }
    }
    private var selectedCell: CellModel?{
        didSet {
            updateLocationTips()
        }
    }
    private var selectedUnit: UserUnitModel?{
        didSet {
            updateLocationTips()
        }
    }
    
    private var isSelectCommunity = true {
        didSet {
            remakeConstraints()
        }
    }
    
    private var searchResultCommunityRID = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        locationManager = LocationManager.shared
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        searchView.initViewType(false)
        searchView.titleButton.addTarget(self, action: #selector(moveToSelectCity), for: .touchUpInside)
        searchView.searchView.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        leftTableVeiw.delegate = self
        leftTableVeiw.dataSource = self
        rightTableVeiw.delegate = self
        rightTableVeiw.dataSource = self
        locationIndexTips.isUserInteractionEnabled = true
        locationIndexTips.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(resetSelection)))
        requestUserLocation()
    }
    
    func getCityCommunitiesData() {
        if let cityName = cityName {
            SVProgressHUD.show()
            MineRepository.shared.getCommunityWithCityName(cityName) {[weak self] models in
                SVProgressHUD.dismiss()
                guard let `self` = self else { return }
                if models.count > 0 {
                    self.communityDataSource = models
                    if !self.searchResultCommunityRID.isEmpty {
                        self.selectedCommunity = self.communityDataSource.first(where: { element in
                            if let ridStringValue = element.rid?.jk.intToString {
                                return ridStringValue == self.searchResultCommunityRID
                            }else{
                                return false
                            }
                        })
                    }else{
                        self.selectedCommunity = models[0]
                    }
                    self.leftTableVeiw.reloadData()
                    self.getBlocksData()
                }else{
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
                }
                self.rightTableVeiw.reloadData()
            }
        }
    }
    
    func getUserCellData(_ blockID: String) {
        MineRepository.shared.getCellsWithBlockID(blockID){ [weak self] models in
            guard let `self` = self else { return }
            if models.count > 0 {
                self.cellDataSource = models
                self.selectedCell = models.first
                self.leftTableVeiw.reloadData()
                if let cellID = self.selectedCell?.cellID?.jk.intToString {
                    self.getUserUnitInCell(blockID, cellID)
                }
            }else{
                self.rightTableVeiw.reloadData()
            }
        }
    }
    
    func getUserUnitInCell(_ blockID: String, _ cellID: String) {
        MineRepository.shared.getUnitWithBlockIDAndCellID(blockID, cellID){ [weak self] models in
            guard let `self` = self else { return }
            if models.count > 0 {
                self.unitDataSource = models
            }
            self.rightTableVeiw.reloadData()
        }
    }
    
    func requestUserLocation() {
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
    
    func moveToCertification() {
        let vc = HouseCertificationViewController()
        vc.selectedCommunity = selectedCommunity
        vc.selectedBlock = selectedBlock
        vc.selectedCell = selectedCell
        vc.selectedUnit = selectedUnit
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @objc func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            sender.resignFirstResponder()
            let vc = HouseSearchViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(tipsLabel)
        view.addSubview(locationIndexTips)
        view.addSubview(leftTableVeiw)
        view.addSubview(rightTableVeiw)
        
        locationIndexTips.isHidden = true
        
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
            make.left.right.equalToSuperview().offset(kMargin/2)
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(40)
        }
        
        locationIndexTips.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(90)
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
        view.placeHolder = "请输入关键字"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "请选择小区/楼栋"
        view.font = k14Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var locationIndexTips: SelectHouseIndexView = {
        let view = SelectHouseIndexView()
        return view
    }()
    
    lazy var leftTableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var rightTableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
}


extension SelectUnitBlockViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectCommunity {
            if tableView == leftTableVeiw {
                return communityDataSource.count
            }else {
                return blockDataSource.count
            }
        }else{
            if tableView == leftTableVeiw {
                return cellDataSource.count
            }else{
                return unitDataSource.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectUnitCellIdentifier, for: indexPath) as! SelectUnitCell
        cell.isCurrentCell = false
        if isSelectCommunity {
            if tableView == leftTableVeiw {
                let model = communityDataSource[indexPath.row]
                if model.rid == selectedCommunity?.rid {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.name
            }else {
                let model = blockDataSource[indexPath.row]
                if model.rid == selectedBlock?.rid {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.blockName
            }
        }else{
            if tableView == leftTableVeiw {
                let model = cellDataSource[indexPath.row]
                if model.cellID == selectedCell?.cellID {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.cellName
            }else{
                let model = unitDataSource[indexPath.row]
                if model.rid == selectedUnit?.rid{
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.rid?.jk.intToString
            }
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if isSelectCommunity {
            if tableView == leftTableVeiw {
                let currentCommunity = communityDataSource[indexPath.row]
                if selectedCommunity?.rid != currentCommunity.rid {
                    selectedCommunity = currentCommunity
                    leftTableVeiw.reloadData()
                    clearBlockData()
                    getBlocksData()
                }
            }else{
                let currentBlock = blockDataSource[indexPath.row]
                if let blockID = currentBlock.rid?.jk.intToString {
                    selectedBlock = currentBlock
                    clearCellData()
                    isSelectCommunity = false
                    getUserCellData(blockID)
                }
            }
        }else{
            if tableView == leftTableVeiw {
                let currentCell = cellDataSource[indexPath.row]
                if selectedCell?.cellID != currentCell.cellID {
                    selectedCell = currentCell
                    self.leftTableVeiw.reloadData()
                    if let blockID = selectedBlock?.rid?.jk.intToString, let cellID = currentCell.cellID?.jk.intToString {
                        clearUnitData()
                        getUserUnitInCell(blockID, cellID)
                    }
                }
            }else{
                let currentUnit = unitDataSource[indexPath.row]
                selectedUnit = currentUnit
                rightTableVeiw.reloadData()
                moveToCertification()
            }
        }
    }
}


extension SelectUnitBlockViewController {
    
    func updateLocationTips() {
        var locations: [String] = []
        guard let selectedCommunity = selectedCommunity, let communityName = selectedCommunity.name else {
            return
        }
        locations.append(communityName)
        locationIndexTips.locations = locations
        guard let selectedBlock = selectedBlock, let blockName = selectedBlock.blockName else {
            return
        }
        locations.append(blockName)
        locationIndexTips.locations = locations

        guard let selectedCell = selectedCell, let cellName = selectedCell.cellName else {
            return
        }
        locations.append(cellName)
        locationIndexTips.locations = locations

        guard let selectedUnit = selectedUnit, let unitName = selectedUnit.rid?.jk.intToString else {
            return
        }
        locations.append(unitName)
        locationIndexTips.locations = locations

    }
    
    func remakeConstraints() {
        if isSelectCommunity {
            locationIndexTips.isHidden = true
            tipsLabel.snp.updateConstraints { make in
                make.top.equalTo(searchView.snp.bottom).offset(0)
            }
        }else{
            locationIndexTips.isHidden = false
            tipsLabel.snp.updateConstraints { make in
                make.top.equalTo(searchView.snp.bottom).offset(90)
            }
        }
    }
    
    @objc
    func resetSelection() {
        if !isSelectCommunity {
            isSelectCommunity = true
            clearCellData()
            leftTableVeiw.reloadData()
            rightTableVeiw.reloadData()
        }
    }
    
    func clearCommunityData() {
        selectedCommunity = nil
        communityDataSource.removeAll()
        clearBlockData()
    }
    
    func clearBlockData() {
        selectedBlock = nil
        blockDataSource.removeAll()
        clearCellData()
    }
    
    func clearCellData() {
        selectedCell = nil
        cellDataSource.removeAll()
        clearUnitData()
    }
    
    func clearUnitData() {
        selectedUnit = nil
        unitDataSource.removeAll()
    }
}


extension SelectUnitBlockViewController: SPPermissionsDelegate {
    
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) { }
    
    func didAllowPermission(_ permission: SPPermissions.Permission) {
        switch permission {
        case .locationWhenInUse:
            requestUserLocation()
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
        isSelectCommunity = true
        cityName = name
    }
}


extension SelectUnitBlockViewController: HouseSearchViewControllerDelegate {
    func searchResultOfCommunity(_ data: CommunityModel) {
        resetSelection()
        if let ridString = data.rid?.jk.intToString {
            searchResultCommunityRID = ridString
            cityName = data.city
        }
    }
}
