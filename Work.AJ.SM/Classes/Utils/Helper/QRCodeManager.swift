//
//  QRCodeManager.swift
//  Work.AJ.SM
//
//  Created by jason on 2023/6/1.
//

import UIKit

class QRCodeManager: NSObject {
    static let shared = QRCodeManager()

    func generateUserIdentifyQRCode() -> UIImage? {
        if let mobile = ud.userMobile {
            let startTime = NSDate().timeIntervalSince1970.jk.int
            logger.info("generateUserIdentifyQRCode: \(startTime)")
            let endTime = startTime + (5 * 60)
            let type = "1"
            let qrCodeString = generateQRCode(mobile, type, startTime, endTime, [])
            logger.info("generateUserIdentifyQRCode: \(qrCodeString)")
            if let qrcodeImage = QRCode(string: qrCodeString, color: .black, backgroundColor: .white, size: CGSize(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                return image
            } else {
                return nil
            }
        }
        return nil
    }

    func generateGuestQRCode(_ startTime: Int,
                             _ endTime: Int,
                             _ floors: [String]) -> UIImage?
    {
        if let mobile = ud.userMobile {
            let type = "2"
            let qrCodeString = generateQRCode(mobile, type, startTime, endTime, floors)
            logger.info("generateGuestQRCode: \(qrCodeString)")
            if let qrcodeImage = QRCode(string: qrCodeString, color: .black, backgroundColor: .white, size: CGSize(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                return image
            } else {
                return nil
            }
        }
        return nil
    }

    private func generateQRCode(_ mobile: String, _ type: String, _ startTime: Int,
                                _ endTime: Int, _ floors: [String]) -> String
    {
        var result = ""
        result += "6574"
        result += type
        result += mobile
        result += String(startTime)
        result += String(endTime)
        switch type {
        case "1":
            result += "000"
        case "2":
            if floors.isEmpty {
                result += "000"
            } else {
                result += floors.count.jk.intToString
                for item in floors {
                    result += item.count.jk.intToString
                    result += item
                }
            }
        default:
            result += "000"
        }
        return result
    }
}
