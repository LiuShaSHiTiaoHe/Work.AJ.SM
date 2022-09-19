//
//  SelectUnitBlockViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/8.
//

import UIKit
//import SPPermissions
import SVProgressHUD

class SelectUnitBlockViewController: BaseViewController {

    private var cityName: String? {
        didSet {
            cityTipsView.cityName.text = cityName
            getCityCommunitiesData()
        }
    }
    private var communityDataSource: [CommunityModel] = []
    private var blockDataSource: [BlockModel] = []
    private var cellDataSource: [CellModel] = []
    private var unitDataSource: [UserUnitModel] = []

    private var selectedCommunity: CommunityModel? {
        didSet {
            updateLocationTips()
        }
    }
    private var selectedBlock: BlockModel? {
        didSet {
            updateLocationTips()
        }
    }
    private var selectedCell: CellModel? {
        didSet {
            updateLocationTips()
        }
    }
    private var selectedUnit: UserUnitModel? {
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
    }

    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.rightButton.setImage(R.image.common_search_image(), for: .normal)
        headerView.rightButton.isHidden = false
        headerView.rightButton.addTarget(self, action: #selector(move2HouseSearchVC), for: .touchUpInside)
        cityTipsView.delegate = self
        leftTableView.delegate = self
        leftTableView.dataSource = self
        rightTableView.delegate = self
        rightTableView.dataSource = self
        locationIndexTips.isUserInteractionEnabled = true
        locationIndexTips.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(resetSelection)))
        
        CommonAPI.amapLocation(key: kAmapKey).otherRequest { jsonData in
            if let city = jsonData["city"].string {
                if city.hasSuffix("市"){
                    self.cityName = city.jk.removeSomeStringUseSomeString(removeString: "市")
                } else {
                    self.cityName = city
                }
            } else {
                self.cityName = "南京"
            }
        } failureCallback: { response in
            self.cityName = "南京"
        }
    }

    func getCityCommunitiesData() {
        if let cityName = cityName {
            SVProgressHUD.show()
            MineRepository.shared.getCommunityWithCityName(cityName) { [weak self] models in
                SVProgressHUD.dismiss(withDelay: 1)
                guard let `self` = self else {
                    return
                }
                if models.count > 0 {
                    self.communityDataSource = models
                    var index = 0
                    if !self.searchResultCommunityRID.isEmpty, let searchResultCommunityIndex = self.communityDataSource.firstIndex(where: { element in
                        if let ridStringValue = element.rid?.jk.intToString {
                            return ridStringValue == self.searchResultCommunityRID
                        } else {
                            return false
                        }
                    }) {
                        index = searchResultCommunityIndex
                        self.selectedCommunity = self.communityDataSource[searchResultCommunityIndex]
                    } else {
                        self.selectedCommunity = models[0]
                    }
                    self.leftTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.leftTableView.scroll(row: index)
                    }
                    self.getBlocksData()
                } else {
                    self.rightTableView.reloadData()
                }
            }
        }
    }

    func getBlocksData() {
        if let selectedCommunity = selectedCommunity, let communityID = selectedCommunity.rid?.jk.intToString {
            SVProgressHUD.show()
            MineRepository.shared.getBlocksWithCommunityID(communityID) { [weak self] models in
                SVProgressHUD.dismiss(withDelay: 1)
                guard let `self` = self else {
                    return
                }
                if models.count > 0 {
                    self.blockDataSource = models
                }
                self.rightTableView.reloadData()
            }
        }
    }

    func getUserCellData(_ blockID: String) {
        SVProgressHUD.show()
        MineRepository.shared.getCellsWithBlockID(blockID) { [weak self] models in
            SVProgressHUD.dismiss(withDelay: 1)
            guard let `self` = self else {
                return
            }
            if models.count > 0 {
                self.cellDataSource = models
                self.selectedCell = models.first
                self.leftTableView.reloadData()
                if let cellID = self.selectedCell?.cellID?.jk.intToString {
                    self.getUserUnitInCell(blockID, cellID)
                }
            } else {
                self.rightTableView.reloadData()
            }
        }
    }

    func getUserUnitInCell(_ blockID: String, _ cellID: String) {
        SVProgressHUD.show()
        MineRepository.shared.getUnitWithBlockIDAndCellID(blockID, cellID) { [weak self] models in
            SVProgressHUD.dismiss(withDelay: 1)
            guard let `self` = self else {
                return
            }
            if models.count > 0 {
                self.unitDataSource = models
            }
            self.rightTableView.reloadData()
        }
    }
    
    
    @objc
    func moveToSelectCity() {
        let vc = SelectUnitCityViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func moveToCertification() {
        let vc = HouseCertificationViewController()
        vc.selectedCommunity = selectedCommunity
        vc.selectedBlock = selectedBlock
        vc.selectedCell = selectedCell
        vc.selectedUnit = selectedUnit
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func move2HouseSearchVC() {
        let vc = HouseSearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(headerView)
        view.addSubview(cityTipsView)
        view.addSubview(tipsLabel)
        view.addSubview(locationIndexTips)
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        locationIndexTips.isHidden = true

        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }

        cityTipsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
            make.top.equalTo(headerView.snp.bottom)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(kMargin / 2)
            make.top.equalTo(cityTipsView.snp.bottom)
            make.height.equalTo(40)
        }

        locationIndexTips.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cityTipsView.snp.bottom)
            make.height.equalTo(90)
        }

        leftTableView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(view.snp.centerX)
            make.top.equalTo(tipsLabel.snp.bottom)
        }

        rightTableView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whitecolor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "选择小区/楼栋"
        view.titleLabel.textColor = R.color.text_title()
        return view
    }()

    lazy var cityTipsView: CityTipsView = {
        let view = CityTipsView()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "请选择小区/楼栋"
        view.font = k14Font
        view.textColor = R.color.text_info()
        return view
    }()

    lazy var locationIndexTips: SelectHouseIndexView = {
        let view = SelectHouseIndexView()
        return view
    }()

    lazy var leftTableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        return view
    }()

    lazy var rightTableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(SelectUnitCell.self, forCellReuseIdentifier: SelectUnitCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        return view
    }()
}


