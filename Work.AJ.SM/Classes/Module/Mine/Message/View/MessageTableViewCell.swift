//
//  MessageTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit
import SnapKit

let MessageTableViewCellIdentifier = "MessageTableViewCellIdentifier"

class MessageTableViewCell: UITableViewCell {

    var data: MessageModel? {
        didSet {
            if let data = data {
                if let title = data.title {
                    nameLabel.text = title
                }
                if let time = data.createTime {
                    timeLabel.text = time
                }
                if let content = data.text {
                    messageLabel.text = content
                }
            }
        }
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        self.contentView.addSubview(backgrdView)
        backgrdView.addSubview(nameLabel)
        backgrdView.addSubview(timeLabel)
        backgrdView.addSubview(messageLabel)
        
        backgrdView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kMargin/2)
            make.right.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin/2)
            make.left.equalToSuperview().offset(kMargin/2)
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(30)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(kMargin)
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalToSuperview().offset(-kMargin)
        }
    }
    
    lazy var backgrdView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel.init()
        view.font = k14Font
        view.textColor = R.color.secondtextColor()
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel.init()
        view.font = k12Font
        view.textColor = R.color.secondtextColor()
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel.init()
        view.font = k20Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
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
