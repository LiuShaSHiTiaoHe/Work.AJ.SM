//
//  AgoraRtmCallKit.Extension.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/26.
//
import AgoraRtmKit
import AgoraRtcKit

extension AgoraRtmCallKit {
    enum Status {
        case outgoing, incoming, none
    }
    
    var lastIncomingInvitation: AgoraRtmInvitation? {
        let rtm = AgoraRtm.shared()
        
        if let agInvitation = rtm.lastIncomingInvitation {
            let invitation = AgoraRtmInvitation.agRemoteInvitation(agInvitation)
            return invitation
        } else {
            return nil
        }
    }
    
    var status: Status {
        if let _ = AgoraRtm.shared().lastOutgoingInvitation {
            return .outgoing
        } else if let _ = AgoraRtm.shared().lastIncomingInvitation {
            return .incoming
        } else {
            return .none
        }
    }
    
    func sendInvitation(peer: String, extraContent: String? = nil, accepted: Completion = nil, refused: Completion = nil, fail: ErrorCompletion = nil) {
        print("rtm sendInvitation peer: \(peer)")
        let rtm = AgoraRtm.shared()
        let invitation = AgoraRtmLocalInvitation(calleeId: peer)
        invitation.content = extraContent
        
        rtm.lastOutgoingInvitation = invitation
        
        send(invitation) { [unowned rtm] (errorCode) in
            guard errorCode == AgoraRtmInvitationApiCallErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm send invitation fail: \(errorCode.rawValue)")))
                }
                return
            }
            
            rtm.callKitAcceptedBlock = accepted
            rtm.callKitRefusedBlock = refused
        }
    }
    
    func cancelLastOutgoingInvitation(fail: ErrorCompletion = nil) {
        let rtm = AgoraRtm.shared()
        
        guard let last = rtm.lastOutgoingInvitation else {
            return
        }
        
        cancel(last) { (errorCode) in
            guard errorCode == AgoraRtmInvitationApiCallErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm cancel invitation fail: \(errorCode.rawValue)")))
                }
                return
            }
        }
        
        rtm.lastOutgoingInvitation = nil
    }
    
    func refuseLastIncomingInvitation(fail: ErrorCompletion = nil) {
        let rtm = AgoraRtm.shared()
        
        guard let last = rtm.lastIncomingInvitation else {
            return
        }
        
        refuse(last) { (errorCode) in
            guard errorCode == AgoraRtmInvitationApiCallErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm refuse invitation fail: \(errorCode.rawValue)")))
                }
                return
            }
        }
    }
    
    func accpetLastIncomingInvitation(fail: ErrorCompletion = nil) {
        let rtm = AgoraRtm.shared()
        
        guard let last = rtm.lastIncomingInvitation else {
            fatalError("rtm lastIncomingInvitation")
        }
        
        accept(last) {(errorCode) in
            guard errorCode == AgoraRtmInvitationApiCallErrorCode.ok else {
                if let fail = fail {
                    fail(AGEError(type: .fail("rtm refuse invitation fail: \(errorCode.rawValue)")))
                }
                return
            }
        }
    }
}
