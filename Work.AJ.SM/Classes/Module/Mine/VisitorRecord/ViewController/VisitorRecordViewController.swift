//
//  VisitorRecordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/3.
//

import UIKit
import MJRefresh

class VisitorRecordViewController: BaseViewController {

    private var dataSource: [UnitGuestModel] = []
    private let pageSize: Int = 20
    private var currentPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = refreshHeader(R.color.maintextColor()!)
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.footerLoadMore()
        })
    
        titleView.locationLabel.text = HomeRepository.shared.getCurrentHouseName()
        
        loadData()
    }
    
    func loadData() {
        if let unit = HomeRepository.shared.getCurrentUnit(), let unitID = unit.unitid?.jk.intToString, let userID = ud.userID {
            MineRepository.shared.getMyUnitGuset(userID: userID, unitID: unitID, page: currentPage.jk.intToString, size: pageSize.jk.intToString) { [weak self] datas in
                guard let self = self else { return }
                if datas.isEmpty {
                    if self.currentPage == 1{
                        self.showNoDataView(.nodata, self.headerView)
                    }else{
                        self.endLoading(true)
                    }
                }else{
                    if self.currentPage == 1 {
                        self.dataSource.removeAll()
                        self.dataSource = datas
                    }else{
                        self.dataSource.append(contentsOf: datas)
                    }
                    if datas.count < self.pageSize {
                        self.endLoading(true)
                    }else{
                        self.endLoading()
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func footerLoadMore(){
        currentPage += 1
        loadData()
    }
    
    override func headerRefresh() {
        currentPage = 1
        loadData()
    }
    
    func endLoading(_ isNoMoreData: Bool = false) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        if isNoMoreData {
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    @objc
    func addMemberAction() {
        let view = ChooseVisitorModeView()
        view.delegate = self
        PopViewManager.shared.display(view, .center, .init(width: .constant(value: 260), height: .constant(value: 250)), true)
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
            make.bottom.equalTo(addButton.snp.top).offset(-kMargin/2)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin/2)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "访客记录"
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
        view.register(MyVisitorCell.self, forCellReuseIdentifier: MyVisitorCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加访客", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addMemberAction), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()

}
extension VisitorRecordViewController: ChooseVisitorModeDelegate {
    func qrcode() {
        SwiftEntryKit.dismiss(.displayed) {
            let vc = SetVisitorQRCodeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func password() {
        SwiftEntryKit.dismiss(.displayed) {
            let vc = SetVisitorPasswordViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension VisitorRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyVisitorCellIdentifier, for: indexPath) as! MyVisitorCell
        cell.selectionStyle = .none
        let model = dataSource[indexPath.row]
        cell.dataSource = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.row]
        let vc = VisitorInvitationRecordViewController()
        vc.record = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
