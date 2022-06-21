//
//  AgoraRtm.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/26.
//

import Foundation
import AgoraRtmKit
import AgoraRtcKit

class AgoraRtm: NSObject {
    static let rtm = AgoraRtm()
    
    // Kit
    let kit = AgoraRtmKit(appId: kAgoraAppID, delegate: nil)
    var status: LoginStatus = .offline
    var account: String?
    
    // CallKit
    var inviter: AgoraRtmCallKit? {
        return kit?.getRtmCall()
    }
    
    weak var inviterDelegate: AgoraRtmInviterDelegate?
    
    var lastOutgoingInvitation: AgoraRtmLocalInvitation?
    var lastIncomingInvitation: AgoraRtmRemoteInvitation?
    var callKitRefusedBlock: Completion = nil
    var callKitAcceptedBlock: Completion = nil
    
    static func shared() -> AgoraRtm {
        return rtm
    }
    
    override init() {
        super.init()
        inviter?.callDelegate = self
    }
    
    func setLogPath(_ path: String) {
        guard let kit = kit else {
            fatalError("rtm kit nil")
        }
        kit.setLogFile(path)
    }
}

extension AgoraRtmKit {
    func login(account: String, token: String?, success: Completion = nil, fail: ErrorCompletion = nil) {
        logger.info("rtm login account: \(account)")
        
        AgoraRtm.shared().account = account
        
        login(byToken: token, user: account) { (errorCode) in
            guard errorCode == AgoraRtmLoginErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm login fail: \(errorCode.rawValue)")))
                }
                return
            }
            AgoraRtm.shared().status = .online
            if let success = success {
                success()
            }
        }
    }
    
    func logOut() {
        logger.info("rtm logout")
        logout { errorCode in
            guard errorCode == AgoraRtmLogoutErrorCode.ok else {
                AgoraRtm.shared().status = .offline
                return
            }
        }
    }
    
    func queryPeerOnline(_ peer: String, success: ((_ status: AgoraRtmPeerOnlineState) -> Void)? = nil, fail: ErrorCompletion = nil) {
        logger.info("rtm query peer: \(peer)")
        
        queryPeersOnlineStatus([peer]) { (onlineStatusArray, errorCode) in
            guard errorCode == AgoraRtmQueryPeersOnlineErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm queryPeerOnline fail: \(errorCode.rawValue)")))
                }
                return
            }
            
            guard let onlineStatus = onlineStatusArray?.first else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm queryPeerOnline array nil")))
                }
                return
            }
            
            if let success = success {
                success(onlineStatus.state)
            }
        }
    }
}

extension AgoraRtm: AgoraRtmCallDelegate {
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationAccepted localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        logger.info("rtmCallKit localInvitationAccepted")
        
        let rtm = AgoraRtm.shared()
        if let accepted = rtm.callKitAcceptedBlock {
            DispatchQueue.main.async {
                accepted()
            }
            rtm.callKitAcceptedBlock = nil
        }
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationRefused localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        logger.info("rtmCallKit localInvitationRefused \(localInvitation.description)")
        
        let rtm = AgoraRtm.shared()
        if let refused = rtm.callKitRefusedBlock {
            DispatchQueue.main.async {
                refused()
            }
            rtm.callKitRefusedBlock = nil
        }
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationReceived remoteInvitation: AgoraRtmRemoteInvitation) {
        logger.info("rtmCallKit remoteInvitationReceived \(remoteInvitation.description)")
        
        let rtm = AgoraRtm.shared()
        
        guard rtm.lastIncomingInvitation == nil else {
            return
        }
        
        guard let inviter = rtm.inviter else {
            fatalError("rtm inviter nil")
        }
        
        DispatchQueue.main.async { [unowned inviter, weak self] in
            self?.lastIncomingInvitation = remoteInvitation
            let invitation = AgoraRtmInvitation.agRemoteInvitation(remoteInvitation)
            self?.inviterDelegate?.inviter(inviter, didReceivedIncoming: invitation)
        }
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationCanceled remoteInvitation: AgoraRtmRemoteInvitation) {
        logger.info("rtmCallKit remoteInvitationCanceled")
        let rtm = AgoraRtm.shared()
        
        guard let inviter = rtm.inviter else {
            fatalError("rtm inviter nil")
        }
        
        DispatchQueue.main.async { [weak self] in
            let invitation = AgoraRtmInvitation.agRemoteInvitation(remoteInvitation)
            self?.inviterDelegate?.inviter(inviter, remoteDidCancelIncoming: invitation)
            self?.lastIncomingInvitation = nil
        }
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationReceivedByPeer localInvitation: AgoraRtmLocalInvitation) {
        logger.info("rtmCallKit localInvitationReceivedByPeer")
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationCanceled localInvitation: AgoraRtmLocalInvitation) {
        logger.info("rtmCallKit localInvitationCanceled")
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationFailure localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        logger.info("rtmCallKit localInvitationFailure: \(errorCode.rawValue)")
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationFailure remoteInvitation: AgoraRtmRemoteInvitation, errorCode: AgoraRtmRemoteInvitationErrorCode) {
        logger.info("rtmCallKit remoteInvitationFailure: \(errorCode.rawValue)")
        self.lastIncomingInvitation = nil
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationRefused remoteInvitation: AgoraRtmRemoteInvitation) {
        logger.info("rtmCallKit remoteInvitationRefused")
        self.lastIncomingInvitation = nil
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationAccepted remoteInvitation: AgoraRtmRemoteInvitation) {
        logger.info("rtmCallKit remoteInvitationAccepted")
        self.lastIncomingInvitation = nil
    }
}
