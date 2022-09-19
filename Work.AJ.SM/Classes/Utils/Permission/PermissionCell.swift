//
//  PermissionCell.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/9/19.
//

import UIKit
import PermissionsKit
import SnapKit

let PermissionCellIdentifier = "PermissionCellIdentifier"

class PermissionCell: UITableViewCell {
    
    private let buttonWidth: CGFloat = 50.0
    
    var permission: Permission? {
        didSet {
            if let permission = permission {
                self.nameLabel.text = permission.localisedName
                switch permission.kind {
                case .camera:
                    self.descriptionLabel.text = "使用相机进行视频通话、头像上传、物业报修图片上传、二维码扫描等功能"
                    self.icon.image = R.image.permission_camera_icon()!
                case .bluetooth:
                    self.descriptionLabel.text = "使用蓝牙权限进行远程呼梯，远程开门等功能"
                    self.icon.image = R.image.permission_bluetooth_icon()!
                case .photoLibrary:
                    self.descriptionLabel.text = "使用相册进行本地二维码扫描、头像上传、物业报修图片上传等功能"
                    self.icon.image = R.image.permission_photo_icon()!
                case .microphone:
                    self.descriptionLabel.text = "使用麦克风进行音频通话"
                    self.icon.image = R.image.permission_microphone_icon()!
                default:
                    break
                }
                switch permission.status {
                case .notDetermined:
                    self.statusButton.setTitle("允许", for: .normal)
                case .denied:
                    self.statusButton.setTitle("已拒绝", for: .normal)
                case .authorized:
                    self.statusButton.setTitle("已允许", for: .normal)
                case .notSupported:
                    self.statusButton.setTitle("暂不支持", for: .normal)
                    self.statusButton.isEnabled = false
                }
            }
            
        }
    }
    
    @objc
    func permissionStatusButtonAction(){
        if let permission = permission {
            permission.request {
                if permission.authorized {
                    self.statusButton.setTitle("已允许", for: .normal)
                } else if permission.denied {
                    self.statusButton.setTitle("已拒绝", for: .normal)
                } else if permission.notDetermined {
                    self.statusButton.setTitle("允许", for: .normal)
                }
            }
        }
    }
    
    private func initData() {
        statusButton.addTarget(self, action: #selector(permissionStatusButtonAction), for: .touchUpInside)
    }
    
    
    private func initializeView() {
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(statusButton)
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.left.equalTo(icon.snp.right).offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin - buttonWidth - kMargin/2)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.bottom.equalToSuperview().offset(-kMargin/2)
            make.left.equalTo(icon.snp.right).offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin - buttonWidth - kMargin/2)
        }
        
        statusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(40)
            make.width.equalTo(buttonWidth)
        }
    }
    
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k16Font
        view.textColor = R.color.text_title()
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = k12Font
        view.textColor = R.color.text_content()
        view.numberOfLines = 2
        return view
    }()
    
    lazy var statusButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = k14Font
        button.setTitleColor(R.color.text_title(), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

