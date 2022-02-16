//
//  IndoorCallElevatorView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

protocol IndoorCallElevatorViewDelegate: NSObjectProtocol {
    func callUpAction()
    func callDownAction()
    func closeAction()
}

class IndoorCallElevatorView: UIView {

    weak var delegate: IndoorCallElevatorViewDelegate?
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.ice_back_image()
        return view
    }()
    
    lazy var tipsView: UILabel = {
        let view = UILabel()
        view.text = "请选择电梯上行或下行"
        view.textColor = R.color.blackColor()
        view.textAlignment = .center
        view.font = k20Font
        return view
    }()
    
    lazy var upButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.ice_up_image(), for: .normal)
        button.setImage(R.image.ice_up_selected_image(), for: .selected)
        button.addTarget(self, action: #selector(callup), for: .touchUpInside)
        return button
    }()
    
    lazy var downButton: UIButton = {
        let button = UIButton.init(type: .custom)
//        button.setImage(R.image.ice_down_image(), for: .normal)
//        button.setImage(R.image.ice_down_selected_image(), for: .selected)
        button.setImage(R.image.ice_up_image(), for: .normal)
        button.setImage(R.image.ice_up_selected_image(), for: .selected)
        button.addTarget(self, action: #selector(calldown), for: .touchUpInside)
        return button
    }()
    
    @objc
    func callup() {
        delegate?.callUpAction()
        upButton.isSelected = true
    }
    
    @objc
    func calldown() {
        delegate?.callDownAction()
        downButton.isSelected = true
    }
    
    @objc
    func close() {
        delegate?.closeAction()
    }
    
    func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        
        self.addSubview(headerView)
        self.addSubview(imageView)
        self.addSubview(tipsView)
        self.addSubview(upButton)
        self.addSubview(downButton)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(90)
            make.width.equalTo(285)
            make.height.equalTo(218)
            make.centerX.equalToSuperview()
        }
        
        tipsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
            make.top.equalTo(imageView.snp.bottom).offset(kMargin)
        }
        
        upButton.snp.makeConstraints { make in
            make.width.height.equalTo(94)
            make.centerX.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview().offset(-45)
        }
        
        downButton.snp.makeConstraints { make in
            make.width.height.equalTo(94)
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.bottom.equalToSuperview().offset(-45)
        }
    }
    
    func initData() {
        headerView.titleLabel.text = "室内呼梯"
        headerView.rightButton.isHidden = true
        headerView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
