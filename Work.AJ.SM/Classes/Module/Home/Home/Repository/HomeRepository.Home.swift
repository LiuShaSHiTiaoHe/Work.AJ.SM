//
// Created by guguijun on 2022/6/22.
//

import Foundation

/*
 房屋状态：
 待审核 P, 失效 H, 过期 E, 正常 N, 停用 B
 */
enum UnitStatus: String {
    case Pending = "P"
    case Invalid = "H"
    case Expire = "E"
    case Normal = "N"
    case Blocked = "B"
    case Unknown = ""
}

extension HomeRepository {
    func homeData(completion: @escaping HomeDataCompletion) {
        SVProgressHUD.show()
        var homeModuleArray: Array<HomePageFunctionModule> = []
        var adsArray: Array<AdsModel> = []
        var noticeArray: Array<NoticeModel> = []
        guard let userMobile = ud.userMobile else {
            SVProgressHUD.dismiss()
            completion(homeModuleArray, adsArray, noticeArray, .Unknown)
            return
        }

        HomeAPI.getMyUnit(mobile: userMobile).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { [weak self] models, response in
            guard let `self` = self else {
                return
            }
            guard models.count > 0 else {
                completion(homeModuleArray, adsArray, noticeArray, .Unknown)
                return
            }
            RealmTools.addList(models, update: .all) {
                logger.info("update done")
            }
            var idAndStates: Array<(String, UnitStatus)> = Array<(String, UnitStatus)>()
            models.forEach { model in
                if let unitID = model.unitid?.jk.intToString {
                    if let unitState = model.state, let status = UnitStatus.init(rawValue: unitState) {
                        idAndStates.append((unitID, status))
                    } else {
                        idAndStates.append((unitID, .Unknown))
                    }
                }
            }
            
            if idAndStates.isEmpty {
                // MARK: - 没有有效的房间
                completion(homeModuleArray, adsArray, noticeArray, .Unknown)
            } else {
                // MARK: - 当前房间有效
                if let cUnitID = ud.currentUnitID, let _ = idAndStates.first(where: {$0.0 == cUnitID.jk.intToString && $0.1 == .Normal }),
                    let cUnit = models.first(where: {$0.unitid == cUnitID}) {
                    homeModuleArray = self.filterHomePageModules(cUnit)
                    self.adsAndNotice { ads, notices in
                        adsArray = ads
                        noticeArray = notices
                        completion(homeModuleArray, adsArray, noticeArray, .Normal)
                    }
                } else {
                    ud.remove(\.currentUnitID)
                    // MARK: - 取第一个有效的房屋
                    if let idAndStateNormal = idAndStates.first(where: {$0.1 == .Normal}),
                       let unit = models.first(where: {$0.unitid?.jk.intToString == idAndStateNormal.0}),
                       let unitID = unit.unitid {
                        ud.currentUnitID = unitID
                        homeModuleArray = self.filterHomePageModules(unit)
                        self.adsAndNotice { ads, notices in
                            adsArray = ads
                            noticeArray = notices
                            completion(homeModuleArray, adsArray, noticeArray, .Normal)
                        }
                    } else if let _ = idAndStates.first(where: {$0.1 == .Pending}) {
                        completion(homeModuleArray, adsArray, noticeArray, .Pending)
                    } else if let _ = idAndStates.first(where: {$0.1 == .Blocked}){
                       completion(homeModuleArray, adsArray, noticeArray, .Blocked)
                    } else if let _ = idAndStates.first(where: {$0.1 == .Expire}){
                        completion(homeModuleArray, adsArray, noticeArray, .Expire)
                    } else {
                        completion(homeModuleArray, adsArray, noticeArray, .Invalid)
                    }
                }
            }
        } failureCallback: { response in
            logger.info("\(response.message)")
            if response.code == 204 {
                ud.remove(\.currentUnitID)
                if let userID = ud.userID?.jk.toInt() {
                    RealmTools.deleteByPredicate(object: UnitModel.self, predicate: NSPredicate(format: "userid == %d", userID))
                }
            }
            completion(homeModuleArray, adsArray, noticeArray, .Unknown)
        }
    }

