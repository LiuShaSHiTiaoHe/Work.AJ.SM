//
//  ElevatorMaskConfigurationCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/5.
//

import UIKit
import SnapKit

let ElevatorMaskConfigurationCellIdentifier = "ElevatorMaskConfigurationCellIdentifier"

class ElevatorMaskConfigurationCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        contentView.addSubview(name)
        contentView.addSubview(aDoor)
        contentView.addSubview(bDoor)
        contentView.addSubview(input)
        
        name.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        aDoor.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-kMargin*2)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        bDoor.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(kMargin*2)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        input.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin)
            make.width.equalTo(100)
        }
    }
    
    lazy var name: UILabel = {
        let view = UILabel()
        view.font = k13Font
        view.textAlignment = .right
        view.textColor = R.color.text_title()
        return view
    }()
    
    lazy var aDoor: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var bDoor: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var input: UITextField = {
        let view = UITextField.init()
        return view
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
