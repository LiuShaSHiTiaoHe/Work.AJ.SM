//
//  SelectElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit
import SVProgressHUD

protocol SelectElevatorViewControllerDelegate: NSObjectProtocol {
    func updateSelectedElevator(_ elevatorID: String)
}

class SelectElevatorViewController: BaseViewController {

    var dataSource: [ElevatorInfo] = []
    var currentFloorID = ""
    weak var delegate: SelectElevatorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        headerView.rightButton.isHidden = true
        headerView.titleLabel.text = "请选择电梯"
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func closeAction() {
        if !currentFloorID.isEmpty {
            delegate?.updateSelectedElevator(currentFloorID)
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UI
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

}

extension SelectElevatorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectElevatorTableViewCell", for: indexPath) as! SelectElevatorTableViewCell
        let elevator = dataSource[indexPath.row]
        if let groupID = elevator.groupID?.jk.intToString {
            cell.elevatorID = groupID
            if groupID == currentFloorID {
                cell.selectButton.isHidden = true
                cell.currentStateLabel.isHidden = false
            } else {
                cell.selectButton.isHidden = false
                cell.currentStateLabel.isHidden = true
            }
        }
        cell.delegate = self
        cell.cellName.text = elevator.remark
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}

extension SelectElevatorViewController: SelectElevatorTableViewCellDelegate {
    func selectElevator(_ elevatorID: String) {
        currentFloorID = elevatorID
        tableView.reloadData()
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.closeAction()
        }
    }
}
