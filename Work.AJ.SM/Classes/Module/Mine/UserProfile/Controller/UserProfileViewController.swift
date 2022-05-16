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
import PGDatePicker
import SwiftUI

enum userProfileViewState {
    case display
    case edit
}

enum userProfilePickerType: String {
    case gender = "性别"
    case education = "学历"
    case profession = "职业"
}

enum userProfileInfoType: String {
    case nickName = "USERNAME"
    case birthDate = "BIRTHDATE"
    case gender = "SEX"
    case education = "EDUCATION"
    case profession = "JOB"
    case realName = "REALNAME"
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
    private var userMobile: String = ""
    
    private var avatar: UIImage?{
        didSet{
            if let _ = avatar {
                viewState = .edit
                contentView.tableView.reloadRow(at: IndexPath.init(row: 0, section: 0), with: .none)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userID = ud.userID {
            MineRepository.shared.getUserInfo(with: userID) { [weak self] errorMsg in
                guard let self = self else { return }
                if errorMsg.isEmpty {
                    self.loadData()
                }else{
                    SVProgressHUD.showError(withStatus: "数据错误")
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "数据错误")
            SVProgressHUD.dismiss(withDelay: 2){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func initData() {
        contentView.headerView.titleLabel.text = "个人信息"
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        picker.pickerView.dataSource = self
        picker.pickerView.delegate = self
        picker.delegate = self
    }
    
    private func loadData(){
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
            if let mobile = model.mobile {
                userMobile = mobile
            }
            contentView.tableView.reloadData()
        }else{
            SVProgressHUD.showError(withStatus: "数据错误")
            SVProgressHUD.dismiss(withDelay: 2) {
                self.navigationController?.popViewController(animated: true)
            }
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
            switch indexPath.row {
            case 0:
                cell.commonInput.text = userNickName
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
                cell.commonInput.text = userMobile
                cell.nameLabel.text = "手机号码"
                cell.accessoryType = .none
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
                userProfileInput(with: .nickName)
            case 1:
                showPicker(.gender)
            case 2:
                selectBirthDate()
            case 3:
                showPicker(.education)
            case 4:
                showPicker(.profession)
            case 5:
                userProfileInput(with: .realName)
            case 6:
                SVProgressHUD.showInfo(withStatus: "手机号码无法修改")
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
        config.wordings.next = "完成"
        //colors
        config.colors.tintColor = R.color.blackColor()!
        config.colors.defaultNavigationBarColor = R.color.themeColor()!
        config.colors.bottomMenuItemSelectedTextColor = R.color.themeColor()!
        config.colors.bottomMenuItemUnselectedTextColor = R.color.blackColor()!
        
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.didFinishPicking { items, _ in
            self.avatar = items.singlePhoto?.image
            picker.dismiss(animated: true) {
                self.updateAvater()
            }
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
            let pickedItem = UserProfileConstDefines.init().gender[pickerIndex]
            if pickedItem != userGender {
                userGender = pickedItem
                updateUserInfo(pickedItem, .gender)
            }
        case .education:
            let pickedItem = UserProfileConstDefines.init().education[pickerIndex]
            if pickedItem != userEducation {
                userEducation = pickedItem
                updateUserInfo(pickedItem, .education)
            }
        case .profession:
            let pickedItem = UserProfileConstDefines.init().profession[pickerIndex]
            if pickedItem != userProfession {
                userProfession = pickedItem
                updateUserInfo(pickedItem, .profession)
            }
        }
        contentView.tableView.reloadData()
        PopViewManager.shared.dissmiss {}
    }
        
    func showPicker(_ type: userProfilePickerType) {
        pickerType = type
        pickerIndex = 0
        picker.titleLabel.text = type.rawValue
        picker.pickerView.reloadAllComponents()
        picker.pickerView.selectRow(0, inComponent: 0, animated: true)
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

extension UserProfileViewController {
    func selectBirthDate() {
        let datePickerManager = PGDatePickManager.init()
        datePickerManager.isShadeBackground = true
        datePickerManager.style = .sheet
        datePickerManager.cancelButtonTextColor = R.color.errorRedColor()
        datePickerManager.confirmButtonTextColor = R.color.themeColor()
        let datePicker = datePickerManager.datePicker
        datePicker?.datePickerType = .line
        datePicker?.datePickerMode = .date
        datePicker?.language = "zh-Hans"
        datePickerManager.title = "生日"
        datePicker?.textColorOfSelectedRow = R.color.themeColor()
        datePicker?.textFontOfSelectedRow = k18Font
        datePicker?.lineBackgroundColor = R.color.themeColor()
        datePicker?.maximumDate = Date()
        datePicker?.selectedDate = {[weak self] dateComponents in
            guard let `self` = self else { return }
            if let dc = dateComponents, let selectDate = Calendar.current.date(from: dc) {
                let selectDateString = selectDate.jk.toformatterTimeString(formatter: "yyyy年MM月dd日")
                if selectDateString == self.userBirthDate {
                    return
                }
                self.userBirthDate = selectDateString
                self.updateUserInfo(selectDateString, .birthDate)
                self.contentView.tableView.reloadData()
            }
        }
        present(datePickerManager, animated: true) {}
    }
}

extension UserProfileViewController: UserProfileInputViewControllerDelegate {
    
    func userProfileInput(with type: UserProfileInputType) {
        let vc = UserProfileInputViewController()
        vc.type = type
        vc.delegate = self
        switch type {
        case .nickName:
            vc.value = userNickName
        case .realName:
            vc.value = userRealName
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func userProfileInput(_ value: String, _ type: UserProfileInputType) {
        switch type {
        case .nickName:
            if value == userNickName {
                return
            }
            userNickName = value
            updateUserInfo(userNickName, .nickName)
        case .realName:
            if value == userRealName {
                return
            }
            userRealName = value
            updateUserInfo(userRealName, .realName)
        }
        contentView.tableView.reloadData()
    }
}


extension UserProfileViewController {
    func updateUserInfo(_ infoValue: String, _ infoKey: userProfileInfoType) {
        if let userID = ud.userID {
            MineRepository.shared.updateUserInfo(with: userID, infoValue: infoValue, key: infoKey.rawValue) { [weak self] errorMsg in
                guard let self = self else { return }
                if errorMsg.isEmpty {
                    if let userInfo = HomeRepository.shared.getCurrentUser() {
                        RealmTools.updateWithTranstion { flag in
                            switch infoKey {
                            case .nickName:
                                userInfo.userName = infoValue
                            case .birthDate:
                                userInfo.birthdate = infoValue
                            case .gender:
                                userInfo.sex = infoValue
                            case .education:
                                userInfo.education = infoValue
                            case .profession:
                                userInfo.job = infoValue
                            case .realName:
                                userInfo.realName = infoValue
                            }
                        }
                    }
                    self.contentView.tableView.reloadData()
                }else{
                    SVProgressHUD.showError(withStatus: errorMsg)
                }
            }
        }
    }
    
    func updateAvater() {
        if let userID = ud.userID, let avatarData = avatar?.pngData() {
            MineRepository.shared.updateAvatar(with: userID, avatar: avatarData) { [weak self] errorMsg in
                guard let self = self else { return }
                if errorMsg.isEmpty {
                    CacheManager.normal.saveCacheWithDictionary([UserAvatarCacheKey: avatarData], key: UserAvatarCacheKey)
                    self.contentView.tableView.reloadData()
                    DispatchQueue.main.async {
                        SVProgressHUD.showInfo(withStatus: "上传用户头像成功")
                        NotificationCenter.default.post(name: .kUserUpdateAvatar, object: nil)
                    }
                }else{
                    SVProgressHUD.showError(withStatus: errorMsg)
                }
            }
        }
    }
}
