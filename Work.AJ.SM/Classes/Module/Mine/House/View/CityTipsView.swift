//
//  CityTipsView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/25.
//

import UIKit

protocol CityTipsViewDelegate: NSObjectProtocol {
    func chooseCity()
}

class CityTipsView: BaseView {

    weak var delegate: CityTipsViewDelegate?

    @objc func tapCityAction() {
        delegate?.chooseCity()
    }

    override func initData() {
        cityName.isUserInteractionEnabled = true
        cityName.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapCityAction)))
    }

    override func initializeView() {
        backgroundColor = R.color.whiteColor()

        addSubview(tipsLabel)
        addSubview(locationIcon)
        addSubview(cityName)
        addSubview(downArrowIcon)

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }

        cityName.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin - 30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }

        locationIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(cityName.snp.left).offset(-kMargin / 2)
            make.width.equalTo(12)
            make.height.equalTo(15)
        }

        downArrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(cityName.snp.right).offset(kMargin / 4)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = k16Font
        view.textColor = R.color.secondtextColor()
        view.text = "请选择城市"
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()

    lazy var locationIcon: UIImageView = {
        let view = UIImageView.init(image: R.image.base_image_location())
        return view
    }()

    lazy var cityName: UILabel = {
        let view = UILabel()
        view.font = k18Font
        view.textColor = R.color.themeColor()
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()

    lazy var downArrowIcon: UIImageView = {
        let view = UIImageView.init(image: R.image.common_dowm_arrow_image())
        return view
    }()

}
