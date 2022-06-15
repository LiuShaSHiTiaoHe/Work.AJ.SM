//
//  SetVisitorQRCodeCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/21.
//

import UIKit

let TimeSelectCellIdentifier = "TimeSelectCellIdentifier"

class TimeSelectCell: UITableViewCell {
        
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.text_title()
        view.textAlignment = .left
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_info()
        view.font = k12Font
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var arrowImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_icon_rightarrow()
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
        contentView.backgroundColor = R.color.whitecolor()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(arrowImage)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(arrowImage.snp.left).offset(-kMargin/2)
            make.left.equalTo(contentView.snp.centerX)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(6)
            make.height.equalTo(11)
            make.centerY.equalToSuperview()
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
