//
//  UserProfileViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/29.
//

import UIKit
import SVProgressHUD
import YPImagePicker
import SwiftEntryKit

enum userProfileViewState {
    case display
    case edit
}

enum userProfilePickerType: String {
    case gender = "性别"
    case education = "学历"
    case profession = "职业"
}

class UserProfileViewController: BaseViewController {

    private var viewState: userProfileViewState = .display
    private var userModel: UserModel?
    private var pickerType: userProfilePickerType = .gender
    private var pickerIndex: Int = 0
    private lazy var picker: CommonPickerView = {
        let view = CommonPickerView.init()
        return view
    }()
    private var userNickName: String = ""
    private var userBirthDate: String = "暂无"
    private var userGender: String = "暂无"
    private var userEducation: String = "暂无"
    private var userProfession: String = "暂无"
    private var userRealName: String = "暂无"
    
    private var avatar: UIImage?{
        didSet{
            if let _ = avatar {
                viewState = .edit
                self.contentView.tableView.reloadRow(at: IndexPath.init(row: 0, section: 0), with: .none)
            }
        }
    }
    
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
        
        picker.pickerView.dataSource = self
        picker.pickerView.delegate = self
        picker.delegate = self
        
        if let model = HomeRepository.shared.getCurrentUser() {
            userModel = model
            if let nickName = model.userName {
                userNickName = nickName
            }
            if let gender = model.sex {
                userGender = gender
            }
            if let birth = model.birthdate {
                userBirthDate = birth
            }
            if let education = model.education {
                userEducation = education
            }
            if let profession = model.job {
                userProfession = profession
            }
            if let realname = model.realName {
                userRealName = realname
            }
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
        if viewState == .display {
            closeAction()
        }else{
            
        }
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
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserAvatarCellIdentifier, for: indexPath) as! UserAvatarCell
            if let avatar = avatar {
                cell.avatar.image = avatar
            }else{
                if let avatarDic = CacheManager.normal.fetchCachedWithKey(UserAvatarCacheKey), let avatarData = avatarDic.value(forKey: UserAvatarCacheKey) as? Data, let image = UIImage.init(data: avatarData) {
                    cell.avatar.image = image
                }else{
                    cell.avatar.image = R.image.defaultavatar()
                }
            }
            cell.nameLabel.text = "头像"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCellIdentifier, for: indexPath) as! CommonInputCell
            cell.commonInput.isUserInteractionEnabled = false
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            if let userInfo = userModel {                
                switch indexPath.row {
                case 0:
                    if let nickName = userInfo.userName {
                        cell.commonInput.text = nickName
                    }
                    cell.nameLabel.text = "昵称"
                    break
                case 1:
                    cell.commonInput.text = userGender
                    cell.nameLabel.text = "性别"
                    break
                case 2:
                    cell.commonInput.text = userBirthDate
                    cell.nameLabel.text = "生日"
                    break
                case 3:
                    cell.commonInput.text = userEducation
                    cell.nameLabel.text = "学历"
                    break
                case 4:
                    cell.commonInput.text = userProfession
                    cell.nameLabel.text = "职业"
                    break
                case 5:
                    cell.commonInput.text = userRealName
                    cell.nameLabel.text = "真实姓名"
                    break
                case 6:
                    if let mobileNumber = userInfo.mobile {
                        cell.commonInput.text = mobileNumber
                    }
                    cell.nameLabel.text = "手机号码"
                    cell.accessoryType = .none
                    break
                default:
                    break
                }
            }
            
            return cell
        default:
            fatalError("none cell index path")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        }
        return 60.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            showImagePicker()
        case 1:
            switch indexPath.row {
            case 0:
                break
            case 1:
                showPicker(.gender)
            case 2:
                break
            case 3:
                showPicker(.education)
            case 4:
                showPicker(.profession)
            case 5:
                break
            case 6:
                SVProgressHUD.showInfo(withStatus: "手机号码无法修改")
                break
            default:
                break
            }
        default:
            break
        }
    }
}

extension UserProfileViewController: YPImagePickerDelegate {
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {}
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
    
    func showImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        config.gallery.hidesRemoveButton = false
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.showsPhotoFilters = false
        //colors
        config.colors.tintColor = R.color.whiteColor()!
        config.colors.defaultNavigationBarColor = R.color.themeColor()!
        config.colors.bottomMenuItemSelectedTextColor = R.color.themeColor()!
        config.colors.bottomMenuItemUnselectedTextColor = R.color.blackColor()!
        
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.didFinishPicking { items, _ in
            self.avatar = items.singlePhoto?.image
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension UserProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource, CommonPickerViewDelegate {

    func pickerCancel() {
        PopViewManager.shared.dissmiss {}
    }
    
    func pickerConfirm() {
        viewState = .edit
        switch pickerType {
        case .gender:
            userGender = UserProfileConstDefines.init().gender[pickerIndex]
        case .education:
            userEducation = UserProfileConstDefines.init().education[pickerIndex]
        case .profession:
            userProfession = UserProfileConstDefines.init().profession[pickerIndex]
        }
        PopViewManager.shared.dissmiss {}
    }
        
    func showPicker(_ type: userProfilePickerType) {
        pickerType = type
        pickerIndex = 0
        picker.titleLabel.text = type.rawValue
        picker.pickerView.reloadAllComponents()
        PopViewManager.shared.display(picker, .bottom, .init(width: .constant(value: kScreenWidth), height: .constant(value: 300)))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .gender:
            return UserProfileConstDefines.init().gender[row]
        case .education:
            return UserProfileConstDefines.init().education[row]
        case .profession:
            return UserProfileConstDefines.init().profession[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .gender:
            return UserProfileConstDefines.init().gender.count
        case .education:
            return UserProfileConstDefines.init().education.count
        case .profession:
            return UserProfileConstDefines.init().profession.count
        }
    }
    
}
