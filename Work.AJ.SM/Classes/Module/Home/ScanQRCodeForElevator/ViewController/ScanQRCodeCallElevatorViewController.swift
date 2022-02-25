//
//  ScanQRCodeCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/25.
//

import UIKit
import swiftScan
import SVProgressHUD

class ScanQRCodeCallElevatorViewController: LBXScanViewController {

    private let symbolSeperator = "sn=" //"?C="
    private var isOpenFlash: Bool = false
    
    lazy var bottonFuncView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var photoLibraryButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.base_btn_icon_photo(), for: .normal)
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(R.image.base_btn_icon_flash(), for: .normal)
        return button
    }()
    
    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView()
        view.closeButton.setImage(R.image.common_back_white(), for: .normal)
        view.titleLabel.text = "扫描二维码"
        view.titleLabel.textColor = R.color.whiteColor()
        view.lineView.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUI()
        initData()
    }
    
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        let result: LBXScanResult = arrayResult[0]
        if let qrString = result.strScanned {
            if qrString.contains(symbolSeperator) {
                let StrArray = qrString.components(separatedBy: symbolSeperator)
                if StrArray.count > 1 {
                    let infoStr = StrArray.last!
                    let vc = ScanQRCodeSelectElevatorViewController()
                    vc.SNCode = infoStr
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    SVProgressHUD.showInfo(withStatus: "数据格式未按要求设定")
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "数据格式未按要求设定")
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "扫描结果不符合要求")
        }
    }
    
    
    
    func initData() {
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        photoLibraryButton.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(switchFlash), for: .touchUpInside)
    }
    
    @objc
    func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func switchFlash() {
        scanObj?.changeTorch()
    }
    
    func setUpStyle() {
        arrayCodeType = [.qr]
        readyString = "正在启动相机..."
        scanStyle?.centerUpOffset = 60
        scanStyle?.xScanRetangleOffset = 30
        if UIScreen.main.bounds.size.height <= 480 {
            scanStyle?.centerUpOffset = 40
            scanStyle?.xScanRetangleOffset = 20
        }
        scanStyle?.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        scanStyle?.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        scanStyle?.colorRetangleLine = .clear
        scanStyle?.colorAngle = R.color.whiteColor()!
        scanStyle?.photoframeLineW = 2.0
        scanStyle?.photoframeAngleW = 16
        scanStyle?.photoframeAngleH = 16
        scanStyle?.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        scanStyle?.animationImage = R.image.base_scan_image()
    }
    
    func initUI() {
        view.addSubview(headerView)
        view.addSubview(bottonFuncView)
        bottonFuncView.addSubview(photoLibraryButton)
        bottonFuncView.addSubview(flashButton)
        
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(bottonFuncView)

        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        
        bottonFuncView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        photoLibraryButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().dividedBy(2)
        }
        
        flashButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
    }
    

}
