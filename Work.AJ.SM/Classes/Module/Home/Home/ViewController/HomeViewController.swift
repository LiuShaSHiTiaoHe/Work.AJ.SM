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
        HomeRepository.shared.allUnits { [weak self] modules in
            guard let `self` = self else { return }
            if modules.isEmpty {
                self.showNoDataView(.nohouse)
            }else{
                self.hideNoDataView()
                self.contentView.updateHomeFunctions(modules)
                self.getAdsAndNotices()
            }
        }
    }
    
    func getAdsAndNotices() {
        HomeRepository.shared.adsAndNotice { [weak self] ads, notices in
            guard let `self` = self else { return }
            self.contentView.updateAdsAndNotices(ads, notices)
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
//            pushTo(viewController: MobileCallElevatorViewController())
            agoraCallTest()
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

extension HomeViewController: CallingViewControllerDelegate, BaseVideoChatVCDelegate {
    
    func agoraCallTest() {
        let vc = CallingViewController()
        vc.modalPresentationStyle = .fullScreen
        if let mobile = ud.userMobile {
            if mobile == "15295776453" {
                vc.remoteNumber = "17834736453"
                vc.localNumber = mobile
                vc.delegate = self
                self.present(vc, animated: true)

            }else if mobile == "17834736453"{
                vc.remoteNumber = "15295776453"
                vc.localNumber = mobile
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
    
    func callingVC(_ vc: CallingViewController, didHungup reason: HungupReason) {
        vc.dismiss(animated: reason.rawValue == 1 ? false : true) { [weak self] in
            guard let self = self else { return }
            switch reason {
            case .error:
                SVProgressHUD.showError(withStatus: "\(reason.description)")
            case .remoteReject(let remote):
                SVProgressHUD.showError(withStatus: "\(reason.description)" + ": \(remote)")
            case .normaly(let remote):
                guard let inviter = AgoraRtm.shared().inviter else {
                    fatalError("rtm inviter nil")
                }
                let errorHandle: ErrorCompletion = { (error: AGEError) in
                    SVProgressHUD.showError(withStatus: "\(error.localizedDescription)")
                }
                switch inviter.status {
                case .outgoing:
                    inviter.cancelLastOutgoingInvitation(fail: errorHandle)
                default:
                    break
                }
            case .toVideoChat(let channel , let remote):
                let vc = BaseVideoChatViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                vc.channel = channel
                vc.remoteUid = remote
                vc.localUid = UInt(AgoraRtm.shared().account!)!
                self.present(vc, animated: true)
                break
            }
        }
    }
    
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt) {
        vc.dismiss(animated: true) {
            SVProgressHUD.showInfo(withStatus: "挂断-\(uid)")
        }
    }
}
