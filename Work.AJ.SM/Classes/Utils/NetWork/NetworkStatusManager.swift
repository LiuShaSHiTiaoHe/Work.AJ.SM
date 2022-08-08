//
//  NetworkStatusManager.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/8/8.
//

import Foundation
import Alamofire

protocol NetworkStatusManagerDelegate: NSObjectProtocol {
    func networkStatusChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus)
}
extension NetworkStatusManagerDelegate {
    func networkStatusChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus) {}
}

private struct NetworkStatusManagerDelegateWrapper {
  weak var wrapped: NetworkStatusManagerDelegate?

  init(_ wrapped: NetworkStatusManagerDelegate) {
    self.wrapped = wrapped
  }
}

class NetworkStatusManager {
    static let shared = NetworkStatusManager()
    private var delegateWrappers: [NetworkStatusManagerDelegateWrapper] = []

    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

extension NetworkStatusManager {
    func startMonitor() {
        
    }
    
    func stopMonitor() {
        
    }
    
    func simpleState() {
        
    }
    
    func isOnCellular() -> Bool {
        return NetworkReachabilityManager(host: "www.apple.com")?.isReachableOnCellular ?? false
    }
}

extension NetworkStatusManager {

    @objc func didBecomeActive() { }
    
    @objc func enterForeground() { }
    
    @objc func willResignActive() { }
    
    @objc func enterBackground() { }
}

extension NetworkStatusManager {
    func addObserver(_ observer: NetworkStatusManagerDelegate) {
        if delegateWrappers.contains(where: { element in
            if let wrapped = element.wrapped {
              return wrapped === observer
            } else {
              // Handle observers who dealloc'd without removing themselves.
              return true
            }
        }) {
            return
        }else{
            delegateWrappers.append(NetworkStatusManagerDelegateWrapper(observer))
        }
    }

    func removeObserver(_ observer: NetworkStatusManagerDelegate){
        delegateWrappers.removeAll { (element: NetworkStatusManagerDelegateWrapper) -> Bool in
          if let wrapped = element.wrapped {
            return wrapped === observer
          } else {
            // Handle observers who dealloc'd without removing themselves.
            return true
          }
        }
    }
    
    func removeAllObservers() {
        delegateWrappers.removeAll()
    }
}
