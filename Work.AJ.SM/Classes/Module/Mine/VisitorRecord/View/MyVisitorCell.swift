//
//  MyVisitorCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit
import SnapKit

let MyVisitorCellIdentifier = "MyVisitorCellIdentifier"

class MyVisitorCell: UITableViewCell {

    var dataSource: VisitorModel? {
        didSet {
            if let dataSource = dataSource, let name = dataSource.phone, let sTime = dataSource.credate, let eTime = dataSource.enddate, let status = dataSource.status {
                nameLabel.text = name
                startTime.text = Date.jk.timestampToFormatterTimeString(timestamp: sTime)
                endTime.text = Date.jk.timestampToFormatterTimeString(timestamp: eTime)
                if status == "O" {
                    statusImageView.image = R.image.visitor_image_valid()
                }else{
                    statusImageView.image = R.image.visitor_image_Expired()
                }
            }
        }
    }
    
    func initializeView() {
        self.addSubview(backContentView)
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
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        startTime.snp.makeConstraints { make in
            make.left.equalTo(startLabel.snp.right).offset(kMargin/2)
            make.centerY.equalTo(startLabel)
            make.height.equalTo(20)
        }
        
        endLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.top.equalTo(startLabel.snp.bottom)
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
            make.top.equalTo(endLabel.snp.bottom)
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
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k20Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var startLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "访客时间"
        return view
    }()
    
    lazy var startTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var endLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "有效期至"
        return view
    }()
    
    lazy var endTime: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var typeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = k16Font
        view.textColor = R.color.maintextColor()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.text = "访问权限"
        return view
    }()
    
    lazy var typeNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k16Font
        view.textColor = R.color.maintextColor()
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