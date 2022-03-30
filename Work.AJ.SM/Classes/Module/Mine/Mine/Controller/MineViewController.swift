//
//  MineViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit

class MineViewController: BaseViewController {

    private var dataSource: [MineModule] = []
    
    lazy var contentView: MineView = {
        let view = MineView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        contentView.headerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userProfileView)))
        if let _ = ud.userID, let userInfo = HomeRepository.shared.getCurrentUser(), let name = userInfo.userName, let mobile = userInfo.mobile {
            contentView.nameLabel.text = name
            contentView.phoneLabel.text = mobile.jk.hidePhone()
            if let folderPath = userInfo.folderPath, let avatarUrl = userInfo.HeadImageUrl {
                contentView.avatar.kf.setImage(with: URL.init(string: (folderPath + avatarUrl).ajImageUrl()), placeholder: R.image.defaultavatar(), options: [.cacheOriginalImage]) { result in
                    switch result {
                    case .success(let value):
                        if let imageData = value.image.pngData() {
                            CacheManager.normal.saveCacheWithDictionary([UserAvatarCacheKey: imageData], key: UserAvatarCacheKey)
                        }
                    case .failure(_):
                        break
                    }
                    
                }
            }
        }
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        dataSource = MineRepository.shared.getMineModules()
        contentView.tableView.reloadData()
        
    }
    
    @objc
    private func userProfileView(){
        let vc = UserProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func initUI() {
        addlayer()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MineRepository.shared.getSectionCount(dataSource)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MineRepository.shared.getRowCount(section, dataSource)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCellIdentifier, for: indexPath) as! MineTableViewCell
        if let module = MineRepository.shared.getSectionDataSource(indexPath, dataSource) {
            cell.titleName = module.name
            cell.iconName = module.icon
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let module = MineRepository.shared.getSectionDataSource(indexPath, dataSource) {
            if let moduleType = MineModuleType.init(rawValue: module.name) {
                switch moduleType {
                case .house:
                    let vc = HouseViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .faceCertification:
                    let vc = FaceListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .memeberManager:                    
                    let vc = MemberListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .visitorRecord:
                    let vc = VisitorRecordViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .setting:
                    let vc = SettingViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .opendoorSetting:
                    let vc = OpenDoorSettingViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .passRecord:
                    break
                case .opendoorPassword:
                    break
                case .videoCall:
                    break
                case .activateCard:
                    break
                }
            }
        }
    }
    
    
}
