//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import SVProgressHUD

typealias UnitMembersCompletion = ([MemberModel]) -> Void
typealias HouseChooseCompletion = ([UnitModel]) -> Void
typealias FaceListCompletion = ([FaceModel]) -> Void
typealias ExtraFaceFileCompletion = ([ExtralFaceModel]) -> Void
typealias CityListCompletion = (Dictionary<String, Array<String>>, Array<String>) -> Void
typealias CommunityListCompletion = ([CommunityModel]) -> Void
typealias BlockListCompletion = ([BlockModel]) -> Void
typealias CellListCompletion = ([CellModel]) -> Void
typealias UnitInCellListCompletion = ([UserUnitModel]) -> Void
typealias VisitorListCompletion = ([VisitorModel]) -> Void
typealias MyUnitGuestCompletion = ([UnitGuestModel]) -> Void
typealias PropertyContactCompletion = ([PropertyContactModel]) -> Void
typealias MessagesCompletion = ([MessageModel]) -> Void
typealias CallNeighborFindUnitCompletion = ([String], String) -> Void
typealias UserDoNotDisturbStatusCompletion = (Bool) -> Void


class MineRepository: NSObject {
    static let shared = MineRepository()

    func getAllUnits(completion: @escaping DefaultCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            guard models.count > 0 else {
                completion("数据为空")
                return
            }
            if let _ = Defaults.currentUnitID {

            } else {
                if let firstUnit = models.first(where: { model in
                    model.state == "N"
                }), let unitID = firstUnit.unitid {
                    Defaults.currentUnitID = unitID
                }
            }

            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }
            completion("")
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion(response.message)
        }
    }

    func getAllSelectableUnit(completion: @escaping HouseChooseCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            guard models.count > 0 else {
                completion([])
                return
            }
            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }

            completion(models.filter { unit in
                if let state = unit.state {
                    return state == "N"
                } else {
                    return false
                }
            })
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion([])
        }
    }

    func getCurrentUnitMembers(completion: @escaping UnitMembersCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let userID = unit.userid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            SVProgressHUD.show()
            MineAPI.getUnitMembers(unitID: unitID, userID: userID).defaultRequest(cacheType: .ignoreCache, showError: true, successCallback: { jsonData in
                SVProgressHUD.dismiss()
                if let memberJsonString = jsonData["data"]["users"].rawString(), let members = [MemberModel](JSONString: memberJsonString) {
                    guard members.count > 0 else {
                        return
                    }
                    completion(members)
                }
            }, failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            })
        } else {
            completion([])
        }
    }

    func deleteUnitMember(memberID: String, completion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let userID = unit.userid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            MineAPI.deleteMember(unitID: unitID, userID: userID, memberUserID: memberID).defaultRequest(cacheType: .ignoreCache, showError: false, successCallback: { jsonData in
                completion("")
            }, failureCallback: { response in
                logger.info("\(response.message)")
                completion(response.message)
            })
        }
    }

    func getMineModules() -> [MineModule] {
        if let unit = HomeRepository.shared.getCurrentUnit() {
            let allKeys = MineModuleType.allCases
            var allModules = allKeys.compactMap { moduleEnum in
                return moduleEnum.model
            }
            // MARK: - 业主有权限查看房屋成员
            if !HomeRepository.shared.isMemberManagementEnable(unit) {
                allModules = allModules.filter {
                    $0.name != MineModuleType.memberManager.rawValue
                }
            }
            // MARK: - 没有邀请访客模块。隐藏访客记录
            if !HomeRepository.shared.isVisitorRecordEnable(unit) {
                allModules = allModules.filter {
                    $0.name != MineModuleType.visitorRecord.rawValue
                }
            }
            // MARK: - 判断是否支持人脸认证
            if !HomeRepository.shared.isFaceCertificationEnable(unit) {
                allModules = allModules.filter {
                    $0.name != MineModuleType.faceCertification.rawValue
                }
            }
            // MARK: - 是否支持户户通
            if !HomeRepository.shared.isCallOtherUserEnable(unit) {
                allModules = allModules.filter {
                    $0.name != MineModuleType.videoCall.rawValue
                }
            }
            // MARK: - 是否支持呼叫物业
            if !HomeRepository.shared.isContactPropertyEnable(unit) {
                allModules = allModules.filter {
                    $0.name != MineModuleType.contactProperty.rawValue
                }
            }
            // MARK: - 暂时不支持激活蓝牙卡
            allModules = allModules.filter {
                $0.name != MineModuleType.activateCard.rawValue
            }


            if let otherUsed = unit.otherused, otherUsed == 1 {
                return allModules.filter {
                    $0.isOtherUsed
                }
            } else {
                return allModules.filter {
                    $0.tag == mineModuleType
                }
            }
        }
        return [MineModuleType.house.model, MineModuleType.setting.model]
    }

    func getSectionCount(_ modules: [MineModule]) -> Int {
        var destination: Set<MineModuleDestination> = []
        modules.forEach { model in
            destination.insert(model.destination)
        }
        return destination.count
    }

    func getRowCount(_ section: Int, _ modules: [MineModule]) -> Int {
        switch section {
        case 0:
            return modules.filter {
                        $0.destination == .mine_0
                    }
                    .count
        case 1:
            return modules.filter {
                        $0.destination == .mine_1
                    }
                    .count
        case 2:
            return modules.filter {
                        $0.destination == .mine_2
                    }
                    .count
        default:
            return 0
        }
    }

    func getSectionDataSource(_ indexPath: IndexPath, _ modules: [MineModule]) -> MineModule? {
        switch indexPath.section {
        case 0:
            return modules.filter {
                        $0.destination == .mine_0
                    }
                    .sorted {
                        $0.index < $1.index
                    }[indexPath.row]
        case 1:
            return modules.filter {
                        $0.destination == .mine_1
                    }
                    .sorted {
                        $0.index < $1.index
                    }[indexPath.row]
        case 2:
            return modules.filter {
                        $0.destination == .mine_2
                    }
                    .sorted {
                        $0.index < $1.index
                    }[indexPath.row]
        default:
            return nil
        }
    }

}


