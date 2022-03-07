//
//  SelectUnitCityViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/3.
//

import UIKit

let UnitCityCellIdentifier = "UnitCityCellIdentifier"

class SelectUnitCityViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        searchView.initViewType(true)
    }

    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(tableVeiw)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(60)
        }
        
        tableVeiw.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "选择城市"
        return view
    }()
    
    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        return view
    }()
    
    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        return view
    }()
    
}

extension SelectUnitCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitCityCellIdentifier, for: indexPath)
        return cell
    }
    
    
}
