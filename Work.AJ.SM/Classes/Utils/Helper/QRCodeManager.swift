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
            let endTime = startTime + (5 * 60)
            let type = NewQRCodeType.User
            let qrCodeString = generateQRCode(mobile, type, startTime, endTime, [])
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
            let type = NewQRCodeType.guest
            let qrCodeString = generateQRCode(mobile, type, startTime, endTime, floors)
            if let qrcodeImage = QRCode(string: qrCodeString, color: .black, backgroundColor: .white, size: CGSize(width: 280.0, height: 280.0), scale: 1.0, inputCorrection: .quartile), let image = qrcodeImage.unsafeImage {
                return image
            } else {
                return nil
            }
        }
        return nil
    }

    private func generateQRCode(_ mobile: String, _ type: NewQRCodeType, _ startTime: Int,
                                _ endTime: Int, _ floors: [String]) -> String
    {
        var result = ""
        result += "6574"
        result += type.rawValue
        result += mobile
        result += String(startTime)
        result += String(endTime)
        switch type {
        case .User:
            result += "000"
        case .guest:
            if floors.isEmpty {
                result += "000"
            } else {
                result += floors.count.jk.intToString
                for item in floors {
                    result += item.count.jk.intToString
                    result += item
                }
            }
        }
        logger.info("generateQRCode result: \(result)")
        let decode = result.jk.scaCrypt(cryptType: .AES, key: "p!P2QklnjGGaZKlw", encode: true)
        logger.info("generateQRCode decode: \(decode!)")
        return decode ?? result
    }
}

enum NewQRCodeType: String {
    case User = "1"
    case guest = "2"
}
