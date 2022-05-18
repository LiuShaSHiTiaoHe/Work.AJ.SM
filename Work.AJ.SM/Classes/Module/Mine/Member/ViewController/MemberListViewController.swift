//
//  MemberListViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit
import SVProgressHUD

class MemberListViewController: BaseViewController {

    private var dataSource: [MemberModel] = []

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "房屋成员"
        view.titleLabel.textColor = R.color.text_title()
        view.backgroundColor = R.color.whiteColor()
        return view
    }()

    lazy var titleView: MemberListHeaderView = {
        let view = MemberListHeaderView()
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(MemberListCell.self, forCellReuseIdentifier: MemberListCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        return view
    }()

    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加家人/成员", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addMemberAction), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemberData()
    }

    override func initUI() {
        view.backgroundColor = R.color.bg()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(addButton.snp.top).offset(-kMargin / 2)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin / 2)
        }
    }

    override func initData() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        if let unit = HomeRepository.shared.getCurrentUnit(), let cell = unit.cellname, let community = unit.communityname, let unitno = unit.unitno, let blockName = unit.blockname {
            titleView.locationLabel.text = community + blockName + cell + unitno + "室"
        }
    }

    func loadMemberData() {
        MineRepository.shared.getCurrentUnitMembers { [weak self] members in
            guard let `self` = self else {
                return
            }
            // FIXME: - 这个过滤暂时不需要
//            self.dataSource = members.filter{$0.userType != "R"}
            self.dataSource = members
            self.tableView.reloadData()
        }
    }

    @objc
    func addMemberAction() {
        let vc = AddMemberViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: MemberListCellIdentifier, for: indexPath) as! MemberListCell
        let member = dataSource[indexPath.row]
        cell.data = member
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

    }


}

extension MemberListViewController: MemberListCellDelegate {
    func deleteMember(_ member: MemberModel) {
        if let memberID = member.userID?.jk.intToString, let memberName = member.realName {
            let alert = UIAlertController.init(title: "确认删除  \(memberName)", message: "", preferredStyle: .alert)
            alert.addAction("取消", .cancel) {
            }
            alert.addAction("确定", .destructive) {
                MineRepository.shared.deleteUnitMember(memberID: memberID) { errorMsg in
                    if errorMsg.isEmpty {
                        SVProgressHUD.showSuccess(withStatus: "删除成功")
                        SVProgressHUD.dismiss(withDelay: 1) {
                            self.loadMemberData()
                        }
                    } else {
                        SVProgressHUD.showInfo(withStatus: errorMsg)
                    }
                }
            }
            alert.show()
        } else {
            SVProgressHUD.showInfo(withStatus: "数据错误")
        }

    }
}
