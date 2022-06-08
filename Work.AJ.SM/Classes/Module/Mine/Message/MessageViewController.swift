//
//  MessageViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit
import MJRefresh

class MessageViewController: BaseViewController {

    private var dataSource: [MessageModel] = []
    private let pageSize: Int = 20
    private var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = refreshHeader(R.color.text_title()!)
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.footerLoadMore()
        })
            
        loadData()
    }
    
    func loadData() {
        if let unit = HomeRepository.shared.getCurrentUnit(), let _ = unit.unitid?.jk.intToString, let userID = ud.userID {
            
            MineRepository.shared.getMessages(userID: userID, page: currentPage.jk.intToString, size: pageSize.jk.intToString) {[weak self] datas in
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
    
    
    override func initUI() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "消息"
        view.backgroundColor = R.color.themecolor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCellIdentifier)
        return view
    }()

}


extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        let model = dataSource[indexPath.row]
        cell.data = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)        
        let model = dataSource[indexPath.row]

    }
    
    
}
