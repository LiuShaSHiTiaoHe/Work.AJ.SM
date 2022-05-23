//
//  FaceListViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import UIKit
import SVProgressHUD

class FaceListViewController: BaseViewController {

    private var dataSource: [FaceModel] = []
    private var faceImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func initData() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "人脸认证"
    }

    private func reloadData() {
        if !needReloadData {
            return
        }
        MineRepository.shared.getFaceList { [weak self] faces in
            guard let `self` = self else {
                return
            }
            if faces.isEmpty {
                self.dataSource.removeAll()
                SVProgressHUD.showInfo(withStatus: "暂无数据")
            } else {
                self.dataSource = faces
            }
            self.tableView.reloadData()
        }
    }

    @objc
    func addFaceImage() {
        PermissionManager.permissionRequest(.camera) { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.isSyncFaceImage()
            } else {
                PermissionManager.shared.go2Setting(.camera)
            }
        }
    }

    private func isSyncFaceImage() {
        let unitIDs = ud.unitIDsOfShownSyncFaceImageNotification
        if let unit = HomeRepository.shared.getCurrentUnit(),  let unitID = unit.unitid?.jk.intToString {
            if !unitIDs.isEmpty, unitIDs.contains(unitID) {
                self.showFaceImageVC()
            } else {
                self.getExtrasFaceFile()
            }
        } else {
            SVProgressHUD.showError(withStatus: "数据错误")
            SVProgressHUD.dismiss(withDelay: 2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showFaceImageVC() {
        let vc = FaceImageViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func go2ConfirmFaceImageVC(_ faceImage: UIImage) {
        let vc = ConfirmFaceImageViewController()
        vc.faceImage = faceImage
        pushTo(viewController: vc)
    }

    func getExtrasFaceFile() {
        SVProgressHUD.show()
        MineRepository.shared.getExtraFace { [weak self] models in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            let data = models.filter{ $0.isValid == "1"}
            if data.count > 0 {
                let unitName = HomeRepository.shared.getCurrentHouseName()
                let alert = UIAlertController.init(title: "人脸图片同步提醒", message: "您在其他房屋已上传\(data.count)张人脸图片，是否同步至\(unitName)", preferredStyle: .alert)
                alert.addAction(action: .init(title: "需要", style: .destructive, handler: { action in
                    self.syncExtrasFaceFile()
                })).addAction("不需要", .cancel) {
                    self.pushTo(viewController: FaceImageViewController())
                }
                alert.show()
            }else{
                let vc = FaceImageViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func syncExtrasFaceFile() {
        SVProgressHUD.show()
        MineRepository.shared.syncExtraFace { [weak self] errorMsg in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            if errorMsg.isEmpty {
                SVProgressHUD.showSuccess(withStatus: "同步成功")
                SVProgressHUD.dismiss(withDelay: 2) {
                    self.reloadData()
                }
            }else{
                SVProgressHUD.showError(withStatus: errorMsg)
            }
        }
    }

    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView.init()
        view.titleLabel.textColor = R.color.text_title()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(FaceTableViewCell.self, forCellReuseIdentifier: FaceTableViewCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        return view
    }()

    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加人脸照片", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addFaceImage), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()
}

extension FaceListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FaceTableViewCellIdentifier, for: indexPath) as! FaceTableViewCell
        let data = dataSource[indexPath.row]
        cell.faceData = data
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

}

extension FaceListViewController: FaceTableViewCellDelegate {
    
    func deleteFace(path: String, faceID: String) {
        let alert = UIAlertController.init(title: "提示", message: "确认删除？", preferredStyle: .alert)
        alert.addAction(action: .init(title: "确定", style: .destructive, handler: { action in
            self.confirmDeleteFaceAction(path, faceID)
        })).addAction(.init(title: "取消", style: .cancel, handler: nil))
        alert.show()
    }
    
    func confirmDeleteFaceAction(_ path: String, _ faceID: String) {
        MineRepository.shared.deleteFace(path, faceID) { errorMsg in
            if errorMsg.isEmpty {
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.reloadData()
            } else {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }
        }
    }
}

extension FaceListViewController: FaceImageViewControllerDelegate {

    func faceImageCompleted(_ image: UIImage, _ faceImageVC: FaceImageViewController) {
        self.needReloadData = false
        faceImageVC.dismiss(animated: true) {
            self.needReloadData = true
            self.go2ConfirmFaceImageVC(image)
        }
    }
}
