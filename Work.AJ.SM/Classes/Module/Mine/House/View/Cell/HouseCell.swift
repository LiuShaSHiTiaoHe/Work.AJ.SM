//
//  HouseCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/15.
//

import UIKit
import SnapKit

protocol HouseCellDelegate: NSObjectProtocol {
    func chooseCurrentUnit(unitID: Int, status: UnitStatus)
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
                if state == UnitStatus.Pending.rawValue {
                    currentStateLabel.text = "审核中"
                    currentStateLabel.textColor = R.color.sub_yellow()
                }else if state == UnitStatus.Invalid.rawValue {
                    currentStateLabel.text = "已失效"
                    currentStateLabel.textColor = R.color.sub_red()
                }else if state == UnitStatus.Expire.rawValue {
                    currentStateLabel.text = "已过期"
                    currentStateLabel.textColor = R.color.sub_red()
                }else if state == UnitStatus.Blocked.rawValue {
                    currentStateLabel.text = "已停用"
                    currentStateLabel.textColor = R.color.sub_red()
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
                    currentStateLabel.textColor = R.color.text_info()
                }
            }
            
            if let userType = unit?.usertype {
                if userType == "O" {
                    ownerType.text = "业主"
                    ownerType.textColor = R.color.sub_green()
                    ownerType.backgroundColor = R.color.bg_green()
                }else{
                    ownerType.text = "家属"
                    ownerType.textColor = R.color.sub_yellow()
                    ownerType.backgroundColor = R.color.bg_yellow()
                }
            }
            
            if let cell = unit?.cellname, let community = unit?.communityname, let unitno = unit?.unitno, let blockName = unit?.blockname {
                cellName.text = cell + unitno + "室"
                communityName.text = community + blockName
            }
            
        }
    }
    
    lazy var backGround: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
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
        label.textColor = R.color.text_title()
        return label
    }()
    
    lazy var communityName: UILabel = {
        let label = UILabel.init()
        label.font = k12Font
        label.textColor = R.color.text_info()
        return label
    }()
    
    lazy var currentStateLabel: UILabel = {
        let label = UILabel.init()
        label.font = k12Font
        label.textColor = R.color.text_info()
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("选择", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.backgroundColor = R.color.themecolor()
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
        contentView.backgroundColor = R.color.bg()
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
        if let communityID = unit?.communityid {
            ud.currentCommunityID = communityID
        }
        if let unitID = unit?.unitid, let state = unit?.state, let unitStatus = UnitStatus.init(rawValue: state) {
            ud.currentUnitID = unitID
            delegate?.chooseCurrentUnit(unitID: unitID, status: unitStatus)
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
