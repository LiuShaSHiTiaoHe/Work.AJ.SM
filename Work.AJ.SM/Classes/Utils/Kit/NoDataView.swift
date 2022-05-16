//
//  NoDataView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/11.
//

import UIKit

enum EmptyDataType: String {
    case nodata = "暂无数据"
    case nohouse = "还没有添加房屋"
}

class NoDataView: BaseView {

    var viewType: EmptyDataType? {
        didSet {
            if let viewType = viewType {
                label.text = viewType.rawValue
                switch viewType {
                case .nodata:
                    button.isHidden = true
                case .nohouse:
                    button.isHidden = false
                }
            }
        }
    }

//    override func initData() {
//        button.addTarget(self, action: #selector(emptyViewAddHouse), for: .touchUpInside)
//    }
//
//    @objc private func emptyViewAddHouse() {
//        NotificationCenter.default.post(name: .kUserAddNewHouse, object: nil)
//    }

    override func initializeView() {
        backgroundColor = R.color.backgroundColor()
        addSubview(imageView)
        addSubview(label)
        addSubview(button)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(snp.centerY).offset(-kMargin)
            make.width.equalTo(145)
            make.height.equalTo(115)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(imageView.snp.bottom).offset(kMargin)
            make.width.equalTo(200)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.top.equalTo(label.snp.bottom).offset(kMargin)
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.base_image_nodata()
        return view
    }()

    lazy var label: UILabel = {
        let view = UILabel()
        view.text = "暂无数据"
        view.font = k15Font
        view.textColor = R.color.secondtextColor()
        view.textAlignment = .center
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加房屋", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.layer.cornerRadius = 20.0
        return button
    }()

}