// MARK: - 用户信息
extension MineRepository {

    func getUserInfo(with userID: String, completion: @escaping DefaultCompletion) {
        MineAPI.getUserInfo(userID: userID).defaultRequest(cacheType: .ignoreCache, showError: false) { jsonData in
            if let userInfo = jsonData["data"].rawString(), let userModel = UserModel(JSONString: userInfo) {
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                RealmTools.add(userModel, update: .modified) {
                }
                completion("")
            }
        } failureCallback: { response in
            completion(response.message)
        }
    }


    func updateUserInfo(with userID: String, infoValue: String, key: String, completion: @escaping DefaultCompletion) {
        SVProgressHUD.show()
        MineAPI.updateUserInfo(userID: userID, infoValue: infoValue, InfoKey: key).defaultRequest { jsonData in
            SVProgressHUD.dismiss()
            completion("")
        } failureCallback: { response in
            completion(response.message)
        }
    }

    func updateAvatar(with userID: String, avatar: Data, completion: @escaping DefaultCompletion) {
        SVProgressHUD.show()
        MineAPI.updateAvatar(userID: userID, avatarData: avatar).defaultRequest { jsonData in
            SVProgressHUD.dismiss()
            completion("")
        } failureCallback: { response in
            completion(response.message)
        }
    }
}


// MARK: - 访客
extension MineRepository {
    func getMyVisitors(userID: String, unitID: String, completion: @escaping VisitorListCompletion) {
        SVProgressHUD.show()
        MineAPI.myVisitors(userID: userID, unitID: unitID).request(modelType: [VisitorModel].self) { models, response in
            SVProgressHUD.dismiss()
            completion(models)
        } failureCallback: { response in
            completion([])
        }
    }

    func getMyUnitGuest(userID: String, unitID: String, page: String, size: String, completion: @escaping MyUnitGuestCompletion) {
        SVProgressHUD.show()
        MineAPI.getMyUnitGuest(userID: userID, unitID: unitID, currentPage: page, showCount: size).request(modelType: [UnitGuestModel].self, cacheType: .ignoreCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            completion(models)
        } failureCallback: { response in
            completion([])
        }
    }
}

