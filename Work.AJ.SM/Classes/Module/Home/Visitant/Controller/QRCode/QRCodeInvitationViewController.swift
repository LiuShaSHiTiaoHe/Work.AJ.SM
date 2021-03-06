//
//  InvitationViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/22.
//

import UIKit
import SVProgressHUD

class QRCodeInvitationViewController: BaseViewController {

    var arriveTime: Date?
    var validTime: Date?
    var qrCodeString: String?
    
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
            let activityVC = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .message, .saveToCameraRoll, .copyToPasteboard]
            present(activityVC, animated: true, completion: nil)
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                if completed {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }else{
                    SVProgressHUD.showError(withStatus: "分享取消")
                }
            }
        }
    }
    
    func generateQRCode() {
        contentView.locationLabel.text = HomeRepository.shared.getCurrentHouseName()
        if let arriveTime = arriveTime, let validTime = validTime, let qrCodeString = qrCodeString {
            contentView.arriveTime.text = arriveTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")
            contentView.validTime.text = validTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")

            if let qrcodeImage = QRCode.init(string: qrCodeString, color: .black, backgroundColor: .white, size: CGSize.init(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                DispatchQueue.main.async {
                    self.contentView.qrCodeView.image = image
                }
            }
        }
    }

}
