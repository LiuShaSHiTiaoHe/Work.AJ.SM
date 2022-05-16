//
//  HomeNaviHeaderView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/14.
//

import UIKit
import SnapKit

protocol HomeNaviHeaderViewDelegate: NSObjectProtocol {
    func chooseUnit()
}

class HomeNaviHeaderView: UIView {

    weak var delegate: HomeNaviHeaderViewDelegate?

    lazy var unitNameLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = R.color.whiteColor()
        label.font = k18Font
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(chooseUnitAction)))
        return label
    }()

    lazy var arrowImage: UIImageView = {
        let view = UIImageView.init()
        view.image = R.image.location()
        return view
    }()

    func updateTitle(unitName: String) {
        unitNameLabel.text = unitName
    }

    private func initializeView() {
        addSubview(unitNameLabel)
        addSubview(arrowImage)

        unitNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-kMargin / 2)
        }

        arrowImage.snp.makeConstraints { make in
            make.left.equalTo(unitNameLabel.snp.right).offset(4)
            make.width.height.equalTo(20)
            make.centerY.equalTo(unitNameLabel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func chooseUnitAction() {
        delegate?.chooseUnit()
    }

}
