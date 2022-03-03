//
//  HomeViewController.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/28.
//

import UIKit
import SwiftEntryKit
import AVFoundation
import SVProgressHUD
import swiftScan

class HomeViewController: BaseViewController {

    private let cellIdentifier = "HomeModuleCell"
    private let sectionHeaderIdentifier = "HomeHeaderView"
    private var functionModules: [HomePageFunctionModule] = []
    private var advertisements: [AdsModel] = []
    private var notices: [NoticeModel] = []
    
    lazy var headerView: HomeNaviHeaderView = {
        let view = HomeNaviHeaderView.init()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin/2, left: kMargin/2, bottom: kMargin/2, right: kMargin/2)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceVertical = true
        c.backgroundColor = UIColor.clear
        c.register(HomeModuleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        addlayer()
        view.addSubview(headerView)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.mj_header = refreshHeader
        
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    override func initData() {
        NotificationCenter.default.addObserver(self, selector: #selector(currentUnitChanged), name: .kCurrentUnitChanged, object: nil)
        headerView.delegate = self
        getData()
    }
    
    func getData() {
        HomeRepository.shared.allUnits { [weak self] modules in
            guard let `self` = self else { return }
            self.functionModules.removeAll()
            self.functionModules.append(contentsOf: modules)
            self.updateTitle()
            self.getAdsAndNotices()
        }
   
    }
    
    override func headerRefresh() {
        getData()
    }
    
    @objc
    func currentUnitChanged() {
        getData()
    }
    
    func updateTitle() {
        if let unitID = Defaults.currentUnitID {
            headerView.updateTitle(unitName: HomeRepository.shared.getUnitName(unitID: unitID))
        }
    }
    
    func getAdsAndNotices() {
        HomeRepository.shared.adsAndNotice { [weak self] ads, notice in
            guard let `self` = self else { return }
            self.advertisements.removeAll()
            self.notices.removeAll()
            self.advertisements.append(contentsOf: ads)
            self.notices.append(contentsOf: notice)
            self.reloadView()
        }
    }
    
    func reloadView() {
        collectionView.reloadData()
        collectionView.mj_header?.endRefreshing()
    }

}

extension HomeViewController: HomeNaviHeaderViewDelegate {
    func chooseUnit() {
        let vc = SelectHouseViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? HomeModuleCell else { return UICollectionViewCell() }
        cell.initData(functionModules[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionModules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionHeaderIdentifier, for: indexPath) as? HomeHeaderView else { return UICollectionReusableView() }
        header.initData(ads: [], notice: [])
        return header
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let module = functionModules[indexPath.row]
        if let homePageModule: HomePageModule = HomePageModule.init(rawValue: module.name) {
            switch homePageModule {
            case .mobileCallElevator:
                let vc = MobileCallElevatorViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .ownerQRCode:
                let vc = OwnerQRCodeViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .indoorCallElevator:
                let vc = IndoorCallElevatorViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .bleCallElevator:
                PopViewManager.shared.display(BleCallElevatorViewController(), .center, .init(
                    width: .constant(value: 280),
                    height: .constant(value: 380)
                ), true)
            case .cloudOpneGate:
                let vc = RemoteOpenDoorViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .cloudIntercom:
                let vc = RemoteIntercomViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .scanElevatorQRCode:
                if let device = AVCaptureDevice.default(for: .video) {
                    do {
                        let _ = try AVCaptureDeviceInput.init(device: device)
                        let vc = ScanQRCodeCallElevatorViewController()//ScanQRCodeCallElevatorManager.manager.setUpScanManager()
//                        vc.scanResultDelegate = self
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } catch {
                        SVProgressHUD.showError(withStatus: "没有可使用的相机")
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "没有可使用的相机")
                }
            case .inviteVisitors:
                let view = ChooseVisitorModeView()
                view.delegate = self
                PopViewManager.shared.display(view, .center, .init(width: .constant(value: 260), height: .constant(value: 250)), true)
            case .addFamilyMember:
                let vc = AddMemberViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .deviceConfiguration:
                break
            default :
                return
                
            }
        }

    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width - kMargin*2)/2, height: (view.frame.width - kMargin*2)/4 )
    }
}

extension HomeViewController: ChooseVisitorModeDelegate {
    func qrcode() {
        SwiftEntryKit.dismiss(.displayed) {
            let vc = SetVisitorQRCodeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func password() {
        SwiftEntryKit.dismiss(.displayed) {
            let vc = SetVisitorPasswordViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

