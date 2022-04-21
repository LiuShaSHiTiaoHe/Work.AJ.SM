//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import SVProgressHUD

typealias UnitMembersCompletion = (([MemberModel]) -> Void)
typealias HouseChooseCompletion = (([UnitModel]) -> Void)
typealias FaceListCompletion = (([FaceModel]) -> Void)
typealias CityListCompletion = ((Dictionary<String, Array<String>>, Array<String>) -> Void)
typealias CommunityListCompletion = (([CommunityModel]) -> Void)
typealias BlockListCompletion = (([BlockModel]) -> Void)
typealias CellListCompletion = (([CellModel]) -> Void)
typealias UnitInCellListCompletion = (([UserUnitModel]) -> Void)
typealias VisitorListCompletion = (([VisitorModel]) -> Void)
typealias MyUnitGuestCompletion = (([UnitGuestModel]) -> Void)


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
            
            }else{
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
                }else{
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
                    guard members.count > 0 else { return  }
                    completion(members)
                }
            }, failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            })
        }else{
            completion([])
        }
    }
    
    func deleteUnitMember(memberID: String, completion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let userID = unit.userid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            MineAPI.deleteMember(unitID: unitID, userID: userID, memberUserID: memberID).defaultRequest(cacheType: .ignoreCache, showError: false, successCallback:{ jsonData in
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
            var allModules = allKeys.compactMap {  moduleEnum in
                return moduleEnum.model
            }
            // MARK: - 业主有权限查看房屋成员
            if !GDataManager.shared.isOwner() {
                allModules = allModules.filter { $0.name != MineModuleType.memeberManager.rawValue }
            }
            if let otherUsed = unit.otherused, otherUsed == 1 {
                return allModules.filter{$0.isOtherUsed}
            }else{
                return allModules.filter {$0.tag == mineModuleType}
            }
        }
        return [MineModuleType.house.model, MineModuleType.setting.model]
    }
    
    func getSectionCount(_ modules: [MineModule]) -> Int {
        var destination:Set<MineModuleDestination> = []
        modules.forEach { model in
            destination.insert(model.destination)
        }
        return destination.count
    }
    
    func getRowCount(_ section: Int, _ modules: [MineModule]) -> Int {
        switch section {
        case 0:
            return modules.filter{$0.destination == .mine_0}.count
        case 1:
            return modules.filter{$0.destination == .mine_1}.count
        default:
            return 0
        }
    }
    
    func getSectionDataSource(_ indexPath: IndexPath, _ modules: [MineModule]) -> MineModule? {
        switch indexPath.section {
        case 0:
            return modules.filter{$0.destination == .mine_0}.sorted { $0.index < $1.index}[indexPath.row]
        case 1:
            return modules.filter{$0.destination == .mine_1}.sorted { $0.index < $1.index}[indexPath.row]
        default:
            return nil
        }
    }
    
}

// MARK: - 用户信息
extension MineRepository {
    
