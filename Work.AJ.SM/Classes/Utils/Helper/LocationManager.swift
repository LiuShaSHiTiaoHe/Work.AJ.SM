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
    private lazy var geoCoder = CLGeocoder()

    var getLocationHandle: ((_ success: Bool, _ latitude: Double, _ longitude: Double) -> Void)?
    
    var getCurrentCity: ((_ cityName: String) -> Void)?
        
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        //设置了精度最差的 3公里内 kCLLocationAccuracyThreeKilometers
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
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
    
    // MARK: 反地理编码  经纬度->地址
    private func getGeoLocation(_ latitude:Double, _ longitude:Double) {
        let loc1 = CLLocation(latitude: latitude, longitude: longitude)
        if inTheRangeChina(latitude: latitude, longitude: longitude) {
            geoCoder.reverseGeocodeLocation(loc1) { [weak self] (pls: [CLPlacemark]?, error: Error?)  in
                guard let `self` = self else { return }
                if error == nil {
                    print("反地理编码成功")
                    guard let plsResult = pls else {return}
                    if let block = self.getCurrentCity {
                        block(self.getLocationItem(plsResult))
                    }
                }else {
                    if let block = self.getCurrentCity {
                        block("")
                    }
                }
            }
        }else{
            if let block = self.getCurrentCity {
                block("")
            }
        }

    }
    
    private func getLocationItem(_ pls: [CLPlacemark]) -> String {
        var cityName = ""
        if let pl = pls.first {
            var address = pl.name ?? "" // 详细地址
            var country = pl.country ?? "" // 国家
            var province = pl.administrativeArea ?? "" // 省
            if province.isEmpty {
                province = (pl.addressDictionary?["State"] ?? "") as! String
            }
            var city = pl.locality ?? "" // 市
            if city.isEmpty {
                city = (pl.addressDictionary?["City"] ?? "") as! String
            }
            if city.isEmpty { // 四大直辖市的城市信息无法通过CLPlacemark的locality属性获得，只能通过访问administrativeArea属性来获得（如果locality为空，则可知为直辖市）
                city = pl.administrativeArea ?? ""
            }
            var area = pl.subLocality ?? ""
            if area.isEmpty {
                area = (pl.addressDictionary?["SubLocality"] ?? "") as! String
            }
            if area.isEmpty {
                area = city
            }
            if city.jk.contains(find: "市") {
                return city.jk.removeSomeStringUseSomeString(removeString: "市")
            }
            return city
        }
        return cityName
    }
}

extension LocationManager: CLLocationManagerDelegate {

    //MARK: - 获取定位后的经纬度
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loction = locations.last {
            
            print("latitude: \(loction.coordinate.latitude)   longitude:\(loction.coordinate.longitude)")
            self.getGeoLocation(loction.coordinate.latitude, loction.coordinate.longitude)
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
