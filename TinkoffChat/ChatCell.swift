//
//  ChatCell.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 01.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import Foundation
import UIKit

class Chat {
    
    var online: Bool = true
    private(set) var name: String?
    private(set) var messages = [Message]()
    
    var message: String? {
        return messages.last?.text
    }
    var date: Date? {
        return messages.last?.date
    }
    var hasUnreadMessages: Bool {
        return messages.filter { $0.isUnread }.count > 0
    }
    
    func appendMessage(_ message: Message) {
        messages.append(message)
    }
    
    func chageChatName(_ name: String) {
        self.name = name
    }
    
    init(with name: String?) {
        self.name = name
    }
}


class ConversationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let defaultBackgroundCellColor: UIColor = .white
    let hightlightedBackgroundCellColor: UIColor = UIColor(red: 1, green: 247/255, blue: 200/255, alpha: 0.6)
    
    let defaultDateFormat = "hh:mm"
    let dateFormatForOldMessages = "dd MMM"
    let defaultMessagePlaceholder = "No messages yet"
    
    let defaultFont = UIFont.systemFont(ofSize: 17.0)
    let boldDefaultFont = UIFont.boldSystemFont(ofSize: 17.0)
    let alertFont = UIFont(name: "Arial", size: 13.0)
    
    var peerManager: PeerManager? {
        didSet {
            oldValue?.removeDelegate(self)
            peerManager?.addDelegate(self)
            update()
        }
    }
    
    func update() {
        configureCellWithName(peerManager?.chat.name)
        configureCellWithDate(peerManager?.chat.date)
        configureCellWithOnlineStatus(peerManager?.chat.online ?? false)
        configureCellWithMessage(peerManager?.chat.message)
    }
    
    
    
    // cell configuration
    
    func updateCellForPeerManager(_ peerManager: PeerManager) {
        self.peerManager = peerManager
    }
    
    func configureCellWithName(_ name: String?) {
        if let name = name {
            nameLabel.text = name
        }
    }
    
    func configureCellWithMessage(_ message: String?) {
        messageLabel.text = (message != nil) ? message : defaultMessagePlaceholder
        setupMessageFontIfThereIsUnreadMessages(peerManager!.chat.hasUnreadMessages)
    }
    
    func configureCellWithDate(_ date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.string(from: date)
            formatter.dateFormat = dateIsTooOld(date) ? dateFormatForOldMessages : defaultDateFormat
            timeLabel.text = formatter.string(from: date)
        }
        else {
            timeLabel.text = ""
        }
    }
    
    func configureCellWithOnlineStatus(_ online: Bool) {
        self.backgroundColor = (online) ? hightlightedBackgroundCellColor : defaultBackgroundCellColor
    }
    
    func setupMessageFontIfThereIsUnreadMessages(_ hasUnreadMessages: Bool) {
        if peerManager!.chat.message != nil {
            messageLabel.font = (hasUnreadMessages) ? boldDefaultFont : defaultFont
        }
        else {
            messageLabel.font = alertFont
        }
    }
    
    func dateIsTooOld(_ date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        return date.timeIntervalSince1970 < startOfDay.timeIntervalSince1970
    }
}

extension ConversationCell: PeerManagerDelegate {
    func updateMessageList() {
        update()
    }
}


