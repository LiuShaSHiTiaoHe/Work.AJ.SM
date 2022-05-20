//
//  SelectUnitCityViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/3.
//

import UIKit
import SVProgressHUD
import SPPermissions
import SnapKit

let UnitCityCellIdentifier = "UnitCityCellIdentifier"

protocol SelectUnitCityViewControllerDelegate: NSObjectProtocol {
    func selectCity(name: String)
}

class SelectUnitCityViewController: BaseViewController {

    weak var delegate: SelectUnitCityViewControllerDelegate?
    private var dataSource = Dictionary<String, Array<String>>()
    private var cityNames = Array<String>()
    private var keysArray = Array<String>()
    private var searchResult = Array<String>()
    
    private var isSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        searchView.initViewType(true)
        searchView.delegate = self
        searchView.searchView.delegate = self
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        getAllCity()
    }

    func getAllCity() {
        MineRepository.shared.getAllCity { [weak self] cityArray, names in
            guard let self = self else {
                return
            }
            if cityArray.isEmpty {
                SVProgressHUD.showInfo(withStatus: "数据为空")
            } else {
                self.cityNames = names
                self.dataSource = cityArray
                self.keysArray = cityArray.allKeys().sorted {
                    $0 < $1
                }
                self.sortAllCity()
                self.tableVeiw.reloadData()
            }
        }
    }

    func sortAllCity() {
        let items = items()
        let configuration = SectionIndexViewConfiguration.init()
        configuration.adjustedContentInset = UIApplication.shared.statusBarFrame.size.height + 44
        tableVeiw.sectionIndexView(items: items, configuration: configuration)
    }

    private func items() -> [SectionIndexViewItemView] {
        var items = [SectionIndexViewItemView]()
        for title in keysArray {
            let item = SectionIndexViewItemView.init()
            item.title = title
            item.indicator = SectionIndexViewItemIndicator.init(title: title)
            items.append(item)
        }
        return items
    }

    override func initUI() {
        view.backgroundColor = R.color.bg()

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
        view.titleLabel.textColor = R.color.text_title()
        return view
    }()

    lazy var searchView: CommonSearchView = {
        let view = CommonSearchView.init()
        view.placeHolder = "请输入城市名或拼音"
        return view
    }()


    lazy var tableVeiw: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: UnitCityCellIdentifier)
        view.separatorStyle = .singleLine
        return view
    }()

}

extension SelectUnitCityViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearch {
            return 0
        }
        return 25
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        }
        return keysArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return searchResult.count
        } else {
            let values = dataSource[keysArray[section]]
            return values?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitCityCellIdentifier, for: indexPath)
        if isSearch {
            let name = searchResult[indexPath.row]
            cell.textLabel?.text = name
        } else {
            if let values = dataSource[keysArray[indexPath.section]] {
                let name = values[indexPath.row]
                cell.textLabel?.text = name
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearch {
            return ""
        } else {
            return keysArray[section]
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearch {
            let name = searchResult[indexPath.row]
            delegate?.selectCity(name: name)
            navigationController?.popViewController(animated: true)
        } else {
            if let values = dataSource[keysArray[indexPath.section]] {
                let name = values[indexPath.row]
                delegate?.selectCity(name: name)
                navigationController?.popViewController(animated: true)
            }
        }
    }

}

extension SelectUnitCityViewController: CommonSearchViewDelegate {
    func cancelSearchAction() {
        isSearch = false
        tableVeiw.reloadData()
    }
}

extension SelectUnitCityViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        isSearch = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if !isSearch {
            tableVeiw.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchString = textField.text, !searchString.isEmpty {
            let searchStringPY = searchString.jk.toPinyin()
            searchResult = cityNames.filter { name in
                let namePY = name.jk.toPinyin()
                return namePY.contains(searchStringPY)
            }
            isSearch = true
            tableVeiw.reloadData()
            return true
        }
        return false
    }
}
