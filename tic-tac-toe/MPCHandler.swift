//
//  MPCHandler.swift
//  tic-tac-toe
//
//  Created by Louis An on 3/09/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplayName(displayName: String){
        peerID = MCPeerID(displayName: displayName)
        
    }
    
    func setupSession(){
        session = MCSession(peer: peerID)
        session.delegate = self
        
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "my-game", session: session)
        
    }
    
    func advertiseSelf(advertise: Bool){
        if advertise{
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        }else{
            advertiser!.stop()
            advertiser = nil
        }
        
    }
    
    //toRaw change to rawValue
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("MPC_DidChangeStateNotification", object: nil, userInfo: userInfo)
        })
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data, "peerID":peerID]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("MPC_DidReceiveDataNotification", object: nil, userInfo: userInfo)
        })
    }
    
    //Not gonna be used, however delete this will cause error
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    //Not gonna be used, however delete this will cause error
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    //Not gonna be used, however delete this will cause error
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }

}
