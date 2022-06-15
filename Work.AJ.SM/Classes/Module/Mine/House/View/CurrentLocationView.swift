//
//  CurrentLocationView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/7.
//

import UIKit

class CurrentLocationView: BaseView {

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "当前城市"
        view.font = k14Font
        view.textColor = R.color.text_title()
        return view
    }()

    lazy var contentBackView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        return view
    }()

    lazy var locationIcon: UIImageView = {
        let view = UIImageView()
        view.image = R.image.base_image_location()
        return view
    }()

    lazy var locationName: UILabel = {
        let view = UILabel()
        view.font = k16Font
        view.textColor = R.color.text_title()
        return view
    }()

    lazy var locationButton: UIButton = {
        let view = UIButton.init(type: .custom)
        view.setTitle("重新定位", for: .normal)
        view.setTitleColor(R.color.themecolor(), for: .normal)
        view.titleLabel?.font = k14Font
        return view
    }()

    override func initializeView() {
        backgroundColor = R.color.bg()

        addSubview(titleLabel)
        addSubview(contentBackView)

        contentBackView.addSubview(locationIcon)
        contentBackView.addSubview(locationName)
        contentBackView.addSubview(locationButton)

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }

        contentBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }

        locationIcon.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.height.equalTo(17)
            make.left.equalToSuperview().offset(kMargin)
            make.centerY.equalToSuperview()
        }

        locationName.snp.makeConstraints { make in
            make.left.equalTo(locationIcon.snp.right).offset(kMargin / 2)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }

        locationButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-kMargin / 2)
        }
    }

    override func initData() {

    }

}
