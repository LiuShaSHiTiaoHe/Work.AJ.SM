//
//  NComRecordViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit
import MJRefresh

class NComRecordViewController: BaseViewController {

    private var dataSource: [NComRecordInfo] = []
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.mj_header = refreshHeader()
        contentView.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerLoadMore()
        })//MJRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        
        loadNComRecord()
    }
    
    override func headerRefresh() {
        page = 1
        loadNComRecord()
    }
    
    @objc func footerLoadMore(){
        page += 1
        loadNComRecord()
    }
    
    private func loadNComRecord() {
        HomeRepository.shared.loadNComRecord("", "", page.jk.intToString, "15") {[weak self] (records, totalPage) in
            guard let self = self else { return }
            if self.page == 1{
                self.contentView.tableView.mj_header?.endRefreshing()
            }else{
                self.contentView.tableView.mj_header?.endRefreshing()
                self.contentView.tableView.mj_footer?.endRefreshing()
            }
            if totalPage != -1 {
                if !records.isEmpty {
                    self.dataSource.append(contentsOf: records)
                }
            }
            if records.count < 15 {
                self.contentView.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.contentView.tableView.reloadData()
        }
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: NComRecordView = {
        let view = NComRecordView()
        return view
    }()
    
}

extension NComRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NComRecordCellIdentifier, for: indexPath) as! NComRecordCell
        let data = dataSource[indexPath.row]
        cell.record = data
        return cell
    }
    
    
}
