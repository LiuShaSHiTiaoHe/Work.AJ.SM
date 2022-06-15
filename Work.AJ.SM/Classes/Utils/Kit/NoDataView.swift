//
//  NoDataView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/11.
//

import UIKit
import JKSwiftExtension

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
                    //FIXME: - 暂时隐藏刷新按钮
                    refreshButton.isHidden = true
                case .nohouse:
                    button.isHidden = false
                    refreshButton.isHidden = false
                }
            }
        }
    }

    override func initializeView() {
        backgroundColor = R.color.bg()
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
        addSubview(refreshButton)

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
        
        refreshButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.top.equalTo(button.snp.bottom).offset(kMargin)
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
        view.textColor = R.color.text_info()
        view.textAlignment = .center
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.base_btn_add(), for: .normal)
        button.jk.setImageTitleLayout(.imgRight, spacing: kMargin/2)
        button.setTitle("添加房屋", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.backgroundColor = R.color.themecolor()
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.base_btn_refresh(), for: .normal)
        button.jk.setImageTitleLayout(.imgRight, spacing: kMargin/2)
        button.setTitle("重新加载", for: .normal)
        button.setTitleColor(R.color.whitecolor(), for: .normal)
        button.backgroundColor = R.color.themecolor()
        button.layer.cornerRadius = 20.0
        return button
    }()

}
