//
//  HomeViewController.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/28.
//

import AVFoundation
import SwiftEntryKit
import swiftScan
import UIKit

class HomeViewController: BaseViewController {
    lazy var contentView: HomeView = {
        let view = HomeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(currentUnitChanged), name: .kCurrentUnitChanged, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    override func emptyViewRefresh() {
        loadUnitData()
    }

    @objc
    func currentUnitChanged() {
        loadUnitData()
    }

    func loadUnitData() {
        HomeRepository.shared.homeData { [weak self] modules, ads, notices, status in
            guard let `self` = self else {
                return
            }
            switch status {
            case .Invalid, .Expire, .Blocked, .Unknown, .Pending:
                self.contentView.updateTitle(title: "暂无可用房屋")
                self.contentView.updateHomeFunctions(HomeRepository.shared.defaultHomeageModules())
            case .Normal:
                self.hideNoDataView()
                self.contentView.updateHomeFunctions(modules)
                self.contentView.updateAdsAndNotices(ads, notices)
                // MARK: - 获取模块控制信息/自动检查版本，切换房屋或者刷新也有效
                HomeRepository.shared.getModuleStatusFromServer()
                AppUpgradeManager.shared.autoCheckVersion()
            }
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func chooseUnit() {
        navigateTo(viewController: SelectHouseViewController())
    }

    func selectModule(_ module: HomePageModule) {
        switch module {
        case .mobileCallElevator:
            navigateTo(viewController: MobileCallElevatorViewController())
        case .ownerQRCode:
            showModuleVersionControlTipsView(module: .PassQR) { [weak self] in
                guard let `self` = self else { return }
                self.navigateTo(viewController: OwnerQRCodeViewController())
            }
        case .indoorCallElevator:
            navigateTo(viewController: IndoorCallElevatorViewController())
        case .bleCallElevator:
            PopViewManager.shared.display(BleCallElevatorViewController(), .center, .init(
                width: .constant(value: 280),
                height: .constant(value: 380)
            ), true)
        case .cloudOpenGate:
            showModuleVersionControlTipsView(module: .RemoteOpenDoor) { [weak self] in
                guard let `self` = self else { return }
                self.navigateTo(viewController: RemoteOpenDoorViewController())
            }
        case .cloudIntercom:
            showModuleVersionControlTipsView(module: .RemoteIntercom) { [weak self] in
                guard let `self` = self else { return }
                self.navigateTo(viewController: RemoteIntercomViewController())
            }
        case .scanElevatorQRCode:
            showModuleVersionControlTipsView(module: .ScanQR) { [weak self] in
                guard let `self` = self else { return }
                if GDataManager.shared.checkAvailableCamera() {
                    self.navigateTo(viewController: ScanQRCodeCallElevatorViewController())
                } else {
                    SVProgressHUD.showError(withStatus: "没有可使用的相机")
                }
            }
        case .inviteVisitors:
            showModuleVersionControlTipsView(module: .Invitation) { [weak self] in
                guard let `self` = self else { return }
                let view = ChooseVisitorModeView()
                view.delegate = self
                PopViewManager.shared.display(view, .center, .init(width: .constant(value: 260), height: .constant(value: 250)), true)
            }
        case .addFamilyMember:
            showModuleVersionControlTipsView(module: .AddMember) { [weak self] in
                guard let `self` = self else { return }
                self.navigateTo(viewController: AddMemberViewController())
            }
        case .deviceConfiguration:
            break
        case .elevatorConfiguration:
            navigateTo(viewController: ElevatorConfigurationViewController())
        case .userQRCode:
            navigateTo(viewController: UserIdentifyQRCodeViewController())
        case .gusetQRCode:
            navigateTo(viewController: AddGuestQRCodeViewController())
        }
    }
}

extension HomeViewController {}

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
