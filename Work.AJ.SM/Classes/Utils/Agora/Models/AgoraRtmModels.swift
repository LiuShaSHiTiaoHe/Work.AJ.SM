//
//  AgoraRtmModels.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/26.
//

import Foundation
import AgoraRtcKit
import AgoraRtmKit

typealias Completion = (() -> Void)?
typealias ErrorCompletion = ((AGEError) -> Void)?

enum LoginStatus {
    case online, offline
}

enum VideoCallRemoteType: String {
    case MobileApp = "1" //手机APP
    case AndroidDevice = "2" //门口机设备
}

struct ToVideoChatModel {
    var localNumber: String = ""
    var localName: String = ""
    var localType: VideoCallRemoteType = .MobileApp
    var channel: String = ""
    var remoteNumber: String = ""
    var remoteName: String = ""
    var remoteType: VideoCallRemoteType = .AndroidDevice
    var lockMac: String = ""

    func isEmpty() -> Bool {
        localNumber.isEmpty || channel.isEmpty || remoteNumber.isEmpty
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
}

protocol AgoraRtmInviterDelegate: NSObjectProtocol {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation)
    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation)
}

struct AgoraRtmInvitation {
    var content: String?
    var caller: String // outgoing call
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

enum HangupReason {
    case remoteReject(String), toVideoChat(ToVideoChatModel), normally(String), error(Error)
    
    var rawValue: Int {
        switch self {
        case .remoteReject: return 0
        case .toVideoChat:  return 1
        case .normally:     return 2
        case .error:        return 3
        }
    }
    
    static func==(left: HangupReason, right: HangupReason) -> Bool {
        left.rawValue == right.rawValue
    }
    
    var description: String {
        switch self {
        case .remoteReject:     return "remote reject"
        case .toVideoChat:      return "start video chat"
        case .normally:         return "normally hung up"
        case .error(let error): return error.localizedDescription
        }
    }
}
