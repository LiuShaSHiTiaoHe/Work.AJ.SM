//
//  OwnerQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class OwnerQRCodeViewController: BaseViewController {

    lazy var ownerQRCodeView: OwnerQRCodeView = {
        let view = OwnerQRCodeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        view.backgroundColor = R.color.bg()
        
        view.addSubview(ownerQRCodeView)
        ownerQRCodeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData() {
        ownerQRCodeView.delegate = self
        updateImageData()
    }
    
    func updateImageData() {
        if let unit = HomeRepository.shared.getCurrentUnit(), let unitID = unit.unitid?.jk.intToString, let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let userID = ud.userID {            
            HomeAPI.getUserOfflineQRCode(unitID: unitID, communityID: communityID, blockID: blockID, userID: userID).defaultRequest { JsonData in
                if let data = JsonData["data"].dictionary, let qrcode = data["qrcode"]?.string {
                    if let qrcodeImage = QRCode.init(string: qrcode, color: .black, backgroundColor: .white, size: CGSize.init(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                        DispatchQueue.main.async {
                            self.ownerQRCodeView.qrcodeView.image = image
                        }
                    }
                }
            } failureCallback: { response in
                logger.info("\(response.message)")
            }
        }
    }
     
}

extension OwnerQRCodeViewController: OwnerQRCodeViewDelegate {
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    func refresh() {
        updateImageData()
    }
}
