//
//  BleCallElevatorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class BleCallElevatorView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        
    }
    
    func initData() {
        
    }

}