// MARK: - 人脸识别
extension MineRepository {
    func getFaceList(completion: @escaping FaceListCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            SVProgressHUD.show()
            MineAPI.allFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID).request(modelType: [FaceModel].self) { models, response in
                SVProgressHUD.dismiss()
                completion(models)
            } failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            }
        } else {
            completion([])
        }
    }


    func addFace(_ data: AddFaceModel, completion: @escaping DefaultCompletion) {
        if data.faceData.isEmpty {
            completion("人脸数据完整性错误")
        } else {
            SVProgressHUD.show(withStatus: "上传人脸数据中...")
            MineAPI.addFace(data: data).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        }
    }

    func deleteFace(_ path: String, _ faceID: String, completion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            SVProgressHUD.show()
            MineAPI.deleteFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, imagePath: path, faceID: faceID).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        } else {
            completion("数据完整性错误")
        }
    }

    func getExtraFace(completion: @escaping ExtraFaceFileCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let mobile = ud.userMobile {
            MineAPI.extraFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, mobile: mobile).request(modelType: [ExtralFaceModel].self, cacheType: .ignoreCache, showError: true) { models, response in
                completion(models)
            } failureCallback: { response in
                completion([])
            }
        } else {
            completion([])
        }
    }

    func syncExtraFace(completion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let mobile = ud.userMobile {
            MineAPI.syncExtraFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, mobile: mobile).defaultRequest(cacheType: .ignoreCache, showError: true) { jasonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        } else {
            completion("数据错误")
        }
    }
}

// MARK: - 用户二维码
extension MineRepository {
    func setOwnerPassword(_ password: String, competion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let phone = ud.userMobile, let userID = ud.userID {
            MineAPI.ownerOpenDoorPassword(communityID: communityID, unitID: unitID, blockID: blockID, userID: userID, phone: phone, openDoorPassword: password).defaultRequest { jsonData in
                competion("")
            } failureCallback: { response in
                competion(response.message)
            }
        } else {
            competion("参数错误")
        }
    }
}

// MARK: - 房屋
extension MineRepository {

    func searchCommunity(with name: String, completion: @escaping CommunityListCompletion) {
        MineAPI.searchUnit(name: name).request(modelType: [CommunityModel].self, cacheType: .ignoreCache, showError: true) { datas, response in
            completion(datas)
        } failureCallback: { response in
            completion([])
        }
    }

    func getCommunityWithCityName(_ city: String, completion: @escaping CommunityListCompletion) {
        MineAPI.communitiesInCity(city: city).request(modelType: [CommunityModel].self, showError: true) { data, response in
            completion(data)
        } failureCallback: { response in
            completion([])
        }
    }

    func getBlocksWithCommunityID(_ communityID: String, completion: @escaping BlockListCompletion) {
        MineAPI.blockInCommunity(communityID: communityID).request(modelType: [BlockModel].self, showError: true) { data, response in
            completion(data)
        } failureCallback: { response in
            completion([])
        }
    }

    func getCellsWithBlockID(_ blockID: String, completion: @escaping CellListCompletion) {
        MineAPI.cellInBlock(blockID: blockID).request(modelType: [CellModel].self, showError: true) { data, response in
            completion(data)
        } failureCallback: { response in
            completion([])
        }
    }

    func getUnitWithBlockIDAndCellID(_ blockID: String, _ cellID: String, completion: @escaping UnitInCellListCompletion) {
        MineAPI.unitInCell(blockID: blockID, cellID: cellID).request(modelType: [UserUnitModel].self, showError: true) { data, response in
            completion(data)
        } failureCallback: { response in
            completion([])
        }
    }


    func getAllCity(completion: @escaping CityListCompletion) {
        MineAPI.allCity(encryptString: "").defaultRequest { jsonData in
            if let cityArray = jsonData["data"].arrayObject as? Array<Dictionary<String, String>> {
                completion(self.sortCityWithPY(cityArray), cityArray.compactMap({ item in
                    item["CITY"]
                }))
            } else {
                completion([:], [])
            }
        } failureCallback: { response in
            completion([:], [])
        }
    }

