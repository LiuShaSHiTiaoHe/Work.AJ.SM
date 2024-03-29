//
//  VisitorInvitationRecordViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/20.
//

import UIKit
import SVProgressHUD

enum VisitorInvitationType {
    case password
    case qrcode
}

class VisitorInvitationRecordViewController: BaseViewController {

    var record: UnitGuestModel?{
        didSet {
            if let record = record, let typeValue = record.guesttype {
                type = typeValue == "2" ? .qrcode : .password
                if let status = record.status, let valid = record.valid, status == "O", valid == 1 {
                    isValid = true
                }
            }
        }
    }
    
    var isValid: Bool = false
    var type: VisitorInvitationType = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSource()
    }
    
    override func initData() {
        switch type {
        case .password:
            passwordContentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            passwordContentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            passwordContentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
            passwordContentView.isValid = isValid
            break
        case .qrcode:
            qrCodeContentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            qrCodeContentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            qrCodeContentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
            qrCodeContentView.isValid = isValid
            break
        }
    }
    
    private func setUpDataSource(){
        if let record = record, let password = record.password {
            switch type {
            case .password:
                passwordContentView.passwordLabel.text = password
                passwordContentView.locationLabel.text = HomeRepository.shared.getCurrentHouseName()
                
                passwordContentView.arriveTime.text = record.startdate
                passwordContentView.validTime.text = record.enddate
                if let passtype = record.passtype, passtype == "T" {
                    passwordContentView.visitTimes.text = "无限次"
                }else{
                    passwordContentView.visitTimes.text = "单次"
                }
            case .qrcode:
                if let qrcodeImage = QRCode.init(string: password, color: .black, backgroundColor: .white, size: CGSize.init(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                    DispatchQueue.main.async {
                        self.qrCodeContentView.qrCodeView.image = image
                    }
                }
                qrCodeContentView.locationLabel.text = HomeRepository.shared.getCurrentHouseName()
                qrCodeContentView.arriveTime.text = record.startdate
                qrCodeContentView.validTime.text = record.enddate
                break
            }

        }
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
        switch type {
        case .password:
            if let image = passwordContentView.bgContentView.jk.toImage() {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        case .qrcode:
            if let image = qrCodeContentView.bgContentView.jk.toImage() {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc
    func shareImage() {
        switch type {
        case .password:
            if let image = passwordContentView.bgContentView.jk.toImage() {
               shareInvitationImage(image)
            }
        case .qrcode:
            if let image = qrCodeContentView.bgContentView.jk.toImage() {
                shareInvitationImage(image)
            }
        }
    }
    
    private func shareInvitationImage(_ image: UIImage){
        let acyivityVC = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
        acyivityVC.excludedActivityTypes = [.airDrop, .message, .saveToCameraRoll, .copyToPasteboard]
        present(acyivityVC, animated: true, completion: nil)
        acyivityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                SVProgressHUD.showSuccess(withStatus: "分享成功")
            }else{
                SVProgressHUD.showError(withStatus: "分享取消")
            }
        }
    }
    
    
    // MARK: - UI
    override func initUI() {
        switch type {
        case .password:
            view.addSubview(passwordContentView)
            passwordContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .qrcode:
            view.addSubview(qrCodeContentView)
            qrCodeContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    lazy var qrCodeContentView: QRCodeInvitationView = {
        let view = QRCodeInvitationView()
        return view
    }()
    
    lazy var passwordContentView: PasswordInvitationView = {
        let view = PasswordInvitationView()
        return view
    }()

}
