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

    private var functionModules: [HomePageFunctionModule] = []
    private var advertisements: [AdsModel] = []
    private var notices: [NoticeModel] = []
    
    lazy var contentView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.collectionView.mj_header = refreshHeader()
        NotificationCenter.default.addObserver(self, selector: #selector(currentUnitChanged), name: .kCurrentUnitChanged, object: nil)
        loadUnitData()
    }
    
    func loadUnitData() {
        HomeRepository.shared.allUnits { [weak self] modules in
            guard let `self` = self else { return }
            self.functionModules.removeAll()
            self.functionModules.append(contentsOf: modules)
            self.contentView.updateTitle()
            self.getAdsAndNotices()
        }
    }
    
    override func headerRefresh() {
        loadUnitData()
    }
    
    @objc
    func currentUnitChanged() {
        loadUnitData()
    }
    
    func getAdsAndNotices() {
        HomeRepository.shared.adsAndNotice { [weak self] ads, notice in
            guard let `self` = self else { return }
            self.advertisements.removeAll()
            self.notices.removeAll()
            self.advertisements.append(contentsOf: ads)
            self.notices.append(contentsOf: notice)
            self.contentView.reloadView()
        }
    }
    
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleCellIdentifier, for: indexPath) as? HomeModuleCell else { return UICollectionViewCell() }
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeViewSectionHeaderIdentifier, for: indexPath) as? HomeHeaderView else { return UICollectionReusableView() }
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
                        let vc = ScanQRCodeCallElevatorViewController()
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
//                let vc = VideoChatViewController.init(startCall: "AJPLUS000ec6b6d90c")
//                let vc = VideoChatViewController.init(startCall: "ajplus15295776453")
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
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

