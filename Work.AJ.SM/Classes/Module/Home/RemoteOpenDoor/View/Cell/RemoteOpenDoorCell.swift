//
//  RemoteOpenDoorCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit
import SnapKit

protocol RemoteOpenDoorCellDelegate: NSObjectProtocol {
    func openDoor()
    func camera()
}

class RemoteOpenDoorCell: UITableViewCell {

    weak var delegate: RemoteOpenDoorCellDelegate?
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var typeImageView: UIImageView = {
        let view = UIImageView.init()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel.init()
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var typeLabel: UILabel = {
        let view = UILabel.init()
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel.init()
        view.font = k12Font
        return view
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.rod_image_camera(), for: .normal)
        button.addTarget(self, action: #selector(clickOpenDoor), for: .touchUpInside)
        return button
    }()
    
    lazy var openDoorButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.rod_image_opendoor(), for: .normal)
        button.addTarget(self, action: #selector(clickCamera), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        
        contentView.addSubview(bgView)
        
        bgView.addSubview(typeImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(typeLabel)
        bgView.addSubview(statusLabel)
        bgView.addSubview(cameraButton)
        bgView.addSubview(openDoorButton)

        bgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kMargin/2)
            make.right.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        typeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(typeImageView.snp.right).offset(kMargin)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-kMargin*4)
            make.height.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.height.equalTo(20)
            make.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.height.equalTo(20)
            make.right.equalTo(nameLabel)
            make.top.equalTo(typeLabel.snp.bottom)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(33)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-60)
        }
        
        openDoorButton.snp.makeConstraints { make in
            make.width.height.equalTo(33)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @objc
    func clickOpenDoor() {
        delegate?.openDoor()
    }
    
    @objc
    func clickCamera() {
        delegate?.camera()
    }
    
    func setUpData(model: UnitLockModel) {
        nameLabel.text = model.lockname
        typeLabel.text = ""
        statusLabel.text = "不在线"
        typeImageView.image = R.image.rod_image_unit()
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
