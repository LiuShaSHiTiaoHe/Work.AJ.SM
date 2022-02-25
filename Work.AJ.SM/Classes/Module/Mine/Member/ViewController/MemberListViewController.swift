//
//  MemberListViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit

class MemberListViewController: BaseViewController {

    private var dataSource: [MemberModel] = []
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "房屋成员"
        view.titleLabel.textColor = R.color.maintextColor()
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
        view.backgroundColor = R.color.backgroundColor()
//        view.tableHeaderView = titleView
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
        initData()
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
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
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.bottom.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
    }
    
    func initData() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityname = unit.communityname, let cellname = unit.cellname {
            titleView.locationLabel.text = communityname + cellname
        }
        
        MineRepository.shared.getCurrentUnitMembers { [weak self] members in
            guard let `self` = self else { return }
            self.dataSource = members
            self.tableView.reloadData()
        }
    }
    
    @objc
    func addMemberAction() {
        let vc = AddMemberViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
