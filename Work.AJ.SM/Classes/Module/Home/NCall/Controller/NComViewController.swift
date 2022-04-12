//
//  NComViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/12.
//

import UIKit

class NComViewController: BaseViewController {

    private var dataSource:[NComDTU] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.tableView.mj_header?.beginRefreshing()
    }
    
    override func initData() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ncomdevicecell")
        contentView.headerView.rightButton.addTarget(self, action: #selector(go2RecordView), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.mj_header = refreshHeader()
    }

    override func headerRefresh() {
        loadAllDevice()
    }
    
    // MARK: - Functions
    func loadAllDevice() {
        HomeRepository.shared.allNComDeviceInfo { [weak self] devices in
            guard let self = self else { return }
            if devices.isEmpty {
                self.showNoDataView(.nodata, self.contentView.headerView)
            }else{
                self.hideNoDataView()
                self.dataSource = devices
                self.reloadTableView()
            }
        }
    }
        
    
    @objc func go2RecordView(){
        self.navigationController?.pushViewController(NComRecordViewController(), animated: true)
    }
    
    func reloadTableView() {
        contentView.tableView.reloadData()
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: NComView = {
        let view = NComView()
        return view
    }()
    
}

extension NComViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ncomdevicecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
