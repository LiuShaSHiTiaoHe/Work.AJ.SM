//
//  SelectElevatorTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/17.
//

import UIKit

protocol SelectElevatorTableViewCellDelegate: NSObjectProtocol {
    func selectElevator(_ elevatorID: String)
}

class SelectElevatorTableViewCell: UITableViewCell {

    var elevatorID: String?
    weak var delegate: SelectElevatorTableViewCellDelegate?
    
    lazy var backGround: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
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
        label.text = "当前电梯"
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("选择", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.backgroundColor = R.color.themecolor()
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = k12Font
        button.addTarget(self, action: #selector(chooseElevator), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.bg()
        contentView.addSubview(backGround)
        
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
        
        cellName.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-80-10-10)
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalToSuperview().offset(kMargin)
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
    func chooseElevator() {
        if let elevatorID = elevatorID {
            delegate?.selectElevator(elevatorID)
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
