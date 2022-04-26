//
//  AgoraRtmModels.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/26.
//

import Foundation
import AgoraRtcKit
import AgoraRtmKit

typealias Completion = (() -> Void)?
typealias ErrorCompletion = ((AGEError) -> Void)?

enum LoginStatus {
    case online, offline
}

protocol AgoraRtmInvitertDelegate: NSObjectProtocol {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation)
    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation)
}

struct AgoraRtmInvitation {
    var content: String?
    var caller: String // outgoint call
    var callee: String // incoming call
    
    static func agRemoteInvitation(_ ag: AgoraRtmRemoteInvitation) -> AgoraRtmInvitation {
        guard let account = AgoraRtm.shared().account else {
            fatalError("rtm account nil")
        }
        
        let invitation = AgoraRtmInvitation(content: ag.content,
                                            caller: ag.callerId,
                                            callee: account)
        
        return invitation
    }
    
    static func agLocalInvitation(_ ag: AgoraRtmLocalInvitation) -> AgoraRtmInvitation {
        guard let account = AgoraRtm.shared().account else {
            fatalError("rtm account nil")
        }
        
        let invitation = AgoraRtmInvitation(content: ag.content,
                                            caller: account,
                                            callee: ag.calleeId)
        
        return invitation
    }
}

enum HungupReason {
    case remoteReject(String), toVideoChat, normaly(String), error(Error)
    
    fileprivate var rawValue: Int {
        switch self {
        case .remoteReject: return 0
        case .toVideoChat:  return 1
        case .normaly:      return 2
        case .error:        return 3
        }
    }
    
    static func==(left: HungupReason, right: HungupReason) -> Bool {
        return left.rawValue == right.rawValue
    }
    
    var description: String {
        switch self {
        case .remoteReject:     return "remote reject"
        case .toVideoChat:      return "start video chat"
        case .normaly:          return "normally hung up"
        case .error(let error): return error.localizedDescription
        }
    }
}
