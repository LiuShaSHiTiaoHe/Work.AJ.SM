//
//  SelectUnitCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/8.
//

import UIKit

let SelectUnitCellIdentifier = "SelectUnitCellIdentifier"

class SelectUnitCell: UITableViewCell {

    var isCurrentCell: Bool = false {
        didSet {
            if isCurrentCell {
                self.backgroundColor = R.color.whiteColor()
                horizonLine.isHidden = false
                locationName.textColor = R.color.themeColor()
            }else {
                self.backgroundColor = R.color.backgroundColor()
                horizonLine.isHidden = true
                locationName.textColor = R.color.maintextColor()
            }
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        self.selectionStyle = .none
        contentView.addSubview(horizonLine)
        contentView.addSubview(locationName)
        
        horizonLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin/2)
            make.width.equalTo(2)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        locationName.snp.makeConstraints { make in
            make.left.equalTo(horizonLine.snp.right).offset(kMargin/2)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var horizonLine: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themeColor()
        return view
    }()
    
    lazy var locationName: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.maintextColor()
        return view
    }()
    
    
}
