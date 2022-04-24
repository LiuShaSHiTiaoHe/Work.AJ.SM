//
//  MobileCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit
import SVProgressHUD

class MobileCallElevatorViewController: BaseViewController {

    var dataSource = Dictionary<String, Array<FloorMapInfo>>()
    var currentFloorID = ""
    private var originalData: MobileCallElevatorModel?
    private var selectFloor = ""//showFloor
    
    lazy var mobileCallElevator: MobileCallElevatorView = {
        let view = MobileCallElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDatas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func initUI() {
        view.addSubview(mobileCallElevator)
        mobileCallElevator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData() {
        mobileCallElevator.collectionView.delegate = self
        mobileCallElevator.collectionView.dataSource = self
        mobileCallElevator.delegate = self
        mobileCallElevator.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        MCERepository.shared.getElevators {[weak self] model, response in
            guard let `self` = self else { return }
            if model.isEmpty {
                SVProgressHUD.showInfo(withStatus: "电梯数据为空!")
                SVProgressHUD.dismiss(withDelay: 2){
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.dataSource = model
            self.originalData = response
            if self.currentFloorID.isEmpty, let floorName = model.allKeys().first {
                self.currentFloorID = floorName
            }
            self.reloadDatas()
        }
    }
    
    private func reloadDatas() {
        mobileCallElevator.collectionView.reloadData()
        mobileCallElevator.elevatorTitle.text = MCERepository.shared.getFloorName(floorID: currentFloorID, model: originalData)
        mobileCallElevator.elevatorLocation.text = HomeRepository.shared.getCurrentUnitName()
    }
    
    private func callElevator(_ floorInfo: FloorMapInfo) {
        PermissionManager.PermissionRequest(.bluetooth) { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                SVProgressHUD.show()
                guard let originalData = self.originalData else {
                    SVProgressHUD.showError(withStatus: "数据错误")
                    return
                }
                MCERepository.shared.sendCallElevatorData(self.currentFloorID, self.selectFloor, floorInfo, originalData)
            }else{
                SVProgressHUD.showInfo(withStatus: "请打开蓝牙权限")
            }
        }

    }
    
}

extension MobileCallElevatorViewController: MobileCallElevatorViewDelegate {
    func chooseElevator() {
        if let lifts = originalData?.lifts, !currentFloorID.isEmpty {
            let vc = SelectElevatorViewController()
            vc.delegate = self
            vc.currentFloorID = currentFloorID
            vc.dataSource = lifts
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MobileCallElevatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MobileCallElevatorCellidentifier, for: indexPath) as? MCECollectionViewCell else { return UICollectionViewCell() }
        if let floors = dataSource[currentFloorID] {
            let floor = floors[indexPath.row]
            if let showFloor = floor.showFloor {
                cell.elevatorName.text = showFloor
                if selectFloor == showFloor {
                    cell.backgroundColor = R.color.blueColor()
                    cell.elevatorName.textColor = R.color.whiteColor()
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let floors = dataSource[currentFloorID] {
            return floors.count
        }
        return 0
    }
    
    
}

extension MobileCallElevatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let floors = dataSource[currentFloorID] {
            let floor = floors[indexPath.row]
            if let showFloor = floor.showFloor {
                selectFloor = showFloor
                callElevator(floor)
                collectionView.reloadItems(at: [indexPath])
            }
        }

    }
}

extension MobileCallElevatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (kScreenWidth - kMargin*5)/4, height: (kScreenWidth - kMargin*5)/4)
    }
}


extension MobileCallElevatorViewController: SelectElevatorViewControllerDelegate {
    func updateSelectedElevator(_ elevatorID: String) {
        currentFloorID = elevatorID
        selectFloor = ""
        reloadDatas()
    }
}
