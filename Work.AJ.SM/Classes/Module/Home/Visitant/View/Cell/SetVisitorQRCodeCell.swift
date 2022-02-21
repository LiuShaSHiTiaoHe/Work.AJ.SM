//
//  SetVisitorQRCodeCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/21.
//

import UIKit

let SetVisitorQRCodeCellIdentifier = "SetVisitorQRCodeCellIdentifier"

class SetVisitorQRCodeCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        
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
