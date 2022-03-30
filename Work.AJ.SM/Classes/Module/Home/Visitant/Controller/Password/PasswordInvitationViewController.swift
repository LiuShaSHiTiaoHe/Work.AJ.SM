//
//  PasswordInvitationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/22.
//

import UIKit
import SVProgressHUD

class PasswordInvitationViewController: BaseViewController {

    var arriveTime: Date?
    var validTime: Date?
    var visitTimes: VisitTimes?
    var phoneNumber: String?
    
    lazy var contentView: PasswordInvitationView = {
        let view = PasswordInvitationView()
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
        setUpDataSource()
    }
    
    private func setUpDataSource(){
        if let unit = HomeRepository.shared.getCurrentUnit(), let visitTimes = visitTimes, let validTime = validTime, let arriveTime = arriveTime, let communityname = unit.communityname, let cellname = unit.cellname {
            contentView.locationLabel.text = communityname + cellname
            contentView.arriveTime.text = arriveTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")
            contentView.validTime.text = validTime.jk.toformatterTimeString(formatter: "yyyy年MM月dd日 HH:mm")
            if visitTimes == .single {
                contentView.visitTimes.text = "单次"
            }else{
                contentView.visitTimes.text = "无限次"
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
