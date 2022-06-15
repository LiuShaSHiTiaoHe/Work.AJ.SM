//
//  MyVisitorCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/29.
//

import UIKit
import SnapKit

let MyVisitorCellIdentifier = "MyVisitorCellIdentifier"

class MyVisitorCell: UITableViewCell {

    var dataSource: UnitGuestModel? {
        didSet {
            if let dataSource = dataSource {
                if let name = dataSource.phone {
                    nameLabel.text = name
                }else{
                    nameLabel.text = "访客"
                }
                guard let sTime = dataSource.startdate else {
                    return
                }
                guard let eTime = dataSource.enddate else {
                    return
                }

                startTime.text = sTime
                endTime.text = eTime
                // MARK: - 不使用服务端返回的状态字段，根据startdate 和 enddate 判断
                let currentTimeInterval = Date.jk.currentDate.timeIntervalSince1970
                let startTimeInterval = Date.jk.formatterTimeStringToDate(timesString: sTime, formatter: kDefaultDateFormatter).timeIntervalSince1970
                let endTimeInterval = Date.jk.formatterTimeStringToDate(timesString: eTime, formatter: kDefaultDateFormatter).timeIntervalSince1970
                if currentTimeInterval < startTimeInterval {
                    // MARK: - 生效时间早于当前时间，待生效
                    statusImageView.image = R.image.visitor_image_ealier()
                } else if currentTimeInterval > endTimeInterval {
                    // MARK: - 当前时间晚于截至时间，失效
                    statusImageView.image = R.image.visitor_image_Expired()
                } else if currentTimeInterval > startTimeInterval && currentTimeInterval < endTimeInterval {
                    statusImageView.image = R.image.visitor_image_valid()
                }

//                if let status = dataSource.status, let valid = dataSource.valid {
//                    if status == "O" {
//                        if valid == 1 {
//                            statusImageView.image = R.image.visitor_image_valid()
//                        }else{
//                            statusImageView.image = R.image.visitor_image_Expired()
//                        }
//                    }else{
//                        statusImageView.image = R.image.visitor_image_Expired()
//                    }
//                }
                
                if let guestType = dataSource.guesttype {
                    if guestType == "1" {
                        typeNameLabel.text = "访客密码"
                    } else if guestType == "2" {
                        typeNameLabel.text = "访客二维码"
                    }else{
                        typeNameLabel.text = "未知"
                    }
                    
                }
            }
        }
    }
    
    func initializeView() {
        backgroundColor = R.color.bg()
        addSubview(backContentView)
        backContentView.addSubview(nameLabel)
        backContentView.addSubview(startLabel)
        backContentView.addSubview(startTime)
        backContentView.addSubview(endLabel)
        backContentView.addSubview(endTime)
        backContentView.addSubview(typeLabel)
        backContentView.addSubview(typeNameLabel)
        backContentView.addSubview(statusImageView)
        
        backContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.top.equalToSuperview().offset(kMargin/2)
            make.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
        }
        
        startLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalTo(nameLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(20)
        }
        
        startTime.snp.makeConstraints { make in
            make.left.equalTo(startLabel.snp.right).offset(kMargin/2)
            make.centerY.equalTo(startLabel)
            make.height.equalTo(20)
        }
        
        endLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalTo(startLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(20)
        }
        
        endTime.snp.makeConstraints { make in
            make.left.equalTo(endLabel.snp.right).offset(kMargin/2)
            make.centerY.equalTo(endLabel)
            make.height.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(20)
            make.top.equalTo(endLabel.snp.bottom).offset(kMargin/2)
        }
        
        typeNameLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel.snp.right).offset(kMargin/2)
            make.centerY.equalTo(typeLabel)
            make.height.equalTo(20)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(79)
            make.height.equalTo(61.5)
            make.right.equalToSuperview().offset(-kMargin)
        }
        
    }
    
    lazy var backContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k20Font
        view.textColor = R.color.text_title()
        view.text = "访客"
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var startLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "访客时间"
        return view
    }()
    
    lazy var startTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var endLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "有效期至"
        return view
    }()
    
    lazy var endTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var typeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "访问权限"
        return view
    }()
    
    lazy var typeNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var statusImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
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
