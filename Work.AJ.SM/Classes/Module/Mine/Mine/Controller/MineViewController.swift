//
//  MineViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/16.
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
        dataSource = MineRepository.shared.getMineModules()
        contentView.tableView.reloadData()
        contentView.messageButton.isHidden = HomeRepository.shared.isNoticeMessageEnable()
    }
    
    override func initData() {
        contentView.avatar.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userProfileView)))
        contentView.messageButton.addTarget(self, action: #selector(showMessageView), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        loadUserProfile()
        NotificationCenter.default.addObserver(forName: .kUserUpdateAvatar, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            if let avatarDic = CacheManager.normal.fetchCachedWithKey(UserAvatarCacheKey), let avatarData = avatarDic.value(forKey: UserAvatarCacheKey) as? Data, let image = UIImage.init(data: avatarData) {
                self.contentView.avatar.image = image
            }
        }
    }
    
    @objc
    private func userProfileView(){
        navigateTo(viewController: UserProfileViewController())
    }
    
    override func initUI() {
        addGradientLayer()
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
                            DispatchQueue.main.async {
                                CacheManager.normal.saveCacheWithDictionary([UserAvatarCacheKey: imageData], key: UserAvatarCacheKey)
                            }
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
        navigateTo(viewController: MessageViewController())
    }

}
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MineRepository.shared.getSectionCount(dataSource)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MineRepository.shared.getRowCount(section, dataSource)
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
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let module = MineRepository.shared.getSectionDataSource(indexPath, dataSource) {
            if let moduleType = MineModuleType.init(rawValue: module.name) {
                switch moduleType {
                case .house:
                    navigateTo(viewController: HouseViewController())
                case .faceCertification:
                    showModuleVersionControlTipsView(module: .FaceCetification) { [weak self] in
                        guard let `self` = self else { return }
                        self.navigateTo(viewController: FaceListViewController())
                    }
                case .memberManager:
                    navigateTo(viewController: MemberListViewController())
                case .visitorRecord:
                    navigateTo(viewController: VisitorRecordViewController())
                case .setting:
                    navigateTo(viewController: SettingViewController())
                case .opendoorSetting:
                    navigateTo(viewController: OpenDoorSettingViewController())
                case .videoCall:
                    showModuleVersionControlTipsView(module: .RemoteIntercom) { [weak self] in
                        guard let `self` = self else { return }
                        self.navigateTo(viewController: CallNeighborViewController())
                    }
                case .activateCard:
                    break
                case .contactProperty:
                    navigateTo(viewController: PropertyContactViewController())
                }
            }
        }
    }
    
    
}
