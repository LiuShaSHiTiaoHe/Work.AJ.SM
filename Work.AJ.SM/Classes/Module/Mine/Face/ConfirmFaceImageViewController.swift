//
//  ConfirmFaceImageViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/1.
//

import UIKit
import SVProgressHUD

class ConfirmFaceImageViewController: BaseViewController {
        
    private var userType: String = ""//身份类别 F家属 O业主 R租客

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        if let faceImageCache = CacheManager.fetchCachedWithKey(FaceImageCacheKey), let imageData = faceImageCache[FaceImageCacheKey] as? Data, let faceImage = UIImage.init(data: imageData) {
            faceImageView.image = faceImage
        }
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    // FIXME: - 身份证号还是手机号码？？
    @objc
    func confirm() {
        let name = getMemberName()
        if name.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入姓名")
            return
        }
        
        let identitfireNumber = getMemberIdentifierNumber()
        if identitfireNumber.isEmpty{
            SVProgressHUD.showInfo(withStatus: "请输入身份证号")
            return
        }
        if !identitfireNumber.jk.isValidIDCardNumStrict {
            SVProgressHUD.showInfo(withStatus: "请输入正确的身份证号")
            return
        }
        
        if userType.isEmpty{
            SVProgressHUD.showInfo(withStatus: "请选择类型")
            return
        }
        
        if let imageData = CacheManager.fetchCachedWithKey(FaceImageCacheKey)?.object(forKey: FaceImageCacheKey) as? Data, let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let mobile = unit.mobile{
            let model = AddFaceModel.init(faceData: imageData, phone: mobile, name: name, userType: userType, communityID: communityID, blockID: blockID, unitID: unitID, cellID: cellID)
            MineRepository.shared.addFace(model) { errorMsg in
                if errorMsg.isEmpty {
                    SVProgressHUD.showSuccess(withStatus: "添加成功")
                    SVProgressHUD.dismiss(withDelay: 2) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }else{
                    SVProgressHUD.showError(withStatus: errorMsg)
                }
            }
        }
        
    }
    
    func getMemberName() -> String {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CommonInputCell
        if let name = cell.commonInput.text {
            return name
        }else{
            return ""
        }
    }
    
    func getMemberIdentifierNumber() -> String {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ComminIDNumberInpuCell
        if let PhoneNumber = cell.IDNumberInput.text {
            return PhoneNumber
        }else{
            return ""
        }
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(faceImageView)
        view.addSubview(tipsLabel)
        view.addSubview(tableView)
        view.addSubview(confirmButton)

        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }

        faceImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(kMargin)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(200)
        }

        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(faceImageView.snp.bottom).offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }

        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(kMargin/2)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
    }
        
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.textColor = R.color.maintextColor()
        view.titleLabel.text = "提交人脸认证"
        return view
    }()
    
    lazy var faceImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k16BoldFont
        view.text = "请填写身份信息"
        view.textAlignment = .center
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCellIdentifier)
        view.register(CommonSelectButtonCell.self, forCellReuseIdentifier: CommonSelectButtonCellIdentifier)
        view.register(ComminIDNumberInpuCell.self, forCellReuseIdentifier: ComminIDNumberInpuCellIdentifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.layer.cornerRadius = 20.0
        button.backgroundColor = R.color.themeColor()
        return button
    }()
    
}


extension ConfirmFaceImageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            cell.accessoryType = .none
            cell.nameLabel.text = "姓名"
            cell.placeholder = "请输入家人/成员姓名"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComminIDNumberInpuCellIdentifier, for: indexPath) as! ComminIDNumberInpuCell
            cell.accessoryType = .none
            cell.nameLabel.text = "身份证"
            cell.placeholder = "请输入家人/成员身份证号"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonSelectButtonCellIdentifier, for: indexPath) as! CommonSelectButtonCell
            cell.accessoryType = .none
            cell.nameLabel.text = "身份"
            cell.leftButtonName = "本人"
            cell.centerButtonName = "父母"
            cell.rightButtonName = "子女"
            cell.delegate = self
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ConfirmFaceImageViewController: CommonSelectButtonCellDelegate {
    
    func letfButtonSelected(_ isSelected: Bool) {
        userType = "O"
    }
    
    func centerButtonSelected(_ isSelected: Bool) {
        userType = "F"
    }
    
    func rightButtonSelected(_ isSelected: Bool) {
        userType = "R"
    }
}
