//
//  String.Extension.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/21.
//

import Foundation
extension String {
    func ajImageUrl() -> String {
        return host + "images/" + self
    }
}
