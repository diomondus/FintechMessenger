//
//  PeerManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 10.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

@objc protocol PeerManagerDelegate : NSObjectProtocol {
    func updateMessageList()
    @objc optional func handleUserStatusChange()
}

func ==(lhs: PeerManagerDelegate, rhs: PeerManagerDelegate) -> Bool {
    return lhs.hash == rhs.hash
}

class PeserManagerDelegateWeakWrapper {
    weak var delegate: PeerManagerDelegate?
    
    init(delegate: PeerManagerDelegate) {
        self.delegate = delegate
    }
}

class PeerManager: NSObject {
    
    let identifier: String
    let chat: Chat
    let multipeerCommunicator: MultipeerCommunicator
    var delegates = [PeserManagerDelegateWeakWrapper]()
    
    init(with peerManagerId: String, userName:String?, multipeerCommunicator: MultipeerCommunicator) {
        identifier = peerManagerId
        chat = Chat(with: userName)
        self.multipeerCommunicator = multipeerCommunicator
        super.init()
    }
    
    func notifyDelegates() {
        DispatchQueue.main.async {
            for wrapper in self.delegates {
                wrapper.delegate?.updateMessageList()
            }
        }
    }
    
    func notifyDelegatesAboutUserStatusChanges() {
        DispatchQueue.main.async {
            for wrapper in self.delegates {
                wrapper.delegate?.handleUserStatusChange?()
            }
        }
    }
    
    func addDelegate(_ delegate: PeerManagerDelegate) {
        delegates.append(PeserManagerDelegateWeakWrapper(delegate: delegate))
    }
    
    
    func recieveMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: false)
        chat.appendMessage(message)
        notifyDelegates()
    }
    
    func sendMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        message.markAsRead()
        chat.appendMessage(message)
        multipeerCommunicator.sendMessage(string: text, to: identifier, completionHandler: nil)
        notifyDelegates()
    }
    
    func didLostUser() {
        chat.online = false
        notifyDelegatesAboutUserStatusChanges()
    }
    
    func didFoundUser() {
        chat.online = true
        notifyDelegatesAboutUserStatusChanges()
    }
    
    func removeDelegate(_ delegate: PeerManagerDelegate) {
        let filteredDelegates = delegates.filter {
            if let wrapperDelegate = $0.delegate {
                return !(wrapperDelegate == delegate)
            }
            else {
                return false
            }
        }
        
        delegates = filteredDelegates
    }
}
