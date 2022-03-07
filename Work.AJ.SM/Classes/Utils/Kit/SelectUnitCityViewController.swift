//
//  SelectUnitCityViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/3.
//

import UIKit
import SVProgressHUD

let UnitCityCellIdentifier = "UnitCityCellIdentifier"

class SelectUnitCityViewController: BaseViewController {

    private var dataSource = Dictionary<String, Array<String>>()
    private var keysArray  = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        searchView.initViewType(true)
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        
        MineRepository.shared.getAllCity {[weak self] cityArray in
            if cityArray.isEmpty {
                SVProgressHUD.showInfo(withStatus: "数据为空")
            }else{
                self?.dataSource = cityArray
                self?.keysArray = cityArray.allKeys().sorted{$0 < $1}
                self?.tableVeiw.reloadData()
            }
        }
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
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        view.placeHolder = "请输入城市名或拼音"
        return view
    }()
    
    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        return view
    }()
    
}

extension SelectUnitCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = dataSource[keysArray[section]]
        return values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitCityCellIdentifier, for: indexPath)
        if let values = dataSource[keysArray[indexPath.section]] {
            let name = values[indexPath.row]
            cell.textLabel?.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray[section]
    }
    
}
