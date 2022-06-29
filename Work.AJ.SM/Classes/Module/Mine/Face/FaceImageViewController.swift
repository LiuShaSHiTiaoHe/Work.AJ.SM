//
//  FaceImageViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/28.
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
        dismiss(animated: true, completion: nil)
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
            }
            fixImage = fixImage.jk.fixOrientation()
            if let compressedImageData = fixImage.jk.compress(), let compressedImage = UIImage.init(data: compressedImageData) {
                delegate?.faceImageCompleted(compressedImage, self)
            } else {
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
        switch photo.facesInImage {
        case 0:
            SVProgressHUD.showInfo(withStatus: "未检测到人脸信息")
        case 1:
            confirmFaceImage(photo)
        default:
            SVProgressHUD.showInfo(withStatus: "检测到多个人脸信息")
        }
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
        config.colors.tintColor = R.color.blackcolor()!
        
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true)
            } else {
                if let image = items.singlePhoto?.image {
                    picker.dismiss(animated: true) {
                        self.confirmFaceImage(image)
                    }
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
}
