//
//  MultiServiceManager.swift
//  MPCProof
//
//  Created by Daniel Thompson on 7/13/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol MultiServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: MultiServiceManager, connectedDevices: [String])
    func valueSent(manager: MultiServiceManager, value: Int)
    
}


class MultiServiceManager : NSObject {
    
    
    // :::::::::::::::::: DECLARATIONS
    
    // multipeer identification for this device
    private let serviceType = "multi-tap"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    var delegate : MultiServiceManagerDelegate?
    
    // singletons used for making the connection, check out their delegates
    // for functionality (not all currently being used)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    
    // :::::::::::::::::: SETUP
    
    override init(){
        
        // instantiate browser and advertiser
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        
        // setup advertiser
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        // setup browser
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        
    }
    
    deinit {
        // turn off services before the manager instance is deallocated
        // to prevent zombies
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    
    // :::::::::::::::::: FUNCTIONALITY
    
    func send(valueInt: inout Int){ // override this function to increase complexity of sent information
        print("sendValue: \(valueInt) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(Data(bytes: &valueInt, count: MemoryLayout.size(ofValue: valueInt)), toPeers: session.connectedPeers, with: .reliable)
            } catch let error {
                print("Error in MPCManager send function: \(error)")
            }
        }
    }
    
}

extension MultiServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising peer with error: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Did receive invitation from peer: \(peerID)")
        invitationHandler(true, session)
    }
    
}

extension MultiServiceManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("did not start browsing for peers \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found peer \(peerID)")
        print("invite peer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer \(peerID)")
    }
}

extension MultiServiceManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer ID \(peerID) did change state \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO: we should use NSDictionaries to pass this data around
        // they have good utility for encoding/decoding to data
        print("did receive data \(data) from peer \(peerID)")
        let int = data.withUnsafeBytes({ (ptr: UnsafePointer<Int>) -> Int in
            return ptr.pointee
        })
        self.delegate?.valueSent(manager: self, value: int)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("did receive input stream \(stream) with name \(streamName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("did start receiving resource with name \(resourceName) from \(peerID)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("did finish receiving resource with name \(resourceName) from peer \(peerID)")
    }
    
}
