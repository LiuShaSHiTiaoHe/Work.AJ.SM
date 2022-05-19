//
// Created by Fairdesk on 2022/5/19.
//

import Foundation

struct CommonPushModel {
    /*
    pushFor           1               2
    alias            userId       deviceId
     */
    var alias: String = ""
    var pushFor: String = "" //1：app； 2：device
    /*
    推送类型（默认推送双端，单端暂不支持。双端推送有一个成功即返回成功，同理，APP推送时极光或阿里推送成功即返回成功）
    pushType 1：通知 2：离线消息 3:通知&离线消息 4:Android通知 5:IOS通知 6:Android离线消息 7:IOS离线消息 8:Android通知&离线消息 9:IOS通知&离线消息
    pushType 暂只支持1、2，如需要，后续支持开发
    推送消息时需注意：参数body在极光推送没有使用，推送消息里body是extras
     */
    var pushType: String = ""
    //推送消息的extras里的type
    var type: String = ""
    //推送消息的title
    var title: String = ""
    //推送消息的body
    var body: String = ""
}
