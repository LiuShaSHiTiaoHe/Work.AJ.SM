//
//  CallNeighborViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit

class CallNeighborViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: CallNeighborView = {
        let view = CallNeighborView()
        return view
    }()

}
