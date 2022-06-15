//
//  UserProfileConstDefines.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/30.
//

import UIKit

struct UserProfileConstDefines {
    public init() {}
    
    var gender: [String] = ["男", "女", "保密"]
    var education: [String] = ["博士", "研究生", "本科", "大专", "高中", "初中", "小学及以下", "保密"]
    var profession: [String] = ["计算机/互联网/通信", "生产/工艺/制造", "医疗/护理/制药", "金融/银行/投资/保险", "商业/服务业/个体经营", "文化/广告/传媒", "娱乐/艺术/表演", "律师/法务", "教育/培训", "公务员/行政/事业单位", "学生", "其他职业", "保密"]
}


enum UserProfileInputType {
    case nickName
    case realName
}
