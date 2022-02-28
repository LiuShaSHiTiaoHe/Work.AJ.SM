//
//  FaceImageViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import UIKit
import SwiftyCam
import SVProgressHUD

class FaceImageViewController: SwiftyCamViewController, UINavigationControllerDelegate {

    lazy var swicthButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.icon_cameraSwitch(), for: .normal)
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.mine_camera(), for: .normal)
        return button
    }()
    
    lazy var galleryButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.mine_icon_order(), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        cameraDelegate = self
        videoGravity = .resizeAspectFill
        swicthButton.addTarget(self, action: #selector(switchCameraAction), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(takePhotoAction), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryAction), for: .touchUpInside)
        swicthButton.isEnabled = false
        cameraButton.isEnabled = false
    }
    
    private func initUI() {
        view.addSubview(swicthButton)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.bringSubviewToFront(swicthButton)
        view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(galleryButton)
        swicthButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin*2)
            make.width.height.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        galleryButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin*2)
            make.width.height.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
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
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self 
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary), let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            imagePicker.mediaTypes = mediaTypes
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
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
        if detect(photo){
            
        }else{
            SVProgressHUD.showInfo(withStatus: "未检测到人脸信息")
        }
    }
    
}

extension FaceImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let type = info[.mediaType] as? String, type == UIImagePickerController.availableMediaTypes(for: .photoLibrary)?.first {
            if let image = info[.originalImage] as? UIImage {
                if detect(image) {
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "未检测到人脸信息")
                }
            }
        }
    }
}


extension FaceImageViewController {
    func detect(_ faceImage: UIImage) -> Bool {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        if let faceCIImage = CIImage.init(image: faceImage), let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy), let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString) as? [String : Any] {
            let faces = faceDetector.features(in: faceCIImage, options: imageOptions)
            if let _ = faces.first as? CIFaceFeature {
                return true
            }
        }
        return false
    }
}