    private func sortCityWithPY(_ dataSource: Array<Dictionary<String, String>>) -> Dictionary<String, Array<String>> {
        var result = Dictionary<String, Array<String>>()
        let cityNames = dataSource.compactMap { item in
            item["CITY"]
        }

        cityNames.forEach { name in
            let firstLetter = findFirstLetterFromString(aString: name)
            if result.has(firstLetter), let values = result[firstLetter] {
                var names = Array<String>()
                names.append(contentsOf: values)
                names.append(name)
                result.updateValue(names, forKey: firstLetter)
            } else {
                result.updateValue([name], forKey: firstLetter)
            }
        }
        return result
    }

    //获取拼音首字母（大写字母）
    func findFirstLetterFromString(aString: String) -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: aString)
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        //去掉声调
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        //将拼音首字母换成大写
        let strPinYin = polyphonyStringHandle(nameString: aString, pinyinString: pinyinString).uppercased()
        //截取大写首字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }

    //多音字处理，根据需要添自行加
    func polyphonyStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {
            return "chang"
        }
        if nameString.hasPrefix("沈") {
            return "shen"
        }
        if nameString.hasPrefix("厦") {
            return "xia"
        }
        if nameString.hasPrefix("地") {
            return "di"
        }
        if nameString.hasPrefix("重") {
            return "chong"
        }
        return pinyinString
    }
}

extension MineRepository {

    // MARK: - 获取物业联系方式
    func getPropertyContact(completion: @escaping PropertyContactCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString {
            MineAPI.propertyContactList(communityID: communityID).request(modelType: [PropertyContactModel].self, cacheType: .ignoreCache, showError: false) { models, response in
                completion(models)
            } failureCallback: { response in
                completion([])
            }
        }
    }

    // MARK: - 获取消息列表
    func getMessages(userID: String, page: String, size: String, completion: @escaping MessagesCompletion) {
        MineAPI.getUserMessageList(userID: userID, currentPage: page, showCount: size).request(modelType: [MessageModel].self, cacheType: .ignoreCache, showError: true) { models, response in
            completion(models)
        } failureCallback: { response in
            completion([])
        }
    }

}

extension MineRepository {
    // MARK: - 户户通
    func validationNumber(completion: @escaping CallNeighborFindUnitCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockNo = unit.blockno, let unitNo = unit.unitno, let cellID = unit.cellid?.jk.intToString {
            MineAPI.findUnitAvailable(communityID: communityID, blockNo: blockNo, unitNo: unitNo, cellID: cellID).defaultRequest(cacheType: .ignoreCache, showError: true) { jsonData in
                if let dataDic = jsonData["data"].dictionaryObject {
                    var macString = ""
                    var mobiles: [String] = []
                    if let locks = dataDic["LOCKS"] as? Array<Dictionary<String, Any>> {
                        if locks.count > 0 {
                            let macDic = locks[0]
                            if let lockMac = macDic["LOCKMAC"] as? String {
                                macString = lockMac
                            }
                        }
                    }
                    if let mobilesString = dataDic["CALLORDERMOBILE"] as? String {
                        mobiles = mobilesString.components(separatedBy: "|")
                    }
                    completion(mobiles, macString)
                }
            } failureCallback: { response in
                completion([], "")
            }
        }
    }

    // MARK: - 获取勿扰状态，也就是允许访客呼叫到手机设置的状态
    func getUserDoNotDisturbStatus(completion: @escaping UserDoNotDisturbStatusCompletion) {
        if let userID = ud.userID {
            MineAPI.getUserDoNotDisturbStatus(userID: userID).defaultRequest(cacheType: .ignoreCache, showError: false) { jsonData in
                if let dataArray = jsonData["data"].array {
                    if !dataArray.isEmpty {
                        if let dataDic = dataArray[0].dictionaryObject, let status = dataDic["STATUS"] as? String {
                            if status == "T" {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        } else {
                            completion(false)
                        }
                    } else {
                        completion(false)
                    }
                }
            } failureCallback: { response in
                completion(false)
            }
        }
    }

    func updateUserDoNotDisturbStatus(_ state: String, completion: @escaping DefaultCompletion) {
        if let userID = ud.userID {
            MineAPI.updateNotificationStatus(userID: userID, status: state).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        } else {
            completion("数据错误")
        }
    }
}
