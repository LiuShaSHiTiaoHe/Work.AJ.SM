//
//  ElevatorConfigurationViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/7.
//

import UIKit
import SVProgressHUD

enum ElevatorConfigurationPickerType: String {
    case block = "楼栋"
    case cell = "单元"
    case group = "电梯群组"
    case elevator = "电梯"
}

class ElevatorConfigurationViewController: BaseViewController {
    
    private var ec: ElevatorConfiguration?
    private var block: ConfigurationBlock? {
        didSet {
            if let _ = block {
                cell = nil
                group = nil
                elevator = nil
            }
        }
    }
    private var cell: ConfigurationCell?{
        didSet {
            if let _ = cell {
                group = nil
                elevator = nil
            }
        }
    }
    private var group: ConfigurationCellLiftGroup?{
        didSet{
            if let _ = group {
                elevator = nil
            }
        }
    }
    private var elevator: ConfigurationLifts?
    private var pickerType: ElevatorConfigurationPickerType = .block
    private var pickerIndex: Int = 0
    
    private lazy var picker: CommonPickerView = {
        let view = CommonPickerView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initData() {
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        picker.delegate = self
        picker.pickerView.delegate = self
        picker.pickerView.dataSource = self
        loadData()
    }
    
    private func loadData() {
        HomeRepository.shared.getElevatorConffiguration {[weak self] model in
            guard let self = self else { return }
            if let model = model {
                self.ec = model
            }else{
                SVProgressHUD.showError(withStatus: "暂无数据")
                SVProgressHUD.dismiss(withDelay: 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func confirmAction() {
        if let elevator = elevator, let configurationData = ec?.communityConfig {
            let vc = ElevatorConfigurationSendDataViewController()
            vc.elevator = elevator
            vc.configurationData = configurationData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var contentView: ElevatorConfigurationView = {
        let view = ElevatorConfigurationView()
        return view
    }()
}

extension ElevatorConfigurationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
        cell.accessoryType = .disclosureIndicator
        cell.commonInput.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            if let block = block,  let blockName = block.blockname{
                cell.commonInput.text = blockName
            }else{
                cell.commonInput.placeholder = "请选择" + ElevatorConfigurationPickerType.block.rawValue
            }
            cell.nameLabel.text = ElevatorConfigurationPickerType.block.rawValue
        case 1:
            if let ecell = self.cell, let cellName = ecell.cellname {
                cell.commonInput.text = cellName
            }else{
                cell.commonInput.placeholder = "请选择" + ElevatorConfigurationPickerType.cell.rawValue
            }
            cell.nameLabel.text = ElevatorConfigurationPickerType.cell.rawValue
        case 2:
            if let group = self.group, let groupName = group.groupname {
                cell.commonInput.text = groupName
            }else{
                cell.commonInput.placeholder = "请选择" + ElevatorConfigurationPickerType.group.rawValue
            }
            cell.nameLabel.text = ElevatorConfigurationPickerType.group.rawValue
        case 3:
            if let elevator = self.elevator, let elevatorName = elevator.remark {
                cell.commonInput.text = elevatorName
            }else{
                cell.commonInput.placeholder = "请选择" + ElevatorConfigurationPickerType.elevator.rawValue
            }
            cell.nameLabel.text = ElevatorConfigurationPickerType.elevator.rawValue
        default:
            fatalError()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            showPicker(.block)
        case 1:
            showPicker(.cell)
        case 2:
            showPicker(.group)
        case 3:
            showPicker(.elevator)
        default:
            fatalError()
        }
    }

}


extension ElevatorConfigurationViewController: UIPickerViewDelegate, UIPickerViewDataSource, CommonPickerViewDelegate {

    func pickerCancel() {
        PopViewManager.shared.dissmiss {}
    }
    
    func pickerConfirm() {
        switch pickerType {
        case .block:
            if let blocks = ec?.blocks {
                block = blocks[pickerIndex]
            }
        case .cell:
            if let cells = block?.cells {
                cell = cells[pickerIndex]
            }
        case .group:
            if let liftsGroup = cell?.cellLiftGroups {
                group = liftsGroup[pickerIndex]
            }
        case .elevator:
            if let elevators = group?.lifts {
                elevator = elevators[pickerIndex]
            }
        }
        contentView.tableView.reloadData()
        PopViewManager.shared.dissmiss {}
    }
        
    func showPicker(_ type: ElevatorConfigurationPickerType) {
        if showErrorTips(type) {
            return
        }
        pickerType = type
        pickerIndex = 0
        picker.titleLabel.text = type.rawValue
        picker.pickerView.reloadAllComponents()
        picker.pickerView.selectRow(0, inComponent: 0, animated: true)
        PopViewManager.shared.display(picker, .bottom, .init(width: .constant(value: kScreenWidth), height: .constant(value: 300)))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .block:
            if let blocks = ec?.blocks, let blockName = blocks[row].blockname {
               return blockName
            }
        case .cell:
            if let cells = block?.cells, let cellName = cells[row].cellname {
                return cellName
            }
        case .group:
            if let liftsGroup = cell?.cellLiftGroups, let groupName = liftsGroup[row].groupname {
                return groupName
            }
        case .elevator:
            if let elevators = group?.lifts, let elevatorName = elevators[row].remark {
                return elevatorName
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .block:
            if let blocks = ec?.blocks {
                return blocks.count
            }
        case .cell:
            if let cells = block?.cells {
                return cells.count
            }
        case .group:
            if let liftsGroup = cell?.cellLiftGroups {
                return liftsGroup.count
            }
        case .elevator:
            if let elevators = group?.lifts {
                return elevators.count
            }
        }
        return 0
    }
    
    func showErrorTips(_ type: ElevatorConfigurationPickerType) -> Bool {
        switch pickerType {
        case .block:
            break
        case .cell:
            if block == nil {
                SVProgressHUD.showError(withStatus: "请先选择楼栋")
                return true
            }
        case .group:
            if block == nil {
                SVProgressHUD.showError(withStatus: "请先选择楼栋")
                return true
            }else if cell == nil {
                SVProgressHUD.showError(withStatus: "请先选择单元")
                return true
            }
        case .elevator:
            if block == nil {
                SVProgressHUD.showError(withStatus: "请先选择楼栋")
                return true
            }else if cell == nil {
                SVProgressHUD.showError(withStatus: "请先选择单元")
                return true
            }else if group == nil {
                SVProgressHUD.showError(withStatus: "请先选择电梯群组")
                return true
            }
        }
        return false
    }
}
