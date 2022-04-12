//
//  NComDeviceCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/12.
//

import UIKit
import SnapKit

class NComRecordCell: UITableViewCell {
    
    var record: NComRecordInfo? {
        didSet {
            if let record = record {
                //呼叫类型
                if let calltype = record.callType, calltype == 1 {
                    iconImage.image = R.image.cell_icon_call_in()
                }else{
                    iconImage.image = R.image.cell_icon_call_out()
                }
                //呼叫对象
                if let nickName = record.dtuNickName {
                    nameLabel.text = nickName
                }else{
                    nameLabel.text = record.callTarget
                }
                
                if let callStatus = record.callStatus {
                    if callStatus == 2 {
                        durationLabel.text = "未接通"
                    }else if callStatus == 4, let duration = record.callAllTime {
                        durationLabel.text = GDataManager.shared.timeDuration(withInterval: duration)
                    }else{
                        durationLabel.text = "未知"
                    }
                }else{
                    durationLabel.text = "未知"
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(durationLabel)
        
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(kMargin/2)
            make.top.equalToSuperview().offset(kMargin/2)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        durationLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(kMargin/2)
            make.height.equalTo(20)
        }
        
        
    }
    
    lazy var iconImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.maintextColor()
        view.font = k16Font
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.secondtextColor()
        view.font = k14Font
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var durationLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
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
