//
//  HomeNaviHeaderView.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/14.
//

import UIKit
import SnapKit

protocol HomeNaviHeaderViewDelegate: NSObjectProtocol {
    func chooseUnit()
}

class HomeNaviHeaderView: UIView {
    
    private let maxUnitNameWidth = kScreenWidth - kMargin*2 - kMargin
    weak var delegate: HomeNaviHeaderViewDelegate?

    lazy var unitNameLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = R.color.whitecolor()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byTruncatingMiddle
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
        let sizeWidth = unitName.jk.singleLineWidth(font: UIFont.systemFont(ofSize: 20))
        if sizeWidth < maxUnitNameWidth {
            unitNameLabel.snp.updateConstraints { make in
                make.width.equalTo(sizeWidth)
            }
        }else{
            unitNameLabel.snp.updateConstraints { make in
                make.width.equalTo(maxUnitNameWidth)
            }
        }
    }

    private func initializeView() {
        addSubview(unitNameLabel)
        addSubview(arrowImage)

        unitNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(maxUnitNameWidth)
            make.bottom.equalToSuperview().offset(-kMargin / 2)
        }

        arrowImage.snp.makeConstraints { make in
            make.left.equalTo(unitNameLabel.snp.right)
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
