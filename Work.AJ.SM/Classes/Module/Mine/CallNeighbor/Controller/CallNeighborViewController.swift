//
//  CallNeighborViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/10.
//

import UIKit
import SVProgressHUD

class CallNeighborViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.delegate = self
    }

    func callNumberValidation(_ blockNo: String, _ cellNo: String, _ unitNo: String) {
        let name = blockNo + "栋" + cellNo + "单元" + unitNo + "室"
        self.startCall("4155".ajAgoraAccount(), "", name)
        // FIXME: - 暂时
//        MineRepository.shared.validationNumber(blockNo: blockNo, unitNo: unitNo, cellNo: cellNo) { [weak self] userIDs, mac in
//            guard let self = self else {
//                return
//            }
//            if userIDs.isEmpty {
//                SVProgressHUD.showInfo(withStatus: "你选择的房号暂无联系人")
//            } else {
//                self.startCall(userIDs[0], mac, name)
//            }
//        }
    }

    func startCall(_ number: String, _ lockMac: String, _ name: String) {
        //MARK: - 发送推送
        GDataManager.shared.sendVideoCallNotification(number)
        startAgoraCall(number, lockMac, name)
//        let vc = VideoChatViewController.init(startCall: number)
//        vc.name = name
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
    }

    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var contentView: CallNeighborView = {
        let view = CallNeighborView()
        return view
    }()

}

extension CallNeighborViewController: CallNeighborViewDelegate {
    func callNeighborWithAddress(_ address: String) {
        if address.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入号码")
        } else {
            if address.count != 8 {
                SVProgressHUD.showInfo(withStatus: "请按照规则输入号码")
            } else if address.jk.isValidNumber() {
                let blockNo = String(address.prefix(2))
                let cellNo = String(address.prefix(4).suffix(2))
                let unitNo = String(address.suffix(4))
                callNumberValidation(blockNo, cellNo, unitNo)
            } else {
                SVProgressHUD.showInfo(withStatus: "请按照规则输入号码")
            }
        }
    }
}
