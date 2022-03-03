//
//  ScanQRCodeSelectElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/25.
//

import UIKit

class ScanQRCodeSelectElevatorViewController: BaseViewController {
    
    var SNCode: String?
    private var dataSource = [FloorInfoMappable]()
    var currentFloorID = ""
    private var selectFloor = ""

    lazy var contentView: ScanQRCodeSelectElevatorView = {
        let view = ScanQRCodeSelectElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        contentView.headerView.titleLabel.text = "选择楼层"
        contentView.headerView.closeButton.addTarget(self, action: #selector(popRoot), for: .touchUpInside)
        
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.delegate = self
        if let SNCode = SNCode {
//            MCERepository.shared.getFloorsBySNCode(code: SNCode) { [weak self] model, response in
//                guard let `self` = self else { return }
//                self.dataSource = model
//                self.originalData = response
//                if self.currentFloorID.isEmpty, let floorName = model.allKeys().first {
//                    self.currentFloorID = floorName
//                }
//                self.reloadDatas()
//            }
            MCERepository.shared.getFloorsBySNCode(code: SNCode) {[weak self] models in
                guard let `self` = self else { return }
                self.dataSource = models
                self.reloadDatas()
            }
        }
    }
    
    private func reloadDatas() {
        contentView.collectionView.reloadData()
//        contentView.elevatorTitle.text = MCERepository.shared.getFloorName(floorID: currentFloorID, model: originalData)
    }
    
    @objc
    func popRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
  

}


extension ScanQRCodeSelectElevatorViewController: ScanQRCodeSelectElevatorViewDelegate {
    func chooseElevator() {

    }
}

extension ScanQRCodeSelectElevatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MobileCallElevatorCellidentifier, for: indexPath) as? MCECollectionViewCell else { return UICollectionViewCell() }
        let floor = dataSource[indexPath.row]
        if let showFloor = floor.showFloor {
            cell.elevatorName.text = showFloor
            if selectFloor == showFloor {
                cell.backgroundColor = R.color.blueColor()
                cell.elevatorName.textColor = R.color.whiteColor()
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
}

extension ScanQRCodeSelectElevatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ScanQRCodeSelectElevatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (kScreenWidth - kMargin*5)/4, height: (kScreenWidth - kMargin*5)/4)
    }
}
