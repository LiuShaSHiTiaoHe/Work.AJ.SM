//
//  HomeViewController.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/28.
//

import UIKit
import SwiftEntryKit
import AVFoundation
import SVProgressHUD
import swiftScan
import JKSwiftExtension

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
        if let _ = ud.currentUnitID {
            if isNoDataViewShow {
                self.hideNoDataView()
            }
        } else {
            if !isNoDataViewShow {
                self.showNoDataView(.nohouse)
            }
        }
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
            case .Invalid, .Expire, .Blocked:
                self.showNoDataView(.nohouse)
                SVProgressHUD.showInfo(withStatus: "该房屋已被停用，请联系物业或添加其他房屋")
            case .Unknown:
                self.showNoDataView(.nohouse)
            case .Normal:
                self.hideNoDataView()
                self.contentView.updateHomeFunctions(modules)
                self.contentView.updateAdsAndNotices(ads, notices)
            case .Pending:
                self.showNoDataView(.nohouse)
                SVProgressHUD.showInfo(withStatus: "该房屋审核中，请联系物业获取审核结果")
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
            showModuleVersionControlTipsView(module: .RemoteOpendoor) { [weak self] in
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
        }
    }
}

extension HomeViewController {
    // MARK: - 功能模块开启状态，是否提示升级
    func showModuleVersionControlTipsView(module: ModulesOfModuleStatus, completion: @escaping () -> Void) {
        if HomeRepository.shared.getModuleStatusFromCache(module: module) {
            completion()
        } else {
            let alert = UIAlertController.init(title: "升级提示", message: "您的APP版本过低，已严重影响您使用该功能，请升级至最新版本，点击“下载” \n 注意：升级过程中将无法使用软件 ", preferredStyle: .alert)
            alert.addAction("取消", .cancel) {
                completion()
            }
            alert.addAction("下载", .destructive) {
                JKGlobalTools.updateApp(vc: self, appId: kAppID )
            }
            alert.show()
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
