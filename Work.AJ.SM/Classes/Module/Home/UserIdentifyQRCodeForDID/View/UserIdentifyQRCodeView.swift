//
//  UserIdentifyQRCodeView.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import UIKit

protocol UserIdentifyQRCodeViewDelegate: NSObjectProtocol {
    func close()
    func refresh()
}

class UserIdentifyQRCodeView: UIView {
    weak var delegate: UserIdentifyQRCodeViewDelegate?

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.common_back_white(), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()

    lazy var backImage: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = R.image.oqc_back_image()
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "身份码"
        view.font = k24Font
        view.textColor = R.color.whitecolor()
        return view
    }()

    lazy var keyImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.oqc_key_image()
        return view
    }()

    lazy var contentBack: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.whitecolor()
        view.layer.cornerRadius = 10.0
        return view
    }()

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = R.color.text_title()
        return view
    }()

    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = R.color.text_title()
        view.text = "请在开门/乘梯时展示此二维码"
        return view
    }()

    lazy var qrcodeView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.oqc_refresh_image(), for: .normal)
        button.setImage(R.image.oqc_refresh_image(), for: .highlighted)
        button.setTitle("刷新", for: .normal)
        button.setTitleColor(R.color.themecolor(), for: .normal)
        button.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }

    @objc
    func closeAction() {
        delegate?.close()
    }

    @objc
    func refreshAction() {
        delegate?.refresh()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeView() {
        backgroundColor = R.color.bg()

        addSubview(backImage)
        backImage.addSubview(closeButton)
        backImage.addSubview(titleLabel)
        backImage.addSubview(keyImage)

        addSubview(contentBack)
        contentBack.addSubview(nameLabel)
        contentBack.addSubview(tipsLabel)
        contentBack.addSubview(qrcodeView)
        contentBack.addSubview(refreshButton)

        backImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(224 * kHeightScale)
        }

        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(54)
            make.top.equalToSuperview().offset(90)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }

        keyImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-60)
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(126)
            make.height.equalTo(90)
        }

        contentBack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-kMargin * 2)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }

        tipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(30)
        }

        qrcodeView.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(kMargin)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(277 * kWidthScale)
        }

        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.equalTo(qrcodeView.snp.bottom).offset(kMargin * 2)
            make.centerX.equalToSuperview()
        }
    }

    func initData() {
        nameLabel.text = "业主您好"
    }
}
