//
//  ScanQRCodeCallElevatorManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/25.
//

import UIKit
import swiftScan
import SGQRCode

class ScanQRCodeCallElevatorManager: NSObject {

    static let manager = ScanQRCodeCallElevatorManager()
    
    func setUpScanManager() -> LBXScanViewController {
        var style = LBXScanViewStyle()
        style.centerUpOffset = 60
        style.xScanRetangleOffset = 30
        if UIScreen.main.bounds.size.height <= 480 {
            style.centerUpOffset = 40
            style.xScanRetangleOffset = 20
        }
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2.0
        style.photoframeAngleW = 16
        style.photoframeAngleH = 16
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        style.animationImage = R.image.base_scan_image()
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isSupportContinuous = false
        return vc
    }
    
    
}
