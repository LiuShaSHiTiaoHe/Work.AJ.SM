//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit
import HanziPinyin

typealias HouseUpdateUnitsCompletion = ((_ errorMsg: String) -> Void)
typealias UnitMembersCompletion = (([MemberModel]) -> Void)
typealias HouseChooseCompletion = (([UnitModel]) -> Void)
typealias FaceListCompletion = (([FaceModel]) -> Void)
typealias DeleteFaceCompletion = ((_ errorMsg: String) -> Void)
typealias OwnerPasswordCompletion = ((_ errorMsg: String?) -> Void)

typealias CityListCompletion = ((Dictionary<String, Array<String>>) -> Void)
typealias CommunityListCompletion = (([CommunityModel]) -> Void)
typealias BlockListCompletion = (([BlockModel]) -> Void)


class MineRepository: NSObject {
    static let shared = MineRepository()

    func getAllUnits(completion: @escaping HouseUpdateUnitsCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            guard models.count > 0 else {
                completion("数据为空")
                return
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
            MineAPI.getUnitMembers(unitID: unitID, userID: userID).defaultRequest { jsonData in
                SVProgressHUD.dismiss()
                if let memberJsonString = jsonData["data"]["users"].rawString(), let members = [MemberModel](JSONString: memberJsonString) {
                    guard members.count > 0 else { return  }
                    completion(members)
                }
            } failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            }
        }else{
            completion([])
        }
    }
    
    func getMineModules() -> [MineModule] {
        if let unit = HomeRepository.shared.getCurrentUnit() {
            let allKeys = MineModuleType.allCases
            let allModules = allKeys.compactMap {  moduleEnum in
                return moduleEnum.model
            }
            if let otherUsed = unit.otherused, otherUsed == 1 {
                return allModules.filter{$0.isOtherUsed}
            }else{
                return allModules.filter {$0.tag == mineModuleType}
            }
        }
        return []
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
    
    func deleteFace(_ path: String, completion: @escaping DeleteFaceCompletion)  {
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

extension MineRepository {
    func setOwnerPassword(_ password: String, competion: @escaping OwnerPasswordCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let phone = ud.userMobile, let userID = ud.userID{
            MineAPI.ownerOpenDoorPassword(communityID: communityID, unitID: unitID, blockID: blockID, userID: userID, phone: phone, openDoorPassword: password).defaultRequest { jsonData in
                competion(nil)
            } failureCallback: { response in
                competion(response.message)
            }
        }else{
            competion("参数错误")
        }
    }
}

extension MineRepository {
    
    func getCommunityWithCityName(_ city: String, competion: @escaping CommunityListCompletion) {
        MineAPI.communitiesInCity(city: city).request(modelType: [CommunityModel].self) { data, response in
            competion(data)
        }
    }
    
    func getBlocksWithCommunityID(_ communityID: String, competion: @escaping BlockListCompletion) {
        MineAPI.blockInCommunity(communityID: communityID).request(modelType: [BlockModel].self) { data, response in
            competion(data)
        }

    }
    
    func getAllCity(competion: @escaping CityListCompletion) {
        MineAPI.allCity(encryptString: "").defaultRequest { jsonData in
            if let cityArray = jsonData["data"].arrayObject as? Array<Dictionary<String, String>> {
                competion(self.sortCityWithPY(cityArray))
            }else{
                competion([:])
            }
        } failureCallback: { response in
            competion([:])
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
                names.append(values)
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
