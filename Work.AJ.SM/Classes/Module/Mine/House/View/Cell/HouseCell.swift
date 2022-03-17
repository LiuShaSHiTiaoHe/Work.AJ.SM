//
//  HouseCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/15.
//

import UIKit
import SnapKit

protocol HouseCellDelegate: NSObjectProtocol {
    func chooseCurrentUnit(unitID: Int)
}

class HouseCell: UITableViewCell {
    //height 80
    weak var delegate: HouseCellDelegate?
    
    var isSelectHouse: Bool? = true {
        didSet {
            if let _ = unit, let flag = isSelectHouse {
                if !flag {
                    selectButton.isHidden = true
                    currentStateLabel.isHidden = false
                }
            }else{
                fatalError("set after unit")
            }
        }
    }
    
    var unit: UnitModel? {
        didSet {
            if let state = unit?.state {
                if state == "P" {
                    currentStateLabel.text = "未审核"
                    currentStateLabel.textColor = R.color.family_yellowColor()
                }else if state == "H" {
                    currentStateLabel.text = "已失效"
                    currentStateLabel.textColor = R.color.errorRedColor()
                }else if state == "E" {
                    currentStateLabel.text = "已过期"
                    currentStateLabel.textColor = R.color.errorRedColor()
                }else{
                    currentStateLabel.text = ""
                    currentStateLabel.isHidden = true
                }
            }
            
            if let defaultUnitID = ud.currentUnitID, let unitID = unit?.unitid {
                if defaultUnitID != unitID {
                    selectButton.isHidden = false
                    currentStateLabel.isHidden = true
                }else{
                    selectButton.isHidden = true
                    currentStateLabel.isHidden = false
                    currentStateLabel.text = "当前房屋"
                    currentStateLabel.textColor = R.color.secondtextColor()
                }
            }
            
            if let userType = unit?.usertype {
                if userType == "O" {
                    ownerType.text = "业主"
                    ownerType.textColor = R.color.owner_greenColor()
                    ownerType.backgroundColor = R.color.ownerB_greenColor()
                }else{
                    ownerType.text = "家属"
                    ownerType.textColor = R.color.family_yellowColor()
                    ownerType.backgroundColor = R.color.familyB_yellowColor()
                }
            }
            
            if let cell = unit?.cellname, let community = unit?.communityname, let unitno = unit?.unitno {
                cellName.text = cell + unitno
                communityName.text = community
            }
            
        }
    }
    
    lazy var backGround: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()

    lazy var ownerType: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = k12Font
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    lazy var cellName: UILabel = {
        let label = UILabel.init()
        label.font = k15Font
        label.textColor = R.color.maintextColor()
        return label
    }()
    
    lazy var communityName: UILabel = {
        let label = UILabel.init()
        label.font = k12Font
        label.textColor = R.color.secondtextColor()
        return label
    }()
    
    lazy var currentStateLabel: UILabel = {
        let label = UILabel.init()
        label.font = k12Font
        label.textColor = R.color.secondtextColor()
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("选择", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.blueColor()
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = k12Font
        button.addTarget(self, action: #selector(chooseUnit), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        contentView.addSubview(backGround)
        
        backGround.addSubview(ownerType)
        backGround.addSubview(cellName)
        backGround.addSubview(communityName)
        backGround.addSubview(currentStateLabel)
        backGround.addSubview(selectButton)
        selectButton.isHidden = true
        
        backGround.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        ownerType.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.top.equalToSuperview().offset(kMargin)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        cellName.snp.makeConstraints { make in
            make.left.equalTo(ownerType.snp.right).offset(kMargin/2)
            make.height.equalTo(30)
            make.centerY.equalTo(ownerType)
            make.right.equalToSuperview().offset(-80-10-10)
        }
        
        communityName.snp.makeConstraints { make in
            make.left.equalTo(cellName)
            make.right.equalTo(cellName)
            make.top.equalTo(cellName.snp.bottom)
            make.height.equalTo(30)
        }
        
        currentStateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        selectButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
    }
    
    @objc
    func chooseUnit() {
        if let unitID = unit?.unitid {
            delegate?.chooseCurrentUnit(unitID: unitID)
        }
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