    func adsAndNotice(completion: @escaping HomeAdsAndNoticeCompletion) {
        var adsData: [AdsModel] = []
        var noticeData: [NoticeModel] = []
        if let unit = getCurrentUnit(), let operID = unit.operid?.jk.intToString, let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString {
            SVProgressHUD.show()
            let group = DispatchGroup()
            group.enter()
            HomeAPI.getAdvertisement(operID: operID, communityID: communityID).request(modelType: [AdsModel].self) { models, response in
                adsData.append(contentsOf: models)
                group.leave()
            } failureCallback: { response in
                group.leave()
            }
            group.enter()
            HomeAPI.getNotice(communityID: communityID, blockID: blockID, cellID: cellID).request(modelType: [NoticeModel].self) { models, response in
                noticeData.append(contentsOf: models)
                group.leave()
            } failureCallback: { response in
                group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                SVProgressHUD.dismiss()
                completion(adsData, noticeData)
            }
        } else {
            SVProgressHUD.dismiss()
            completion(adsData, noticeData)
        }
    }

    func getUnitName(unitID: Int) -> String {
        if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname, let blockname = unit.blockname, let unitno = unit.unitno {
            return communityname + blockname + cellname + unitno + "室"
        }
        return ""
    }

    func getCurrentUnit() -> UnitModel? {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first {
                return unit
            }
        }
        return nil
    }

    func getCurrentUnitName() -> String {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname {
                return communityname + cellname
            }
        }
        return ""
    }

    func getCurrentHouseName() -> String {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let cell = unit.cellname, let community = unit.communityname, let unitno = unit.unitno, let blockName = unit.blockname {
                return community + blockName + cell + unitno
            }
        }
        return ""
    }

    func getCurrentUser() -> UserModel? {
        if let userID = ud.userID, let _ = userID.jk.toInt() {
            if let user = RealmTools.objectsWithPredicate(object: UserModel(), predicate: NSPredicate.init(format: "rid == %@", userID)).first {
                return user
            }
        }
        return nil
    }

    func currentUserType() -> String {
        if let unit = getCurrentUnit(), let type = unit.usertype {
            return type
        }
        return ""
    }

    func isUnitOwner() -> Bool {
        if currentUserType() == "O" {
            return true
        }
        return false
    }
}

// MARK: - filter
extension HomeRepository {
    func filterHomePageModules(_ unit: UnitModel) -> [HomePageFunctionModule] {
        var result = [HomePageFunctionModule]()
        let allkeys = HomePageModule.allCases
        let allModules = allkeys.compactMap { moduleEnum in
            moduleEnum.model
        }
        if let otherused = unit.otherused, otherused == 1 {
            return allModules.filter {
                $0.tag == "OTHERUSED"
            }
        } else {
            let validModules = allValidModules(unit)
            allModules.forEach { module in
                if module.showinpage == .home, !module.tag.isEmpty {
                    if validModules.contains(module.tag) {
                        result.append(module)
                    }
                }
            }
            if isMemberManagementEnable(unit) {
                result.append(HomePageModule.addFamilyMember.model)
            }
        }
        return result
    }

