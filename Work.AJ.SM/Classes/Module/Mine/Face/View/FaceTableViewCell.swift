//
//  FaceTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/28.
//

import UIKit

protocol FaceTableViewCellDelegate: NSObjectProtocol {
    func deleteFace(path: String, faceID: String)
}

let FaceTableViewCellIdentifier = "FaceTableViewCellIdentifier"

class FaceTableViewCell: UITableViewCell {

    weak var delegate: FaceTableViewCellDelegate?
    
    var faceData: FaceModel? {
        didSet {
            if let faceData = faceData, let url = faceData.imageurl {
                if let name = faceData.name {
                    nameLabel.text = name
                }
                faceImage.kf.setImage(with: URL.init(string: url), placeholder: R.image.defaultavatar(), options: nil, completionHandler: nil)
                if let faceType = faceData.faceType {
                    if faceType.isEmpty {
                        roleLabel.isHidden = true
                    }else{
                        roleLabel.isHidden = false
                        roleLabel.textColor = R.color.text_info()
                        switch faceType {//“0”：本人；“1”：父母；“2”：子女；“3”：亲属
                        case "0":
                            roleLabel.text = "本人"
                        case "1":
                            roleLabel.text = "父母"
                        case "2":
                            roleLabel.text = "子女"
                        default:
                            roleLabel.isHidden = true
                        }
                    }
                } else {
                    roleLabel.isHidden = true
                }

            }
        }
    }
    
    func initializeView() {
        contentView.backgroundColor = R.color.bg()
        contentView.addSubview(bgView)
        bgView.addSubview(faceImage)
        bgView.addSubview(nameLabel)
        bgView.addSubview(roleLabel)
        bgView.addSubview(deleteButton)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        faceImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(faceImage.snp.right).offset(kMargin)
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(30)
            make.bottom.equalTo(bgView.snp.centerY)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.left.equalTo(faceImage.snp.right).offset(kMargin)
            make.height.equalTo(30)
            make.bottom.equalTo(faceImage.snp.bottom)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
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
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var faceImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_title()
        view.font = k16Font
        return view
    }()
    
    lazy var roleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_info()
        view.font = k14Font
        view.textAlignment = .left
        view.text = ""
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var deleteButton: ExpandButton = {
        let button = ExpandButton.init(type: .custom)
        button.setBackgroundImage(R.image.base_icon_trash(), for: .normal)
        return button
    }()
    
    @objc
    func deleteAction() {
        if let faceData = faceData, let image = faceData.image, let faceID = faceData.faceID?.jk.intToString {
            delegate?.deleteFace(path: image, faceID: faceID)
        }
    }

}
