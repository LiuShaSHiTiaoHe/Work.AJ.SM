//
//  HouseCetificationView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/10.
//

import UIKit

class HouseCetificationView: BaseView {

    override func initData() {

    }

    override func initializeView() {
        addSubview(headerView)
        addSubview(locationConetntView)
        locationConetntView.addSubview(locationIconImage)
        locationConetntView.addSubview(locationName)
        addSubview(tableView)
        addSubview(confirmButton)

        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }

        locationConetntView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(headerView.snp.bottom)
        }

        locationName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }

        locationIconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(17)
            make.right.equalTo(locationName.snp.left).offset(-kMargin / 2)
        }

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(locationConetntView.snp.bottom).offset(kMargin / 2)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
        }

        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(kMargin / 2)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        view.titleLabel.text = "房屋认证"
        view.titleLabel.textColor = R.color.blackColor()
        return view
    }()

    lazy var locationConetntView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        return view
    }()

    lazy var locationIconImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_image_location()
        return view
    }()

    lazy var locationName: UILabel = {
        let view = UILabel()
        view.textColor = R.color.text_title()
        view.font = k14Font
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCellIdentifier)
        view.register(CommonSelectButtonCell.self, forCellReuseIdentifier: CommonSelectButtonCellIdentifier)
        view.register(CommonPhoneNumberCell.self, forCellReuseIdentifier: CommonPhoneNumberCellIdentifier)
        view.register(CommonIDNumberInpuCell.self, forCellReuseIdentifier: CommonIDNumberInpuCellIdentifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = R.color.bg()
        return view
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.layer.cornerRadius = 20.0
        button.backgroundColor = R.color.themeColor()
        return button
    }()
}
