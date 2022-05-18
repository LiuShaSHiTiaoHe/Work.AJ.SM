//
//  CallNeighborView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit
import SnapKit

protocol CallNeighborViewDelegate: NSObjectProtocol {
    func callNeighborWithAddress(_ address: String)
}

class CallNeighborView: BaseView {

    private let dialButtonsStr: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    private let dialButtonHeight: CGFloat = 80.0

    weak var delegate: CallNeighborViewDelegate?

    override func initData() {
        dialPad.delegate = self
        dialPad.dataSource = self
        deleteButton.addTarget(self, action: #selector(deleteStr), for: .touchUpInside)
        dialButton.addTarget(self, action: #selector(callButtonAction), for: .touchUpInside)
    }

    @objc
    func deleteStr() {
        if let inputStr = inputFiled.text, !inputStr.isEmpty {
            let tempString = String(inputStr.dropLast())
            inputFiled.text = tempString
        }
    }

    @objc
    func callButtonAction() {
        if let inputStr = inputFiled.text {
            delegate?.callNeighborWithAddress(inputStr)
        }
    }

    override func initializeView() {
        backgroundColor = R.color.bg()

        addSubview(headerView)
        addSubview(tipLabel)
        addSubview(inputFiled)
        addSubview(deleteButton)
        addSubview(dialPad)
        addSubview(dialButton)

        headerView.snp.makeConstraints { make in
            make.height.equalTo(kTitleAndStateHeight)
            make.left.right.top.equalToSuperview()
        }

        tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(headerView.snp.bottom).offset(kMargin)
        }

        inputFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-80)
            make.bottom.equalTo(dialPad.snp.top).offset(-kMargin)
            make.height.equalTo(40)
        }

        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kMargin)
            make.width.equalTo(40)
            make.height.equalTo(27)
            make.centerY.equalTo(inputFiled)
        }

        dialPad.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-80)
            make.height.equalTo(dialButtonHeight * 4)
        }

        dialButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
    }

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.titleLabel.text = "户户通"
        view.titleLabel.textColor = R.color.whiteColor()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        view.backgroundColor = R.color.themeColor()
        return view
    }()

    lazy var tipLabel: UILabel = {
        let view = UILabel.init()
        view.numberOfLines = 0
        view.text = "拨号规则：楼栋号+单元号+房屋号，比如拨打2栋2单元101室的用户，楼栋号与单元号不足两位的前面多加0，单元号为空输00，房间号不足四位多加0，拨号02020101"
        view.font = k16Font
        view.textColor = R.color.text_info()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return view
    }()

    lazy var inputFiled: UILabel = {
        let view = UILabel()
        view.font = k28Font
        view.textColor = R.color.blackColor()
        view.textAlignment = .right
        return view
    }()

    lazy var deleteButton: UIButton = {//40 27
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_delete_image(), for: .normal)
        return button
    }()
    // MARK: - item size kscreenwidth - kmargin/3  50
    lazy var dialPad: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceHorizontal = false
        c.backgroundColor = R.color.bg()
        c.register(DialCollectionViewCell.self, forCellWithReuseIdentifier: DialCollectionViewCellCellIdentifier)
        return c
    }()

    lazy var dialButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("呼叫", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.sub_green()
        button.layer.cornerRadius = 20.0
        return button
    }()
}


extension CallNeighborView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DialCollectionViewCellCellIdentifier, for: indexPath) as? DialCollectionViewCell else {
            return UICollectionViewCell()
        }
        let str = dialButtonsStr[indexPath.row]
        cell.nameLabel.text = str
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialButtonsStr.count
    }

}

extension CallNeighborView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let str = dialButtonsStr[indexPath.row]
        var text = ""
        if let inputStr = inputFiled.text {
            text = inputStr + str
            inputFiled.text = text
        } else {
            inputFiled.text = str
        }
    }
}

extension CallNeighborView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: floor((frame.width - kMargin * 2) / 3), height: dialButtonHeight)
    }
}
