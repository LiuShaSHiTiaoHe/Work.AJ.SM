//
//  BleOpenDoorStyleCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit
import BEMCheckBox

protocol BleOpenDoorStyleCellDelegate: NSObjectProtocol {
    func switchValueChanged(style: Int, status: Bool)
}

let BleOpenDoorStyleCellIdentifier = "BleOpenDoorStyleCellIdentifier"

class BleOpenDoorStyleCell: UITableViewCell {

    var status: Bool? {
        didSet {
            if let status = status {
                checkBox.setOn(status, animated: true)
                checkBox.isUserInteractionEnabled = !status
            }
        }
    }
    
    var openDoorStyle: Int?

    weak var delegate: BleOpenDoorStyleCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        checkBox.addTarget(self, action: #selector(switchChange(_:)), for: .valueChanged)
    }
    
    @objc
    func switchChange(_ sender: BEMCheckBox) {
        if let openDoorStyle = openDoorStyle {
            delegate?.switchValueChanged(style: openDoorStyle, status: sender.on)
        }
    }
    
    func initializeView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(checkBox)

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.top.equalToSuperview().offset(kMargin)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin*3)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        checkBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
            make.height.width.equalTo(30)
        }
    }
    
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k16Font
        view.textAlignment = .left
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var checkBox: BEMCheckBox = {
        let box = BEMCheckBox.init()
        box.boxType = .circle
        box.onAnimationType = .oneStroke
        box.offAnimationType = .oneStroke
        box.tintColor = R.color.owner_greenColor()!
        box.onTintColor = R.color.owner_greenColor()!
        box.onCheckColor = R.color.owner_greenColor()!
        return box
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
