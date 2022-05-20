//
//  FaceImageViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import UIKit
import SVProgressHUD
import YPImagePicker

protocol FaceImageViewControllerDelegate: NSObjectProtocol {
    func faceImageCompleted(_ image: UIImage, _ faceImageVC: FaceImageViewController)
}

class FaceImageViewController: SwiftyCamViewController, UINavigationControllerDelegate {
    
    weak var delegate: FaceImageViewControllerDelegate?
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.face_icon_cancel(), for: .normal)
        return button
    }()

    lazy var swicthButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.face_icon_switchCamera(), for: .normal)
        return button
    }()

    lazy var cameraButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.mine_camera(), for: .normal)
        return button
    }()

    lazy var galleryButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.face_icon_openLibrary(), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        cameraDelegate = self
        videoGravity = .resizeAspectFill
        doubleTapCameraSwitch = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        swicthButton.addTarget(self, action: #selector(switchCameraAction), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(takePhotoAction), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryAction), for: .touchUpInside)
        swicthButton.isEnabled = false
        cameraButton.isEnabled = false
    }

    // MARK: - UI
    private func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(cancelButton)
        view.addSubview(swicthButton)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(swicthButton)
        view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(galleryButton)

        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(kStateHeight + kMargin)
        }

        swicthButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin * 2)
            make.width.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin * 1.5)
        }
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin * 1.5)
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
        }
        galleryButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin * 2)
            make.width.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin * 1.5)
        }
    }

    @objc
    func cancelAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func switchCameraAction() {
        switchCamera()
    }

    @objc
    func takePhotoAction() {
        takePhoto()
    }

    @objc
    func galleryAction() {
        showImagePicker()
    }

    func confirmFaceImage(_ image: UIImage) {
        var fixImage = image
        if let cgImage = fixImage.cgImage {
            if fixImage.imageOrientation == .leftMirrored {
                fixImage = UIImage(cgImage: cgImage, scale: fixImage.scale, orientation: .right)
                fixImage = fixImage.jk.fixOrientation()
                delegate?.faceImageCompleted(fixImage, self)
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "图片数据错误")
        }
    }

}

extension FaceImageViewController: SwiftyCamViewControllerDelegate {

    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        swicthButton.isEnabled = true
        cameraButton.isEnabled = true
    }

    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        swicthButton.isEnabled = false
        cameraButton.isEnabled = false
    }


    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        switch detect(photo) {
        case 0:
            SVProgressHUD.showInfo(withStatus: "未检测到人脸信息")
        case 1:
            confirmFaceImage(photo)
        default:
            SVProgressHUD.showInfo(withStatus: "检测到多个人脸信息")
        }
    }

}


extension FaceImageViewController {
    func detect(_ faceImage: UIImage) -> Int {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        if let faceCIImage = CIImage.init(image: faceImage), let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy), let imageOptions = NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString) as? [String: Any] {
            let features = faceDetector.features(in: faceCIImage, options: imageOptions)
            let faceFeature = features.compactMap { feature in
                return feature as? CIFaceFeature
            }
            return faceFeature.count
        }
        return 0
    }
}


extension FaceImageViewController: YPImagePickerDelegate {
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
    }

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }

    func showImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.showsPhotoFilters = false
        config.wordings.next = "完成"
        //colors
        config.colors.tintColor = R.color.blackColor()!
        
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.didFinishPicking { [weak self] items, cancelled in
            guard let self = self else {
                return
            }
            if cancelled {
                picker.dismiss(animated: true)
            }else{
                SVProgressHUD.show()
                if let image = items.singlePhoto?.image {
                    switch self.detect(image) {
                    case 0:
                        SVProgressHUD.showInfo(withStatus: "未检测到人脸信息")
                    case 1:
                        SVProgressHUD.dismiss()
                        picker.dismiss(animated: true) {
                            self.confirmFaceImage(image)
                        }
                    default:
                        SVProgressHUD.showInfo(withStatus: "检测到多个人脸信息")
                    }
                }
            }

        }
        present(picker, animated: true, completion: nil)
    }
}
