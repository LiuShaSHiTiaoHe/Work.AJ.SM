//
//  ModuleByVersion.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/7/22.
//

import Foundation
import ObjectMapper


enum ModulesOfModuleStatus: String {
    case ScanQR = "scanQR"
    case AddMember = "addMember"
    case AddUnit = "addUnit"
    case FaceCertification = "faceCertification"
    case Invitation = "invitation"
    case PassQR = "passQR"
    case RemoteIntercom = "remoteIntercom"
    case RemoteOpenDoor = "remoteOpenDoor"
}

class ModuleStatusByVersion: Mappable {
    var scanQR: Bool?
    var addMember: Bool?
    var addUnit: Bool?
    var faceCertification: Bool?
    var invitation: Bool?
    var passQR: Bool?
    var remoteIntercom: Bool?
    var remoteOpenDoor: Bool?
    
    required init?(map: ObjectMapper.Map) {}

    func mapping(map: ObjectMapper.Map) {
        scanQR <- map["function_module_smct"]//扫码乘梯
        addMember <- map["function_module_members"]//添加成员
        addUnit <- map["function_module_unit"]//添加房屋
        faceCertification <- map["function_module_face"]//人脸认证
        invitation <- map["function_module_fkyq"]//访客邀请
        passQR <- map["function_module_ymt"]//一码通
        remoteIntercom <- map["function_module_mjdj"]//门禁对讲
        remoteOpenDoor <- map["function_module_yckm"]//远程开门
    }
    
    func isNotEmpty() -> Bool {
        if let _ = scanQR, let _ = addMember, let _ = addUnit, let _ = faceCertification, let _ = invitation, let _ = passQR, let _ = remoteIntercom, let _ = remoteOpenDoor {
            return true
        }
        return false
    }
    
    func getModuleDictionary() -> Dictionary<String, Bool> {
        var result = Dictionary<String, Bool>()
        if isNotEmpty() {
            result.updateValue(scanQR!, forKey: ModulesOfModuleStatus.ScanQR.rawValue)
            result.updateValue(addMember!, forKey: ModulesOfModuleStatus.AddMember.rawValue)
            result.updateValue(addUnit!, forKey: ModulesOfModuleStatus.AddUnit.rawValue)
            result.updateValue(faceCertification!, forKey: ModulesOfModuleStatus.FaceCertification.rawValue)
            result.updateValue(invitation!, forKey: ModulesOfModuleStatus.Invitation.rawValue)
            result.updateValue(passQR!, forKey: ModulesOfModuleStatus.PassQR.rawValue)
            result.updateValue(remoteIntercom!, forKey: ModulesOfModuleStatus.RemoteIntercom.rawValue)
            result.updateValue(remoteOpenDoor!, forKey: ModulesOfModuleStatus.RemoteOpenDoor.rawValue)
        }
        return result
    }
}
