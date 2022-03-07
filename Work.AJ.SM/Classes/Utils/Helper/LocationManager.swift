//
//  LocationManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/7.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var getLocationHandle: ((_ success: Bool, _ latitude: Double, _ longitude: Double) -> Void)?
    
    var getAuthHandle: ((_ success: Bool) -> Void)?
    
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        //设置了精度最差的 3公里内 kCLLocationAccuracyThreeKilometers
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        
    }
    /// 设备是否开启了定位服务
    func hasLocationService() -> Bool {
        
        return CLLocationManager.locationServicesEnabled()
        
    }
    /// APP是否有定位权限
    func hasLocationPermission() -> Bool {
        
        switch locationPermission() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            break
        }
        return false
    }
    
    /// 定位的权限
    func locationPermission() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            let status: CLAuthorizationStatus = locationManager.authorizationStatus
            print("location authorizationStatus is \(status.rawValue)")
            return status
        } else {
            let status = CLLocationManager.authorizationStatus()
            print("location authorizationStatus is \(status.rawValue)")
            return status
        }
    }
    
    
    //MARK: - 获取权限，在代理‘didChangeAuthorization’中拿到结果
    func requestLocationAuthorizaiton() {
        locationManager.requestWhenInUseAuthorization()
        
    }
    //MARK: - 获取位置
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func inTheRangeChina(latitude: Double, longitude: Double) -> Bool {
        if (longitude < 72.004 || longitude > 137.8347) {
            return false
        }
        if (latitude < 0.8293 || latitude > 55.8271) {
            return false
        }
        return true
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
   //MARK: - ios 14.0 之前，获取权限结果的方法
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleChangedAuthorization()
    }
    
    //MARK: - ios 14.0，获取权限结果的方法
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleChangedAuthorization()
    }
    
    private func handleChangedAuthorization() {
        if let block = getAuthHandle, locationPermission() != .notDetermined {
            if hasLocationPermission() {
                block(true)
            } else {
                block(false)
            }
        }
    }
    //MARK: - 获取定位后的经纬度
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loction = locations.last {
            
            print("latitude: \(loction.coordinate.latitude)   longitude:\(loction.coordinate.longitude)")
            
            if let block = getLocationHandle {
                block(true, loction.coordinate.latitude, loction.coordinate.longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let block = getLocationHandle {
            block(false, 0, 0)
        }
        print("get location failed. error:\(error.localizedDescription)")
    }
}
