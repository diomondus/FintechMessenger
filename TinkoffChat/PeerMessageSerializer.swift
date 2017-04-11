//
//  PeerMessageSerializer.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 10.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class PeerMessageSerializer: NSObject {
    
    static let messageEventTypeDescription = "TextMessage"
    static let messageIdKey = "messageId"
    
    static let messageEventTypeKey = "eventType"
    static let messageTextKey = "text"
    
    func generateMessageId() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
    
    func serializeMessageWith(text: String) throws -> Data  {
        let message = [PeerMessageSerializer.messageEventTypeKey : PeerMessageSerializer.messageEventTypeDescription,
                       PeerMessageSerializer.messageIdKey : generateMessageId(),
                       PeerMessageSerializer.messageTextKey : text]
        
        return try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
    }
    
    func deserializeMessageFrom(data: Data) throws -> String? {
        let peerMessage =  try JSONSerialization.jsonObject(with: data, options:[] ) as? [String: String]
        
        return peerMessage?[PeerMessageSerializer.messageTextKey]
    }
    
 
}

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
