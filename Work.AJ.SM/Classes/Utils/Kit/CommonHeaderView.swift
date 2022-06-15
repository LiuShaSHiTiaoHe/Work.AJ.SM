//
//  CommonHeaderView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/15.
//

import UIKit
import SnapKit

class CommonHeaderView: UIView {
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.common_back_white(), for: .normal)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = k18Font
        label.textColor = R.color.whitecolor()
        return label
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = k14Font
        return button
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.separator()
        return view
    }()

    private func initializeView() {
        backgroundColor = R.color.bg_theme()

        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(lineView)

        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin / 2)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().offset((20 + kStateHeight - kTitleAndStateHeight) / 2)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }

        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.centerY.equalTo(closeButton)
            make.height.equalTo(30)
            make.width.equalTo(kMargin * 3)
        }

        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1 / kScale)
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