    private func allValidModules(_ unit: UnitModel) -> [String] {
        var result: Array<String> = []
        if unit.moudle1 == "T" {
            result.append("MOUDLE1")
        }
        if unit.moudle2 == "T" {
            result.append("MOUDLE2")
        }
        if unit.moudle3 == "T" {
            result.append("MOUDLE3")
        }
        if unit.moudle4 == "T" {
            result.append("MOUDLE4")
        }
        if unit.moudle5 == "T" {
            result.append("MOUDLE5")
        }
        if unit.moudle6 == "T" {
            result.append("MOUDLE6")
        }
        if unit.moudle7 == "T" {
            result.append("MOUDLE7")
        }
        if unit.moudle8 == "T" {
            result.append("MOUDLE8")
        }
        if unit.moudle9 == "T" {
            result.append("MOUDLE9")
        }
        // FIXME: - 暂时隐藏蓝牙配置
        if let module10 = unit.moudle10, let mobile = unit.mobile, module10.contains(mobile) {
//            result.append("MOUDLE10")
        }
        if unit.moudle11 == "T" {
            result.append("MOUDLE11")
        }
        if unit.moudle12 == "T" {
            result.append("MOUDLE12")
        }
        // FIXME: - 暂时隐藏电梯配置
        if let module13 = unit.moudle13, let mobile = unit.mobile, module13.contains(mobile) {
//            result.append("MOUDLE13")
        }
        if unit.moudle14 == "T" {
            result.append("MOUDLE14")
        }
        if unit.moudle15 == "T" {
            result.append("MOUDLE15")
        }
        if unit.moudle16 == "T" {
            result.append("MOUDLE16")
        }
        // MARK: - module17访客二维码，myset7 开门密码,根据这两个判断是否显示邀请访客功能。若只有一个开启，则点击邀请访客后，只有二维码或者密码一个对应选项。
        if unit.moudle17 == "T" {
            result.append("MOUDLE17")
        } else {
            if isVisitorPasswordEnable(unit) {
                result.append("MOUDLE17")
            }
        }
        return result
    }
}

extension HomeRepository {
    // MARK: - 添加成员是否支持
    func isMemberManagementEnable(_ unit: UnitModel) -> Bool {
        // MARK: - 当前用户在当前房屋的角色是业主，有添加成员的功能
        if let myset11 = unit.myset11, myset11 == "T", let userType = unit.usertype, userType == "O" {
            return true
        }
        return false
    }

    // MARK: - 访客密码功能是否支持
    func isVisitorPasswordEnable(_ unit: UnitModel) -> Bool {
        if let myset7 = unit.myset7, myset7 == "T" {
            return true
        }
        return false
    }

    // MARK: - 访客二维码是否支持
    func isVisitorQrCodeEnable(_ unit: UnitModel) -> Bool {
        if let module17 = unit.moudle17, module17 == "T" {
            return true
        }
        return false
    }

    // MARK: - 是否允许访客呼叫到手机
    func isVisitorCallUserMobileEnable(_ unit: UnitModel) -> Bool {
        if let myset8 = unit.myset8, myset8 == "T" {
            return true
        }
        return false
    }

    // MARK: - 人脸认证是否支持
    func isFaceCertificationEnable(_ unit: UnitModel) -> Bool {
        if let myset1 = unit.myset1, myset1 == "T" {
            return true
        }
        return false
    }

    //MARK: - 开门设置是否支持
    func isOpenDoorSettingEnable(_ unit: UnitModel) -> Bool {
        if let myset6 = unit.myset6, myset6 == "T" {
            return true
        }
        return false
    }

    // MARK: - 访客记录是否支持
    func isVisitorRecordEnable(_ unit: UnitModel) -> Bool {
        if isVisitorPasswordEnable(unit) {
            return true
        }
        if isVisitorQrCodeEnable(unit) {
            return true
        }
        return false
    }

    // MARK: - 户户通是否支持
    func isCallOtherUserEnable(_ unit: UnitModel) -> Bool {
        if let myset2 = unit.myset2, myset2 == "T" {
            return true
        }
        return false
    }

    // MARK: - 联系物业是否支持
    func isContactPropertyEnable(_ unit: UnitModel) -> Bool {
        if let myset9 = unit.myset9, myset9 == "T" {
            return true
        }
        return false
    }

    // MARK: - 消息是否支持
    func isNoticeMessageEnable(_ unit: UnitModel? = nil) -> Bool {
        if let unit = unit {
            if let myset4 = unit.myset4, myset4 == "T" {
                return true
            }
        } else {
            if let unit = HomeRepository.shared.getCurrentUnit(), let myset4 = unit.myset4, myset4 == "T" {
                return true
            }
        }
        return false
    }
}
