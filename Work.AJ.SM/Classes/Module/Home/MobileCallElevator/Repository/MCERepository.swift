//
//  MCERepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import Foundation


typealias ElevatorsCompletion = ((Dictionary<String, Array<FloorMapInfo>>, MobileCallElevatorModel) -> Void)

class MCERepository {
    
    static let shared = MCERepository()

    func getElevators(completion: @escaping ElevatorsCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let cellID = unit.cellid?.jk.intToString {
            HomeAPI.getElevators(communityID: communityID, unitID: unitID, cellID: cellID, groupID: "").request(modelType: MobileCallElevatorModel.self, cacheType: .networkElseCache, showError: true) {[self] model, response in
                completion(processData(model: model), model)
            }
        }
    }
    
    func getFloorName(floorID: String, model: MobileCallElevatorModel?) -> String {
        if let model = model, let lifts = model.lifts, let floorIDInt = floorID.jk.toInt() {
            if let elevatorInfo = lifts.first(where: { info in
                if let groupID = info.groupID, groupID == floorIDInt {
                    return true
                }else{
                    return false
                }
            }), let remark = elevatorInfo.remark {
                return remark
            }
        }
        return ""
    }
    
    private func processData(model: MobileCallElevatorModel) -> Dictionary<String, Array<FloorMapInfo>> {
        var result = Dictionary<String, Array<FloorMapInfo>>()
        if let lifts = model.lifts, let showFloors = model.showFloors, let unit = model.unit {
            for item in lifts {
                if let elevatorFloorConfig = item.elevatorFloorConfig, !elevatorFloorConfig.isEmpty, elevatorFloorConfig.contains("&"),elevatorFloorConfig.components(separatedBy: "&").count > 0, let elevatorName = item.groupID?.jk.intToString {
                    var floorMapInfoArray = [FloorMapInfo]()
                    let sFloor = elevatorFloorConfig.components(separatedBy: "&")
                    for controlInfoString in sFloor {
                        let floorMapInfo = FloorMapInfo()
                        //处理电梯显示楼层，物理楼层，是否可控数据
                        let controlFlags = controlInfoString.components(separatedBy: "#")
                        if item.doorType == 1 {
                            floorMapInfo.doorType = "1"//单开门
                            if  controlFlags.count == 3 {
                                let showFloor = getFloorIncreaseID(showFloors: showFloors, floor: controlFlags[1])
                                if showFloor.isEmpty || showFloor == "0" {//过滤展示楼层为空  INCREASEID为0的楼层
                                    continue
                                }
                                floorMapInfo.physicalFloor = controlFlags[0]
                                floorMapInfo.showFloor = showFloor
                                floorMapInfo.controlA = controlFlags[2]
                                floorMapInfo.controlB = "0"
                                floorMapInfo.increasID = controlFlags[1]
                            }else{
                                continue
                            }
                        }else{
                            floorMapInfo.doorType = "2"//贯穿门
                            if controlFlags.count == 4 {
                                let showFloor = getFloorIncreaseID(showFloors: showFloors, floor: controlFlags[1])
                                if showFloor.isEmpty || showFloor == "0" {//过滤展示楼层为空  INCREASEID为0的楼层
                                    continue
                                }
                                floorMapInfo.physicalFloor = controlFlags[0]
                                floorMapInfo.showFloor = showFloor
                                floorMapInfo.controlA = controlFlags[2]
                                floorMapInfo.controlB = controlFlags[3]
                                floorMapInfo.increasID = controlFlags[1]
                            }else{
                                continue
                            }
                        }
                        
                        if floorMapInfo.doorType == "1" {
                            //单开门
                            //用户楼层，用户侧，都不受控  根据SHOWFLOOR去判断用户楼层
                            if floorMapInfo.showFloor == unit.showFloor {
                                floorMapInfoArray.append(floorMapInfo)
                                continue
                            }else{
                                //过滤显示楼层 A门
                                if unit.doorSide == "A" {
                                    //A门是否受控（1受控，0不受控）
                                    if floorMapInfo.controlA == "0" {
                                        floorMapInfoArray.append(floorMapInfo)
                                        continue
                                    }
                                }
                                if unit.doorSide == "B"{
                                    //B门是否受控（1受控，0不受控）
                                    if floorMapInfo.controlB == "0" {
                                        floorMapInfoArray.append(floorMapInfo)
                                        continue
                                    }
                                }
                            }
                        }else{
                            //贯穿门
                            if floorMapInfo.showFloor == unit.showFloor {
                                if unit.doorSide == "A" {
                                    //A0A1  B0 type = 3   A0A1 B1 type = 1
                                    if floorMapInfo.controlB == "0" {
                                        floorMapInfo.doorType = "3"
                                    }else{
                                        floorMapInfo.doorType = "1"
                                    }
                                }else{
                                    //B0B1  A0 type = 3   B0B1 A1 type = 2
                                    if floorMapInfo.controlA == "0" {
                                        floorMapInfo.doorType = "3"
                                    }else{
                                        floorMapInfo.doorType = "2"
                                    }
                                }
                                floorMapInfoArray.append(floorMapInfo)
                                continue
                            }else{
                                //基本判断   A门不受控状态 判断B门  A0 B0 type = 3   A0 B1 type = 1
                                if floorMapInfo.controlA == "0" {
                                    if floorMapInfo.controlB == "0" {
                                        floorMapInfo.doorType = "3"
                                    }else{
                                        floorMapInfo.doorType = "1"
                                    }
                                    floorMapInfoArray.append(floorMapInfo)
                                    continue
                                }else{
                                    //A门受控状态  判断B门 A1 B0 type = 2  AB都受控 过滤掉
                                    if floorMapInfo.controlB == "0" {
                                        floorMapInfo.doorType = "2"
                                        floorMapInfoArray.append(floorMapInfo)
                                        continue
                                    }
                                }
                            }
                        }
                    }
                    result.updateValue(floorMapInfoArray, forKey: elevatorName)
                }else{
                    continue
                }
            }
        }
        return result
    }
    
    private func getFloorIncreaseID(showFloors: [FloorInfo], floor: String) -> String {
        var increaseID = ""
        for item in showFloors {
            if item.increaseID?.jk.intToString  == floor, let showFloor = item.showFloor {
                increaseID = showFloor
                break
            }
        }
        return increaseID
    }
    
}
