//
//  SelectElevatorTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit

class SelectElevatorTableViewCell: UITableViewCell {

    lazy var backGround: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
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
        label.text = "当前电梯"
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("选择", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.blueColor()
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
        contentView.backgroundColor = R.color.backgroundColor()
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
