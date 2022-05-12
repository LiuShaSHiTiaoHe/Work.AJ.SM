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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
        dataSource = MineRepository.shared.getMineModules()
        contentView.tableView.reloadData()
    }
    
    override func initData() {
        contentView.avatar.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userProfileView)))
        contentView.messageButton.addTarget(self, action: #selector(showMessageView), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self

        NotificationCenter.default.addObserver(forName: .kUserUpdateAvatar, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            if let avatarDic = CacheManager.normal.fetchCachedWithKey(UserAvatarCacheKey), let avatarData = avatarDic.value(forKey: UserAvatarCacheKey) as? Data, let image = UIImage.init(data: avatarData) {
                self.contentView.avatar.image = image
            }
        }
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
    
    func loadUserProfile() {
        if let userInfo = HomeRepository.shared.getCurrentUser(), let name = userInfo.userName, let mobile = userInfo.mobile {
            contentView.nameLabel.text = name
            contentView.phoneLabel.text = mobile.jk.hidePhone()
            if let folderPath = userInfo.folderPath, let avatarUrl = userInfo.HeadImageUrl {
                contentView.avatar.kf.setImage(with: URL.init(string: (folderPath + avatarUrl).ajImageUrl()), placeholder: R.image.defaultavatar(), options: nil) { result in
                    switch result {
                       case .success(let value):
                        if let imageData = value.image.pngData() {
                            CacheManager.normal.saveCacheWithDictionary([UserAvatarCacheKey: imageData], key: UserAvatarCacheKey)
                        }
                       case .failure(let error):
                           print("Job failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @objc
    func showMessageView() {
        let vc = MessageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
                case .memeberManager:
                    let vc = MemberListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .visitorRecord:
                    let vc = VisitorRecordViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .setting:
                    let vc = SettingViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .opendoorSetting:
                    let vc = OpenDoorSettingViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .videoCall:
                    let vc = CallNeighborViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .activateCard:
                    break
                case .contactProperty:
                    let vc = PropertyContactViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                default:
                    break
                }
            }
        }
    }
    
    
}
