//
//  PropertyContactViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit
import JKSwiftExtension

class PropertyContactViewController: BaseViewController {
    
    var dataSource: [PropertyContactModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        MineRepository.shared.getPropertyContact { [weak self] models in
            guard let self = self else { return }
            if models.isEmpty {
                self.showNoDataView(.nodata, self.headerView)
            }else{
                self.hideNoDataView()
                self.dataSource = models
                self.tableView.reloadData()
            }
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
        view.titleLabel.text = "联系物业"
        view.backgroundColor = R.color.themeColor()
        view.closeButton.setImage(R.image.common_back_white()!, for: .normal)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .none
        view.backgroundColor = R.color.bg()
        view.register(PropertyContactTableViewCell.self, forCellReuseIdentifier: PropertyContactTableViewCellIdentifier)
        return view
    }()

}

extension PropertyContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyContactTableViewCellIdentifier, for: indexPath) as! PropertyContactTableViewCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        let model = dataSource[indexPath.row]
        cell.name.text = model.department
        cell.mobile.text = model.mobile
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        if let mobile = model.mobile, mobile.aj_isMobileNumber {
            JKGlobalTools.callPhone(phoneNumber: mobile) { flag in
                
            }
        }
    }
}
