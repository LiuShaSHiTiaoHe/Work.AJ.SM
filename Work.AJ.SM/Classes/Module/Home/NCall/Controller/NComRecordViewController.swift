//
//  NComRecordViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/12.
//

import UIKit

class NComRecordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ncomrecordCell", for: indexPath)
        return cell
    }
    
    
}
