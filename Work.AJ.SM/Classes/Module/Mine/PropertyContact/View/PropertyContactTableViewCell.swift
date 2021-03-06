//
//  PropertyContactTableViewCell.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/10.
//

import UIKit

let PropertyContactTableViewCellIdentifier = "PropertyContactTableViewCellIdentifier"

class PropertyContactTableViewCell: UITableViewCell {

    private func initializeView() {
        contentView.backgroundColor = R.color.bg()
        self.contentView.addSubview(backgrdView)
        backgrdView.addSubview(name)
        backgrdView.addSubview(mobile)
        
        backgrdView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kMargin/2)
            make.right.bottom.equalToSuperview().offset(-kMargin/2)
        }
        
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin/2)
            make.height.equalTo(30)
        }
        
        mobile.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    lazy var backgrdView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var name: UILabel = {
        let view = UILabel.init()
        view.font = k16Font
        view.textColor = R.color.text_info()
        view.textAlignment = .right
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()
    
    lazy var mobile: UILabel = {
        let view = UILabel.init()
        view.font = k16Font
        view.textColor = R.color.text_title()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
