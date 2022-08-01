//
//  Fonts.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import UIKit

let k10Font = fontSize(10)
let k11Font = fontSize(11)
let k12Font = fontSize(12)
let k13Font = fontSize(13)
let k14Font = fontSize(14)
let k15Font = fontSize(15)
let k16Font = fontSize(16)
let k17Font = fontSize(17)
let k18Font = fontSize(18)
let k19Font = fontSize(19)
let k20Font = fontSize(20)
let k21Font = fontSize(21)
let k22Font = fontSize(22)
let k23Font = fontSize(23)
let k24Font = fontSize(24)
let k28Font = fontSize(28)
let k34Font = fontSize(34)


let k12BoldFont = UIFont.boldSystemFont(ofSize: 12)
let k16BoldFont = UIFont.boldSystemFont(ofSize: 16)
let k20BoldFont = UIFont.boldSystemFont(ofSize: 20)

let kNaviTitleFont = k22Font
let kHeaderTitleFont = k20Font
let kTitleFont = k18Font
let kSecondTitleFont = k16Font

func fontSize(_ fontSize: CGFloat) -> UIFont {
    if (kScreenWidth == 320) {
        return UIFont.systemFont(ofSize: fontSize - 2)
    } else if (kScreenWidth == 375) {
        return UIFont.systemFont(ofSize: fontSize)
    } else {
        return UIFont.systemFont(ofSize: fontSize + 2)
    }
}
