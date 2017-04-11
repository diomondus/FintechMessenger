//
//  Conversations.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 25.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController, CommunicatorManagerDelegate
{
    let conversationCellId = "ChatCell"
    let headersTitles = ["online", "history"]
    
    let communicatorManager = CommunicatorManager()
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communicatorManager.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func updateConversationList() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headersTitles[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Conversation") {
            let vc = segue.destination as! ConversationViewController
            if let sender = sender as? ConversationCell {
                vc.peerManager = sender.peerManager
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return headersTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let offlinePeerManagersCount = communicatorManager.getOfflinePeerManagers().count
        let onlinePeerManagersCount = communicatorManager.getOnlinePeerManagers().count
        let peerManagersCountCalculatedByStatus = [onlinePeerManagersCount, offlinePeerManagersCount]
        
        return peerManagersCountCalculatedByStatus[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let peerManagersSeparatedByStatus = [communicatorManager.getOnlinePeerManagers(), communicatorManager.getOfflinePeerManagers()]
        let cell = tableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        let neededPeerManagers = peerManagersSeparatedByStatus[indexPath.section]
        let filteredPeerManagers = neededPeerManagers.sorted(by: {
            if ($0.chat.date != nil) && ($1.chat.date != nil) {
                return $0.chat.date! > $1.chat.date!
            }
            else if ($0.chat.date == nil) && ($1.chat.date != nil) {
                return true
            }
            else if ($0.chat.date != nil) && ($1.chat.date == nil) {
                return false
            }
            else {
                return $0.chat.name! > $1.chat.name!
            }})
        let peerManager = filteredPeerManagers[indexPath.row]
        cell.updateCellForPeerManager(peerManager)
        
        return cell
    }

}
