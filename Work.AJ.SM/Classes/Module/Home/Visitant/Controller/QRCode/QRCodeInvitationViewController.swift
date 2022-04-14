//
//  InvitationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit
import SVProgressHUD

class QRCodeInvitationViewController: BaseViewController {

    var arriveTime: Date?
    var validTime: Date?
    
    lazy var contentView: QRCodeInvitationView = {
        let view = QRCodeInvitationView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func initData()  {
        contentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        contentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        generateQRCode()
    }
    
    @objc
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil{
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }else{
            SVProgressHUD.showError(withStatus: "保存失败")
        }
    }
    
    
    @objc
    func saveImage() {
        if let image = contentView.bgContentView.jk.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc
    func shareImage() {
        if let image = contentView.bgContentView.jk.toImage() {
            let acyivityVC = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
            acyivityVC.excludedActivityTypes = [.airDrop, .message, .saveToCameraRoll, .copyToPasteboard]
            self.present(acyivityVC, animated: true, completion: nil)
            acyivityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                if completed {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }else{
                    SVProgressHUD.showError(withStatus: "分享取消")
                }
            }
        }
    }
    
    func generateQRCode() {
        if let unit = HomeRepository.shared.getCurrentUnit(), let unitID = unit.unitid?.jk.intToString, let communityname = unit.communityname, let cellname = unit.cellname, let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let userID = ud.userID {
            contentView.locationLabel.text = communityname + cellname
            if let arriveTime = arriveTime, let validTime = validTime {
                contentView.arriveTime.text = arriveTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")
                contentView.validTime.text = validTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")

                let arriveTimeString = arriveTime.jk.toformatterTimeString()
                let validTimeString = validTime.jk.toformatterTimeString()

                HomeAPI.getInvitationQRCode(unitID: unitID, arriveTime: arriveTimeString, validTime: validTimeString, communityID: communityID, blockID: blockID, userID: userID).defaultRequest { JsonData in
                    if let data = JsonData["data"].dictionary, let qrcode = data["qrcode"]?.string {
                        if let qrcodeImage = QRCode.init(string: qrcode, color: .black, backgroundColor: .white, size: CGSize.init(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                            DispatchQueue.main.async {
                                self.contentView.qrCodeView.image = image
                            }
                        }
                    }
                } failureCallback: { response in
                    logger.info("\(response.message)")
                }
                
            }
        }
    }

}
