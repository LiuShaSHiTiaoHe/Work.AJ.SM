//
//  Marcos.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import UIKit
import SwiftyUserDefaults

// keyWindow
let KeyWindow : UIWindow                        = UIApplication.shared.keyWindow!
/// 屏幕的宽
let kScreenWidth                                = UIScreen.main.bounds.size.width
/// 屏幕的高
let kScreenHeight                               = UIScreen.main.bounds.size.height
let kScale                                      = UIScreen.main.scale

let kWidthScale                                 = kScreenWidth/375.0
let kHeightScale                                = kScreenHeight/667.0

let kIs_iphone                                  = (UIDevice().userInterfaceIdiom == .phone)
let kIs_iPhoneX                                 = (kScreenWidth >= 375.0 && kScreenHeight >= 812.0 && kIs_iphone)
/// 间距
let kMargin: CGFloat                            = 20.0
let kCellMargin: CGFloat                        = 10.0
/// 圆角
let kCornerRadius: CGFloat                      = 10.0
/// 线宽
let klineWidth: CGFloat                         = 0.5
/// 双倍线宽
let klineDoubleWidth: CGFloat                   = 1.0
/// 状态栏高度
let kStateHeight : CGFloat                      = getStatusBarHeight()
/// 标题栏高度
let kTitleHeight : CGFloat                      = 44.0
/// 状态栏和标题栏高度
let kOriginTitleAndStateHeight : CGFloat        = kStateHeight + kTitleHeight

let kTitleAndStateHeight : CGFloat              = kOriginTitleAndStateHeight + 4
/// 底部导航栏高度
let kTabBarHeight: CGFloat                      = (kIs_iphone ? (kIs_iPhoneX ? 83 : 49) : 49)
/// 底部按钮高度
let kBottomTabbarHeight : CGFloat               = 49.0
/// 底部确认按钮高度
let kConfirmButtonHeight: CGFloat               = 46.0
/// 背景View的高度
let kBackgroundViewHeight: CGFloat              = kScreenHeight - kTitleAndStateHeight
/// 分段选择器的高度
let kJXSegmentedViewHeight: CGFloat             = 40.0
/// 侧边栏的宽度
let kLeftMenuWidth: CGFloat                     = 260


fileprivate func getStatusBarHeight() -> CGFloat {
   var statusBarHeight: CGFloat = 0
   if #available(iOS 13.0, *) {
       let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
   } else {
       statusBarHeight = UIApplication.shared.statusBarFrame.height
   }
   return statusBarHeight
}

