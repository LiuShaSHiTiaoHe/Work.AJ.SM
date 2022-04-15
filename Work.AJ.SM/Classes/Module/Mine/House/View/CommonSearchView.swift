//
//  CommonSearchView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/7.
//

import UIKit

let ConstSearhViewHeight: CGFloat = 70.0

protocol CommonSearchViewDelegate: NSObjectProtocol {
    func cancelSearchAction()
}

extension CommonSearchViewDelegate {
    func cancelSearchAction() {}
}

class CommonSearchView: UIView {

    weak var delegate: CommonSearchViewDelegate?
    
    var placeHolder: String? {
        didSet {
            if let placeHolder = placeHolder {
                searchView.placeholder = placeHolder
            }
        }
    }
    
    var title: String? {
        didSet {
            if let title = title {
                titleButton.setTitle(title, for: .normal)
                titleButton.setImage(R.image.common_dowm_arrow_image(), for: .normal)
            }
        }
    }
    
    @objc
    func cancleAction() {
        searchView.resignFirstResponder()
        searchView.text = ""
        delegate?.cancelSearchAction()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.whiteColor()
        initializeView()
        cancleButton.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        self.addSubview(contentView)
        contentView.addSubview(titleButton)
        contentView.addSubview(separator)
        contentView.addSubview(iconImageView)
        contentView.addSubview(searchView)
        self.addSubview(cancleButton)
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(kMargin/2)
            make.right.equalToSuperview().offset(-kMargin/2)
        }
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.left.equalToSuperview().offset(10)
        }
        
        separator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleButton.snp.right)
            make.width.equalTo(1)
            make.height.equalTo(30)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
            make.left.equalToSuperview().offset(110)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(kMargin/2)
            make.right.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.right.equalToSuperview().offset(-kMargin/2)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
        
    func initViewType(_ isShowCancle: Bool) {
        if isShowCancle {
            titleButton.isHidden = true
            separator.isHidden = true
            cancleButton.isHidden = false
            contentView.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-80)
            }
            iconImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(kMargin)
            }
        }else{
            titleButton.isHidden = false
            separator.isHidden = false
            cancleButton.isHidden = true
            contentView.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-kMargin/2)
            }
            iconImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(110)
            }
        }
    }

    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var titleButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(R.color.maintextColor(), for: .normal)
        button.titleLabel?.font = k14Font
        return button
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.separateColor()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.common_search_image()
        return view
    }()
    
    lazy var searchView: UITextField = {
        let view = UITextField.init()
        view.font = k14Font
        view.textColor = R.color.blackColor()
        view.returnKeyType = .search
        return view
    }()
    
    lazy var cancleButton: UIButton = {
        let view = UIButton.init(type: .custom)
        view.setTitleColor(R.color.themeColor(), for: .normal)
        view.titleLabel?.font = k14Font
        view.setTitle("取消", for: .normal)
        return view
    }()
    


}