extension SelectUnitBlockViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectCommunity {
            if tableView == leftTableView {
                return communityDataSource.count
            } else {
                return blockDataSource.count
            }
        } else {
            if tableView == leftTableView {
                return cellDataSource.count
            } else {
                return unitDataSource.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectUnitCellIdentifier, for: indexPath) as! SelectUnitCell
        cell.isCurrentCell = false
        if isSelectCommunity {
            if tableView == leftTableView {
                let model = communityDataSource[indexPath.row]
                if model.rid == selectedCommunity?.rid {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.name
            } else {
                let model = blockDataSource[indexPath.row]
                if model.rid == selectedBlock?.rid {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.blockName
            }
        } else {
            if tableView == leftTableView {
                let model = cellDataSource[indexPath.row]
                if model.cellID == selectedCell?.cellID {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.cellName
            } else {
                let model = unitDataSource[indexPath.row]
                if model.rid == selectedUnit?.rid {
                    cell.isCurrentCell = true
                }
                cell.locationName.text = model.unitNO
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if isSelectCommunity {
            if tableView == leftTableView {
                let currentCommunity = communityDataSource[indexPath.row]
                if selectedCommunity?.rid != currentCommunity.rid {
                    selectedCommunity = currentCommunity
                    leftTableView.reloadData()
                    clearBlockData()
                    getBlocksData()
                }
            } else {
                let currentBlock = blockDataSource[indexPath.row]
                if let blockID = currentBlock.rid?.jk.intToString {
                    selectedBlock = currentBlock
                    clearCellData()
                    isSelectCommunity = false
                    getUserCellData(blockID)
                }
            }
        } else {
            if tableView == leftTableView {
                let currentCell = cellDataSource[indexPath.row]
                if selectedCell?.cellID != currentCell.cellID {
                    selectedCell = currentCell
                    leftTableView.reloadData()
                    if let blockID = selectedBlock?.rid?.jk.intToString, let cellID = currentCell.cellID?.jk.intToString {
                        clearUnitData()
                        getUserUnitInCell(blockID, cellID)
                    }
                }
            } else {
                let currentUnit = unitDataSource[indexPath.row]
                selectedUnit = currentUnit
                rightTableView.reloadData()
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

        guard let selectedUnit = selectedUnit, let unitName = selectedUnit.unitNO else {
            return
        }
        locations.append(unitName)
        locationIndexTips.locations = locations

    }

    func remakeConstraints() {
        if isSelectCommunity {
            locationIndexTips.isHidden = true
            tipsLabel.snp.updateConstraints { make in
                make.top.equalTo(cityTipsView.snp.bottom).offset(0)
            }
        } else {
            locationIndexTips.isHidden = false
            tipsLabel.snp.updateConstraints { make in
                make.top.equalTo(cityTipsView.snp.bottom).offset(90)
            }
        }
    }

    @objc
    func resetSelection() {
        if !isSelectCommunity {
            isSelectCommunity = true
            clearCellData()
            leftTableView.reloadData()
            rightTableView.reloadData()
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

extension SelectUnitBlockViewController: CityTipsViewDelegate {
    func chooseCity() {
        moveToSelectCity()
    }
}
