//
//  MobileCallElevatorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import UIKit

let MobileCallElevatorCellidentifier = "MCECollectionViewCell"

protocol MobileCallElevatorViewDelegate: NSObjectProtocol {
    func chooseElevator()
}

class MobileCallElevatorView: UIView {

    weak var delegate: MobileCallElevatorViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData() {
        titleContentView.isUserInteractionEnabled = true
        titleContentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(chooseElevatorAction)))
    }

    @objc
    func chooseElevatorAction() {
        delegate?.chooseElevator()
    }


    func updateTitle() {

    }

    func initializeView() {
        backgroundColor = R.color.backgroundColor()

        addSubview(headerView)
        addSubview(titleContentView)
        titleContentView.addSubview(elevatorTitle)
        titleContentView.addSubview(elevatorLocation)
        titleContentView.addSubview(downArrow)
        addSubview(tipsLabel)
        addSubview(collectionView)

        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        titleContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(75)
        }

        elevatorTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kMargin)
            make.height.equalTo(20)
        }

        elevatorLocation.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(elevatorTitle.snp.bottom)
            make.height.equalTo(20)
        }
        downArrow.snp.makeConstraints { make in
            make.left.equalTo(elevatorLocation.snp.right)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleContentView.snp.bottom).offset(kMargin / 2)
            make.height.equalTo(30)
        }

        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin / 2)
        }

    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.rightButton.isHidden = true
        view.backgroundColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.titleLabel.text = "乘梯选层"
        view.titleLabel.textColor = R.color.maintextColor()
        return view
    }()

    lazy var titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whiteColor()
        return view
    }()

    lazy var elevatorTitle: UILabel = {
        let view = UILabel()
        view.textColor = R.color.blackColor()
        view.font = k15Font
        view.textAlignment = .center
        return view
    }()

    lazy var elevatorLocation: UILabel = {
        let view = UILabel()
        view.textColor = R.color.blackColor()
        view.font = k15Font
        view.textAlignment = .center
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return view
    }()

    lazy var downArrow: UIImageView = {
        let view = UIImageView()
        view.image = R.image.common_dowm_arrow_image()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.color.themeColor()
        view.font = k15Font
        view.textAlignment = .center
        view.text = "请移步至电梯厅，再选择目的楼层"
        return view
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin / 2, right: kMargin)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceVertical = true
        c.backgroundColor = R.color.backgroundColor()
        c.register(MCECollectionViewCell.self, forCellWithReuseIdentifier: MobileCallElevatorCellidentifier)
        return c
    }()

}
