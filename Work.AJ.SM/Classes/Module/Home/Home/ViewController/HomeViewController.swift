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
    
    lazy var contentView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(currentUnitChanged), name: .kCurrentUnitChanged, object: nil)
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData() {
        contentView.delegate = self
        contentView.collectionView.mj_header = refreshHeader()
        loadUnitData()
    }
    
    override func headerRefresh() {
        loadUnitData()
    }

    @objc
    func currentUnitChanged() {
        loadUnitData()
    }
    
    func loadUnitData() {
        HomeRepository.shared.homeData { [weak self] modules, ads, notices in
            guard let `self` = self else { return }
            if modules.isEmpty {
                self.showNoDataView(.nohouse)
            }else{
                self.hideNoDataView()
                self.contentView.updateHomeFunctions(modules)
                self.contentView.updateAdsAndNotices(ads, notices)
            }
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func chooseUnit() {
        pushTo(viewController: SelectHouseViewController())
    }
    
    func selectModule(_ module: HomePageModule) {
        switch module {
        case .mobileCallElevator:
            pushTo(viewController: MobileCallElevatorViewController())
        case .ownerQRCode:
            pushTo(viewController: OwnerQRCodeViewController())
        case .indoorCallElevator:
            pushTo(viewController: IndoorCallElevatorViewController())
        case .bleCallElevator:
            PopViewManager.shared.display(BleCallElevatorViewController(), .center, .init(
                width: .constant(value: 280),
                height: .constant(value: 380)
            ), true)
        case .cloudOpneGate:
            pushTo(viewController: RemoteOpenDoorViewController())
        case .cloudIntercom:
            pushTo(viewController: RemoteIntercomViewController())
        case .scanElevatorQRCode:
            if GDataManager.shared.checkAvailableCamera() {
                pushTo(viewController: ScanQRCodeCallElevatorViewController())
            }else{
                SVProgressHUD.showError(withStatus: "没有可使用的相机")
            }
        case .inviteVisitors:
            let view = ChooseVisitorModeView()
            view.delegate = self
            PopViewManager.shared.display(view, .center, .init(width: .constant(value: 260), height: .constant(value: 250)), true)
        case .addFamilyMember:
            pushTo(viewController: AddMemberViewController())
        case .deviceConfiguration:
            break
        case .elevatorConfiguration:
            pushTo(viewController: ElevatorConfigurationViewController())
        case .ncall:
            pushTo(viewController: NComViewController())
        default :
            return
            
        }
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

