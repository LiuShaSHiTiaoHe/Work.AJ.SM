//
//  Strigs.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation

let kConstAPPNameString = "智慧社区"
let kDefaultDateFormatte = "yyyy-MM-dd HH:mm:ss"

extension String {
    func ajImageUrl() -> String {
        return host + "images/" + self
    }
}
