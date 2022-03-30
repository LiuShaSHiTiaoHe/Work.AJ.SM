//
//  UserProfileViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit
import SVProgressHUD

enum userProfileViewState {
    case display
    case edit
}

class UserProfileViewController: BaseViewController {

    private var viewState: userProfileViewState = .display
    private var userModel: UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func initData() {
        contentView.headerView.titleLabel.text = "个人信息"
        contentView.headerView.rightButton.setTitle("保存", for: .normal)
        contentView.headerView.rightButton.titleLabel?.font = k16Font
        contentView.headerView.rightButton.setTitleColor(R.color.whiteColor(), for: .normal)
        contentView.headerView.rightButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        if let model = HomeRepository.shared.getCurrentUser() {
            userModel = model
            contentView.tableView.reloadData()
        }else{
            SVProgressHUD.showError(withStatus: "数据错误")
            SVProgressHUD.dismiss(withDelay: 2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    private func save(){
        
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: UserProfileView = {
        let view = UserProfileView()
        return view
    }()

}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserAvatarCellIdentifier, for: indexPath) as! UserAvatarCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 4:
                break
            default:
                break
            }
            return cell
        default:
            fatalError("none cell index path")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
