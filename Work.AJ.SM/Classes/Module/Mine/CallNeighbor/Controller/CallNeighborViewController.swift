//
//  CallNeighborViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
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
        MineRepository.shared.validationNumber {[weak self] mobiles, mac in
            guard let self = self else { return }
            if mobiles.isEmpty {
                SVProgressHUD.showInfo(withStatus: "拨打用户号码不存在")
            }else{
                self.startCall(mobiles[0], mac, name)
            }
        }
    }
    
    func startCall(_ number: String, _ lockMac: String, _ name: String) {
        let vc = VideoChatViewController.init(startCall: number, isLock: false)
        vc.lockMac = lockMac
        vc.name = name
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
        }else{
            if address.count != 8 {
                SVProgressHUD.showInfo(withStatus: "请按照规则输入号码")
            }else if address.jk.isValidNumber(){
                let blockNo = String(address.prefix(2))
                let cellNo = String(address.prefix(4).suffix(2))
                let unitNo = String(address.suffix(4))
                callNumberValidation(blockNo, cellNo, unitNo)
            }else{
                SVProgressHUD.showInfo(withStatus: "请按照规则输入号码")
            }
        }
    }
}
