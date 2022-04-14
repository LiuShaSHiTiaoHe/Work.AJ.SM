//
//  MemberInvitationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import SVProgressHUD
import Kingfisher

class MemberInvitationViewController: BaseViewController {

    var phone: String?
    var qrCodeString: String?
    
    lazy var contentView: MemberInvitationView = {
        let view = MemberInvitationView()
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
    
    override func initData() {
        contentView.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        contentView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        if let qrCodeString = qrCodeString, let qrcodeImage = QRCode.init(string: qrCodeString, color: .black, backgroundColor: .white, size: CGSize.init(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
            DispatchQueue.main.async {
                self.contentView.qrCodeView.image = image
            }
        }
        if let phone = phone,let unit = HomeRepository.shared.getCurrentUnit(), let communityname = unit.communityname, let cellname = unit.cellname {
            let phoneLast4 = phone.jk.sub(from: phone.count - 4)
            contentView.tips2Label.text = "2. 下载“智慧社区”APP，使用手机尾号\(phoneLast4)登录即可加入房屋。"
            contentView.locationLabel.text = communityname + cellname
            
        }
        if let userModel = HomeRepository.shared.getCurrentUser(), let name = userModel.realName {
            contentView.nameLabel.text = name
            if let avatarDic = CacheManager.normal.fetchCachedWithKey(UserAvatarCacheKey), let avatarData = avatarDic.value(forKey: UserAvatarCacheKey) as? Data, let image = UIImage.init(data: avatarData) {
                self.contentView.avatar.image = image
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

}
