//
//  UserIdentifyQRCodeViewController.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import UIKit

class UserIdentifyQRCodeViewController: BaseViewController {
    lazy var ownerQRCodeView: UserIdentifyQRCodeView = {
        let view = UserIdentifyQRCodeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImageData()
    }
    
    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(ownerQRCodeView)
        ownerQRCodeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func initData() {
        ownerQRCodeView.delegate = self
    }

    func updateImageData() {
        DispatchQueue.global().async {
            if let image = QRCodeManager.shared.generateUserIdentifyQRCode() {
                DispatchQueue.main.async {
                    self.ownerQRCodeView.qrcodeView.image = image
                }
            }
        }
    }
}

extension UserIdentifyQRCodeViewController: UserIdentifyQRCodeViewDelegate {
    func close() {
        navigationController?.popViewController(animated: true)
    }

    func refresh() {
        updateImageData()
    }
}
