//
//  BLEAdvertisingManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/18.
//

import UIKit
import CoreBluetooth
import SVProgressHUD
import JKSwiftExtension

enum AdvertisingType {
    case openDoor
    case callElevator
}

class BLEAdvertisingManager: NSObject {
    static let shared = BLEAdvertisingManager()
    private var peripheralManager: CBPeripheralManager?
    var isBleOpen: Bool = false

    private override init() {
        super.init()
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: .main)
    }

    func sendElevatorConfigData(_ data: String, _ para: String) {
        SVProgressHUD.show()
        if let peripheralManager = peripheralManager, isBleOpen {
            if !peripheralManager.isAdvertising {
                // FIXME: - Need Send Data
                stopAdvertismentIn {
                    SVProgressHUD.showSuccess(withStatus: "发送成功")
                }
            } else {
                SVProgressHUD.showError(withStatus: "正在发送数据,稍后再试")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请确认蓝牙打开后再试")
        }
    }


    // MARK: - 发送蓝牙开门数据
    @discardableResult
    func openDoor() -> Bool {
        SVProgressHUD.show()
        if let peripheralManager = peripheralManager, isBleOpen {
            if !peripheralManager.isAdvertising {
                if let openDoorData = prepareOpenDoorData() {
                    logger.info("openDoorData===> \(openDoorData)")
                    peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.init(string: "B0B0")], CBAdvertisementDataLocalNameKey: openDoorData])
                    stopAdvertismentIn {
                        SVProgressHUD.showSuccess(withStatus: "发送成功")
                    }
                    return true
                } else {
                    SVProgressHUD.showError(withStatus: "数据错误")
                }
            } else {
                SVProgressHUD.showError(withStatus: "正在发送数据,稍后再试")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请确认蓝牙打开后再试")
        }
        return false
    }

    func noneStopSendOpenDoorData() {
        guard let peripheralManager = peripheralManager else {
            return
        }
        if let openDoorData = prepareOpenDoorData() {
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.init(string: "B0B0")], CBAdvertisementDataLocalNameKey: openDoorData])
        }
    }

    func stopSendOpenDoorData() {
        guard let peripheralManager = peripheralManager else {
            return
        }
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
        }
    }

    // MARK: - 发送手机呼梯
    /**
     data[0] - data[9]
     蓝牙 ID，支持“0000000000” - “9999999999”
     data[10]
     授权标志，’0’未授权，’1’已授权
     data[11]
     门侧，’1’表示前门，’2’表示后门
     data[12] - data[14]
     Floor，楼层字符表里第几个字符，支持“001” - “999”
     data[15]
     备用
     */
    func callElevator(SN: String, authorizeFlag: String, side: String, floor: String) {
        if let peripheralManager = peripheralManager, isBleOpen {
            if !peripheralManager.isAdvertising {
                if SN.count != 10 {
                    SVProgressHUD.showError(withStatus: "未知的SN码")
                    return
                }
                var fullFloorNumber = floor
                if let floorInt = floor.jk.toInt() {
                    fullFloorNumber = String(format: "%03d", floorInt)
                }
                let advertisementData = SN + authorizeFlag + side + fullFloorNumber + "00000"
                peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.init(string: "B0B0")], CBAdvertisementDataLocalNameKey: advertisementData])
                logger.shortLine()
                logger.info("advertisementData ===>  \(advertisementData)")
                logger.shortLine()
                stopAdvertismentIn {
                    SVProgressHUD.showSuccess(withStatus: "发送成功")
                }
            } else {
                SVProgressHUD.showError(withStatus: "正在发送数据,稍后再试")
            }
        } else {
            SVProgressHUD.showError(withStatus: "请确认蓝牙打开后再试")
        }
    }

    // MARK: - Stop Advertising
    func stopAdvertismentIn(seconds: Double = 2, completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let `self` = self else {
                return
            }
            guard let peripheralManager = self.peripheralManager else {
                return
            }
            if peripheralManager.isAdvertising {
                peripheralManager.stopAdvertising()
                completion()
            } else {
                completion()
            }
        }
    }

    // MARK: - Private Functions

    // MARK: - OpenDoor Data
    private func prepareOpenDoorData() -> String? {
        if let unit = HomeRepository.shared.getCurrentUnit(), let cellMM = unit.cellmm, let userID = unit.userid, let phsycalFloorInt = unit.physicalfloor?.jk.toInt(), let sortbar = unit.sortbar {
            let userIDString = String(format: "%05d", userID)
            let bleSignal = Defaults.bluetoothSignalStrength.jk.intToString
            let phsycalFloor = String(format: "%02d", phsycalFloorInt)
            let partOfData = userIDString + sortbar + bleSignal + "M "
            let openDoorData = "AJ" + partOfData + cellMM + "11" + phsycalFloor
            return openDoorData
        }
        return nil
    }

    // MARK: - addSum
    private func addSum(_ writeData: String, _ data: String) -> String {
        var result = ""
        if data.count % 2 != 0 {
            return result
        }
        var sum: Int = 0
        let dataLen = writeData.jk.sub(start: 2, length: 2)
        let dataCmd = writeData.jk.sub(start: 4, length: 2)
        sum += dataLen.jk.hexInt
        sum += dataCmd.jk.hexInt
        if data.count == 2 {
            sum += data.jk.hexInt
        } else {
            for index in stride(from: 0, to: data.count, by: 2) {
                let tempData = data.jk.sub(start: index, length: 2)
                sum += tempData.jk.hexInt
            }
        }
        let sumHexa = String(format: "%0X", sum)
        result = writeData.jk.removeSomeStringUseSomeString(removeString: "*", replacingString: data + sumHexa)
        return result
    }

}

extension BLEAdvertisingManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            isBleOpen = true
        } else {
            isBleOpen = false
        }
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        logger.info("peripheralManagerDidStartAdvertising")
    }

}
