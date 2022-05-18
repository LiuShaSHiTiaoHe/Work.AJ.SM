//
//  HouseSearchViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/18.
//

import UIKit

protocol HouseSearchViewControllerDelegate: NSObjectProtocol {
    func searchResultOfCommunity(_ data: CommunityModel)
}

class HouseSearchViewController: BaseViewController {

    weak var delegate: HouseSearchViewControllerDelegate?
    private var dataSource: [CommunityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "搜索"
        searchView.initViewType(true)
        searchView.searchView.delegate = self
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
    }

    // MARK: - Action
    func loadDatas(_ name: String) {
        MineRepository.shared.searchCommunity(with: name) { [weak self] models in
            guard let self = self else {
                return
            }
            self.dataSource = models
            self.tableVeiw.reloadData()
        }
    }

    // MARK: - UI
    override func initUI() {
        view.backgroundColor = R.color.bg()
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
        view.titleLabel.textColor = R.color.text_title()
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
        view.textColor = R.color.text_info()
        return view
    }()

    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        view.separatorStyle = .singleLine
        return view
    }()
}

extension HouseSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitCityCellIdentifier, for: indexPath)
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = dataSource[indexPath.row]
        delegate?.searchResultOfCommunity(model)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }


}

extension HouseSearchViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchString = textField.text, !searchString.isEmpty {
            loadDatas(searchString)
            return true
        }
        return false
    }
}
