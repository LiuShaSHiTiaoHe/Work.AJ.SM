//
//  CallingViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/26.
//

import UIKit
import AgoraRtmKit
import AudioToolbox

protocol CallingViewControllerDelegate: NSObjectProtocol {
    func callingVC(_ vc: CallingViewController, didHungup reason: HungupReason)
}

class CallingViewController: BaseViewController {
    enum Operation {
        case on, off
    }
    
    private var ringStatus: Operation = .off {
        didSet {
            guard oldValue != ringStatus else {
                return
            }
            
            switch ringStatus {
            case .on:  startPlayRing()
            case .off: stopPlayRing()
            }
        }
    }
    
    private var animationStatus: Operation = .off {
        didSet {
            guard oldValue != animationStatus else {
                return
            }
            
            switch animationStatus {
            case .on:  startAnimating()
            case .off: stopAnimationg()
            }
        }
    }
    
    private let aureolaView = AureolaView(color: UIColor(red: 173.0 / 255.0,
                                                         green: 211.0 / 255.0,
                                                         blue: 252.0 / 255.0, alpha: 1))
    private var timer: Timer?
    private var soundId = SystemSoundID()
    
    weak var delegate: CallingViewControllerDelegate?
    
    var localNumber: String?
    var remoteNumber: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationStatus = .on
        ringStatus = .on
    }
    
    @objc
    func doHungUpPressed(_ sender: UIButton) {
        close(.normaly(remoteNumber!))
    }
    
    func close(_ reason: HungupReason) {
        animationStatus = .off
        ringStatus = .off
        delegate?.callingVC(self, didHungup: reason)
    }
    
    override func initUI() {
        
    }
    
    lazy var headImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k16Font
        view.textColor = R.color.themeColor()
        return view
    }()
    
}



private extension CallingViewController {
    @objc func animation() {
        aureolaView.startLayerAnimation(aboveView: headImageView,
                                        layerWidth: 2)
    }
    
    func startAnimating() {
        let timer = Timer(timeInterval: 0.3,
                          target: self,
                          selector: #selector(animation),
                          userInfo: nil,
                          repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    func stopAnimationg() {
        timer?.invalidate()
        timer = nil
        aureolaView.removeAnimation()
    }
    
    func startPlayRing() {
        let path = Bundle.main.path(forResource: "ring", ofType: "mp3")
        let url = URL.init(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        
        AudioServicesAddSystemSoundCompletion(soundId,
                                              CFRunLoopGetMain(),
                                              nil, { (soundId, context) in
                                                AudioServicesPlaySystemSound(soundId)
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
    }
    
    func stopPlayRing() {
        AudioServicesDisposeSystemSoundID(soundId)
        AudioServicesRemoveSystemSoundCompletion(soundId)
    }
}
