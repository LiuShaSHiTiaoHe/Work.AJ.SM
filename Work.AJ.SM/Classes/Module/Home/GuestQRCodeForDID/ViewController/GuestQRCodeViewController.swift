//
//  GuestQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import SVProgressHUD
import UIKit

class GuestQRCodeViewController: BaseViewController {
    var arriveTime: Date?
    var validTime: Date?
    var qrCodeImage: UIImage?
    var floor: String?

    lazy var contentView: GuestQRCodeView = {
        let view = GuestQRCodeView()
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
        contentView.qrCodeView.image = qrCodeImage
        if let floor = floor, !floor.isEmpty {
            contentView.locationLabel.text = "楼层：\(floor)"
        }
        
        if let arriveTimeString = arriveTime?.jk.toformatterTimeString() {
            contentView.arriveTime.text = arriveTimeString
        }
        if let validTimeString = validTime?.jk.toformatterTimeString() {
            contentView.validTime.text = validTimeString
        }
    }

    @objc
    func image(image _: UIImage, didFinishSavingWithError error: NSError?, contextInfo _: UnsafeRawPointer) {
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        } else {
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
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .message, .saveToCameraRoll, .copyToPasteboard]
            present(activityVC, animated: true, completion: nil)
            activityVC.completionWithItemsHandler = { _, completed, _, _ in
                if completed {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                } else {
                    SVProgressHUD.showError(withStatus: "分享取消")
                }
            }
        }
    }
}
