//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 10.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

protocol CommunicatorManagerDelegate : class {
    func updateConversationList()
}

class CommunicatorManager: NSObject, CommunicatorDelegate {
    
    let multipeerCommunicator = MultipeerCommunicator()
    private(set) var peerManagers = [PeerManager]()
    weak var delegate: CommunicatorManagerDelegate?
    
    override init() {
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        multipeerCommunicator.delegate = self
    }

    func didFoundUser(userID: String, userName: String?) {
        if let peerManager = findPeerManagerWith(identifier: userID) {
            peerManager.didFoundUser()
        }
        else {
            let peerManager = PeerManager(with:userID, userName:userName, multipeerCommunicator: multipeerCommunicator)
            peerManagers.append(peerManager)
        }
        
        delegate?.updateConversationList()
    }
    
    func didLostUser(userID: String) {
        if let peerManager = findPeerManagerWith(identifier: userID) {
            peerManager.didLostUser()
            delegate?.updateConversationList()
        }
    }
    
    func findPeerManagerWith(identifier: String) -> PeerManager? {
        var peerManager: PeerManager?
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManager = peerManagers[index]
        }
        
        return peerManager
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String) {
        if let peerManager = findPeerManagerWith(identifier: fromUser) {
            peerManager.recieveMessage(text: text)
        }
    }
    
    func getOnlinePeerManagers() -> [PeerManager] {
        
        return peerManagers.filter { return $0.chat.online }
    }
    
    func getOfflinePeerManagers() -> [PeerManager] {
        
        return peerManagers.filter { return !$0.chat.online }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        //error
    }
    
    func failedToStartAdvertising(error: Error) {
        //error 
    }
}