    func getUserInfo(with userID: String, completion: @escaping DefaultCompletion) {
        SVProgressHUD.show()
        MineAPI.getUserInfo(userID: userID).defaultRequest(cacheType: .ignoreCache, showError: false) { jsonData in
            SVProgressHUD.dismiss()
            if let userInfo = jsonData["data"].rawString(), let userModel = UserModel(JSONString: userInfo) {
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                RealmTools.add(userModel, update: .modified) {}
                completion("")
            }
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    
    func updateUserInfo(with userID: String,  infoValue: String, key: String, completion: @escaping DefaultCompletion) {
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
    
    func getMyUnitGuset(userID: String, unitID: String, page: String, size: String, completion: @escaping MyUnitGuestCompletion) {
        SVProgressHUD.show()
        MineAPI.getMyUnitGuest(userID: userID, unitID: unitID, currentPage: page, showCount: size).request(modelType: [UnitGuestModel].self , cacheType: .ignoreCache, showError: true) { models, response in
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
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString{
            SVProgressHUD.show()
            MineAPI.allFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID).request(modelType: [FaceModel].self) { models, response in
                SVProgressHUD.dismiss()
                completion(models)
            } failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            }
        }else {
            completion([])
        }
    }
    

    func addFace(_ data: AddFaceModel, completion: @escaping DefaultCompletion) {
        if data.faceData.isEmpty {
            completion("人脸数据完整性错误")
        }else{
            SVProgressHUD.show(withStatus: "上传人脸数据中...")
            MineAPI.addFace(data: data).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        }
    }
    func deleteFace(_ path: String, completion: @escaping DefaultCompletion)  {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString{
            SVProgressHUD.show()
            MineAPI.deleteFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, imagePath: path).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        }else {
            completion("数据完整性错误")
        }
    }
}

// MARK: - 用户二维码
extension MineRepository {
    func setOwnerPassword(_ password: String, competion: @escaping DefaultCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let phone = ud.userMobile, let userID = ud.userID{
            MineAPI.ownerOpenDoorPassword(communityID: communityID, unitID: unitID, blockID: blockID, userID: userID, phone: phone, openDoorPassword: password).defaultRequest { jsonData in
                competion("")
            } failureCallback: { response in
                competion(response.message)
            }
        }else{
            competion("参数错误")
        }
    }
}

// MARK: - 房屋
extension MineRepository {
    
    func searchCommunity(with name: String, competion: @escaping CommunityListCompletion) {
        MineAPI.searchUnit(name: name).request(modelType: [CommunityModel].self, cacheType: .ignoreCache, showError: true) { datas, response in
            competion(datas)
        } failureCallback: { response in
            competion([])
        }
    }
    
    func getCommunityWithCityName(_ city: String, competion: @escaping CommunityListCompletion) {
        MineAPI.communitiesInCity(city: city).request(modelType: [CommunityModel].self, showError: true) { data, response in
            competion(data)
        } failureCallback: { response in
            competion([])
        }
    }
    
    func getBlocksWithCommunityID(_ communityID: String, competion: @escaping BlockListCompletion) {
        MineAPI.blockInCommunity(communityID: communityID).request(modelType: [BlockModel].self, showError: true) { data, response in
            competion(data)
        } failureCallback: { response in
            competion([])
        }
    }
    
    func getCellsWithBlockID(_ blockID: String, competion: @escaping CellListCompletion){
        MineAPI.cellInBlock(blockID: blockID).request(modelType: [CellModel].self, showError: true) { data, response in
            competion(data)
        } failureCallback: { response in
            competion([])
        }
    }
    
    func getUnitWithBlockIDAndCellID(_ blockID: String, _ cellID: String, competion: @escaping UnitInCellListCompletion) {
        MineAPI.unitInCell(blockID: blockID, cellID: cellID).request(modelType: [UserUnitModel].self, showError: true) { data, response in
            competion(data)
        } failureCallback: { response in
            competion([])
        }
    }
    
    
    
    func getAllCity(competion: @escaping CityListCompletion) {
        MineAPI.allCity(encryptString: "").defaultRequest { jsonData in
            if let cityArray = jsonData["data"].arrayObject as? Array<Dictionary<String, String>> {
                competion(self.sortCityWithPY(cityArray), cityArray.compactMap({ item in
                    item["CITY"]
                }))
            }else{
                competion([:], [])
            }
        } failureCallback: { response in
            competion([:], [])
        }
    }
    
    private func sortCityWithPY(_ dataSource: Array<Dictionary<String, String>>) -> Dictionary<String, Array<String>> {
        var result = Dictionary<String, Array<String>>()
        let cityNames = dataSource.compactMap { item in
            item["CITY"]
        }
        
        cityNames.forEach { name in
            let firstLetter = self.findFirstLetterFromString(aString: name)
            if result.has(firstLetter), let values = result[firstLetter] {
                var names = Array<String>()
                names.append(contentsOf: values)
                names.append(name)
                result.updateValue(names, forKey: firstLetter)
            }else{
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
        let strPinYin = polyphoneStringHandle(nameString: aString, pinyinString: pinyinString).uppercased()
        //截取大写首字母
        let firstString = strPinYin.substring(to:strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }

    //多音字处理，根据需要添自行加
    func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString
    }
}
