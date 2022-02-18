//
//  RemoteOpenDoorCell.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit

class RemoteOpenDoorCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    
    private func initializeView() {
        contentView.backgroundColor = R.color.backgroundColor()
        
    }
    
    @objc
    func chooseLock() {
     
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
