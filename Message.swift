//
//  Message.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 10.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit
import QuartzCore

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    var currentMessage: Message? {
        didSet {
            messageTextLabel.text = currentMessage?.text
            currentMessage?.markAsRead()
        }
    }
    
    func updateCellForMessage(_ message: Message) {
        currentMessage = message
    }
    
}

class Message: NSObject {
    
    private(set) var text: String?
    private(set) var date: Date?
    private(set) var isOutcoming: Bool = false
    private(set) var isUnread: Bool = true
    
    init(with text: String, date: Date, isOutcoming: Bool) {
        self.isOutcoming = isOutcoming
        self.text = text
        self.date = date
        super.init()
    }
    
    func markAsRead() {
        isUnread = false
    }
}

