//
//  FaceTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
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
            if let faceData = faceData, let url = faceData.imageurl, let name = faceData.name, let type = faceData.faceType {
                nameLabel.text = name
                faceImage.kf.setImage(with: URL.init(string: url), placeholder: R.image.defaultavatar(), options: nil, completionHandler: nil)
                if type.isEmpty {
                    roleLabel.isHidden = true
                }else{
                    roleLabel.isHidden = false
                    roleLabel.backgroundColor = R.color.familyB_yellowColor()
                    roleLabel.textColor = R.color.family_yellowColor()
                    switch type {//“0”：本人；“1”：父母；“2”：子女；“3”：亲属
                    case "0":
                        roleLabel.text = "本人"
                        roleLabel.backgroundColor = R.color.ownerB_greenColor()
                        roleLabel.textColor = R.color.owner_greenColor()
                    case "1":
                        roleLabel.text = "父母"
                    case "2":
                        roleLabel.text = "子女"
                    case "3":
                        roleLabel.text = "亲属"
                    default:
                        roleLabel.isHidden = true
                        break
                    }
                }
            }
        }
    }
    
    func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
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
            make.bottom.equalTo(bgView.snp.centerY).offset(-kMargin/2)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.left.equalTo(faceImage.snp.right).offset(kMargin)
            make.height.equalTo(30)
//            make.top.equalTo(bgView.snp.centerY)
            make.bottom.equalTo(faceImage.snp.bottom)
            make.width.equalTo(80)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
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
        view.backgroundColor = R.color.whiteColor()
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
        view.textColor = R.color.maintextColor()
        view.font = k16Font
        return view
    }()
    
    lazy var roleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.owner_greenColor()
        view.font = k14Font
        view.layer.cornerRadius = 6.0
        view.textAlignment = .center
        view.clipsToBounds = true
        view.backgroundColor = R.color.ownerB_greenColor()
        view.text = ""
//        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("删除", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.titleLabel?.font = k15Font
        button.layer.cornerRadius = 15.0
        button.backgroundColor = R.color.errorRedColor()
        return button
    }()
    
    @objc
    func deleteAction() {
        if let faceData = faceData, let image = faceData.image, let faceID = faceData.faceID?.jk.intToString {
            delegate?.deleteFace(path: image, faceID: faceID)
        }
    }

}
