import MultipeerConnectivity
import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())? )
    weak var delegate: CommunicatorDelegate? { get set }
}

protocol CommunicatorDelegate : class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didRecievedMessage(text: String, fromUser: String, toUser: String)
}

enum MultipeerCommunicatorError: Error {
    case sessionNotFound
    case sendMessageError
}

class MultipeerCommunicator: NSObject, Communicator {
    weak var delegate: CommunicatorDelegate?
    
    fileprivate var myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceType = "tinkoff-chat"
    private let discoveryInfo = "userName"
    
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    fileprivate var sessions = [String : MCSession]()
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        guard let session = sessions[userID] else {
            print("session for this user not found")
            completionHandler?(false, MultipeerCommunicatorError.sessionNotFound)
            return
        }
        
        guard let recipentPeerID = session.connectedPeers.filter({ $0.displayName != myPeerID.displayName }).first else {
            print("no peers connected to session or no peer online")
            completionHandler?(false, MultipeerCommunicatorError.sendMessageError)
            return
        }
        
        do {
            let messageData = createMessageData(text: string)
            try session.send(messageData, toPeers: [recipentPeerID], with: .reliable)
        } catch {
            print("can't send this message", error)
            completionHandler?(false, MultipeerCommunicatorError.sendMessageError)
        }
        
        completionHandler?(true, nil)
    }
    
    override init() {
        
        let myDiscoveryInfo = [discoveryInfo : UIDevice.current.name]
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: myDiscoveryInfo, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    

}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
       
        if sessions[peerID.displayName] == nil {
            let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            newSession.delegate = self
            sessions[peerID.displayName] = newSession
        }
        
        guard sessions[peerID.displayName]?.connectedPeers.count ?? 0 < 2 else {
            print("decline invite, peer is already in session")
            invitationHandler(false, nil)
            return
        }
        print("sessions.count A", sessions.count)

        invitationHandler(true, sessions[peerID.displayName])
        
        print("sessions.count A2", sessions.count)
    }
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        print("sessions.count B", sessions.count)
        
        if sessions[peerID.displayName] == nil {
        
            let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            newSession.delegate = self
            sessions[peerID.displayName] = newSession
            print("отсылаем приглашение")
        }
        
        guard sessions[peerID.displayName]?.connectedPeers.count ?? 0 < 2 else {
            print("peer already connected to session")
            return
        }
        
        browser.invitePeer(peerID, to: sessions[peerID.displayName]!, withContext: nil, timeout: 10)
        print("sessions.count B2", sessions.count)

        
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
        guard let session = sessions[peerID.displayName] else {
            print("can't remove session")
            return
        }
        session.disconnect()
        sessions.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userID: peerID.displayName)

    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID.displayName) didChangeState: \(state)")
        
        switch state {
        case .notConnected:
            print("not connected")
            delegate?.didLostUser(userID: peerID.displayName)
        case .connecting:
            print("connecting")
        case .connected:
            print("connected")
            delegate?.didFoundUser(userID: peerID.displayName, userName: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData from peer:\(peerID.displayName)")
        
        guard let messageText = parseMessageData(data: data) else {
            print("text not found")
            return
        }
        
        delegate?.didRecievedMessage(text: messageText, fromUser: peerID.displayName, toUser: myPeerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError()
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError()
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        fatalError()
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

}

extension MultipeerCommunicator {
    func createMessageData(text: String) -> Data {
        let messageDictionary = [
            "eventType": "TextMessage",
            "messageId": generateMessageId(),
            "text" : text
        ]
        return NSKeyedArchiver.archivedData(withRootObject: messageDictionary)
    }
    
    func parseMessageData(data: Data) -> String? {
        guard let messageDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: String], let message = messageDictionary["text"] else {
            print("parse message data error")
            return nil
        }
        return message
    }
    
    fileprivate func generateMessageId() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
}
