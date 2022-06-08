//
// Created by Fairdesk on 2022/5/19.
//

import Foundation

class CommonRepository {
    private init() {}
    static let  shared = CommonRepository()

    func sendPushNotification(_ data: CommonPushModel, completion: @escaping DefaultCompletion) {
        CommonAPI.commonPush(data: data).defaultRequest { jsonData in
            completion("")
        } failureCallback: { response in
            completion(response.message)
        }
    }
}