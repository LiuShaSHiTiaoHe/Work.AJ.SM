//
//  HouseSearchViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/18.
//

import UIKit

class HouseSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "搜索"
        
        searchView.initViewType(true)
        searchView.searchView.addTarget(self, action: #selector(textInputEditingBegin(_:)), for: .editingDidBegin)
        searchView.searchView.addTarget(self, action: #selector(textInputEditingEnd(_:)), for: .editingDidEnd)
    }
    
    // MARK: - Action
    @objc func textInputEditingBegin(_ sender: UITextField) {
        DispatchQueue.main.async {
            
        }
    }
    
    @objc func textInputEditingEnd(_ sender: UITextField) {
        DispatchQueue.main.async {
            
        }
    }

    
    // MARK: - UI
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(tipsLabel)
        view.addSubview(tableVeiw)
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(ConstSearhViewHeight)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(searchView.snp.bottom)
        }
        
        tableVeiw.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "选择小区/楼栋"
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()
    
    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        view.placeHolder = "请输入关键字"
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "搜索结果"
        view.font = k14Font
        view.textColor = R.color.secondtextColor()
        return view
    }()
    
    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        view.separatorStyle = .singleLine
        return view
    }()
}
