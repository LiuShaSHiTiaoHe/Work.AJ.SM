//
//  Strigs.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation

let kConstAPPNameString = "智慧社区"
let kAboutUsPageURLString = "http://www.njanjar.com/index.php/Home/Index/about.html"
let kDefaultDateFormatte = "yyyy-MM-dd HH:mm:ss"
let kServiceSupportNumber = "025-52309399"
let kAppID = "1444571864"
let kJpushAppKey = "3e191e80c1475843e7204166"
let kNIMSdkAppKey = "4b1a03db69454aa7ce178216237976e8"

extension String {
    func ajImageUrl() -> String {
        return host + "images/" + self
    }
}
