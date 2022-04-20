//
//  VisitorInvitationRecordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/20.
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
                if typeValue == "1"{
                    type = .qrcode
                    
                }else{
                    type = .password
                }
                
                if let status = record.status, let valid = record.valid {
                    if status == "O"{
                        if valid == 1 {
                            isValid = true
                        }
                    }
                }
            }
        }
    }
    
    var isValid: Bool = false
    var type: VisitorInvitationType = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        switch type {
        case .password:
            passwordContentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            passwordContentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            passwordContentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
            passwordContentView.isvalid = isValid
            break
        case .qrcode:
            qrCodeContentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            qrCodeContentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            qrCodeContentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
            qrCodeContentView.isvalid = isValid
            break
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
        self.present(acyivityVC, animated: true, completion: nil)
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
