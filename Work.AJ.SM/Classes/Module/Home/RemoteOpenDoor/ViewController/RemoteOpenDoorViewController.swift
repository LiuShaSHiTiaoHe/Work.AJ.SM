//
//  RemoteOpenDoorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit

class RemoteOpenDoorViewController: BaseViewController {

    private var dataSource: [UnitLockModel] = []
    
    lazy var openDoorView: RemoteOpenDoorView = {
        let view = RemoteOpenDoorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }
    
    override func initUI() {
        view.addSubview(openDoorView)
        openDoorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func initData() {
        dataSource = HomeRepository.shared.getCurrentLocks()
    }
}
