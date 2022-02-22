//
//  SetVisitorQRCodeCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit

let TimeSelectCellIdentifier = "TimeSelectCellIdentifier"

class TimeSelectCell: UITableViewCell {
        
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.secondtextColor()
        view.font = k12Font
        view.textAlignment = .right
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
    
    private func initializeView() {
        contentView.backgroundColor = R.color.whiteColor()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.left.equalTo(contentView.snp.centerX)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
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
