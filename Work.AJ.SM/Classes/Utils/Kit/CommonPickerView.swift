//
//  CommonPickerView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/30.
//

import UIKit
import SwiftUI

protocol CommonPickerViewDelegate: NSObjectProtocol {
    func pickerCancel()
    func pickerConfirm()
}

class CommonPickerView: BaseView {

    weak var delegate: CommonPickerViewDelegate?

    override func initData() {
        leftButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(R.color.sub_red(), for: .normal)
        rightButton.setTitle("确定", for: .normal)
        rightButton.setTitleColor(R.color.themecolor(), for: .normal)
    }

    @objc
    private func cancel() {
        delegate?.pickerCancel()
    }

    @objc
    private func confirm() {
        delegate?.pickerConfirm()
    }

    override func initializeView() {
        addSubview(leftButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(pickerView)

        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin / 2)
            make.top.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }

        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin / 2)
            make.centerY.equalTo(leftButton.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftButton.snp.centerY)
            make.left.equalTo(leftButton.snp.right)
            make.right.equalTo(rightButton.snp.left)
            make.height.equalTo(30)
        }

        pickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(leftButton.snp.bottom).offset(5)
        }
    }

    lazy var leftButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k14Font
        return view
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()

    lazy var pickerView: UIPickerView = {
        let view = UIPickerView.init()
        return view
    }()
}
