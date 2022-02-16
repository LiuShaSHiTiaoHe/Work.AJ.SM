//
//  IndoorCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class IndoorCallElevatorViewController: BaseViewController {

    lazy var indoorCallElevatorView: IndoorCallElevatorView = {
        let view = IndoorCallElevatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        // Do any additional setup after loading the view.
        indoorCallElevatorView.delegate = self
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(indoorCallElevatorView)
        indoorCallElevatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension IndoorCallElevatorViewController: IndoorCallElevatorViewDelegate {
    
    func callUpAction() {
        
    }
    
    func callDownAction() {
        
    }
    
    func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
