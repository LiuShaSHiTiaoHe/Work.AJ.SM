//
//  SelectElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit

class SelectElevatorViewController: BaseViewController {
    
    var dataSource: [ElevatorInfo] = []
    var currentFloorID = ""

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView.init()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(SelectElevatorTableViewCell.self, forCellReuseIdentifier: "SelectElevatorTableViewCell")
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    func initData() {
        headerView.rightButton.isHidden = true
        headerView.titleLabel.text = "请选择电梯"
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc
    func closeAction(){
        self.navigationController?.popViewController(animated: true)
    }

}

extension SelectElevatorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectElevatorTableViewCell", for: indexPath) as! SelectElevatorTableViewCell
        let elevator = dataSource[indexPath.row]
        if let groupID = elevator.groupID?.jk.intToString, groupID == currentFloorID {
            cell.selectButton.isHidden = true
            cell.currentStateLabel.isHidden = false
        }
        cell.cellName.text = elevator.remark
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
