//
//  BleOpenDoorStyleCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/2.
//

import UIKit

protocol BleOpenDoorStyleCellDelegate: NSObjectProtocol {
    func switchValueChanged(style: Int, status: Bool)
}

let BleOpenDoorStyleCellIdentifier = "BleOpenDoorStyleCellIdentifier"

class BleOpenDoorStyleCell: UITableViewCell {

    var status: Bool? {
        didSet {
            if let status = status {
                switchView.isOn = status
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
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }

    
    func initializeView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(switchView)

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
        
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_title()
        view.font = k16Font
        view.textAlignment = .left
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k12Font
        view.textColor = R.color.text_info()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch.init()
        view.tintColor = R.color.sub_green()
        return view
    }()
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        if let openDoorStyle = openDoorStyle {
            delegate?.switchValueChanged(style: openDoorStyle, status: sender.isOn)
        }
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
