//
//  RootChat.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 28.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import Foundation
import UIKit

class RootChatController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    let onlineConversations = ["Марина","Сережа","Юрец","Маша","Катя"]
    let offlineConversations = ["Саня","Коля","Настя","Стас","Андрей","Никита","Саня","Коля","Света","Полина"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0) {
            return onlineConversations.count
        } else if (section == 1) {
            return offlineConversations.count
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Online"
        } else if (section == 1) {
            return "Offline"
        } else {
            return "";
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell")! as UITableViewCell
        if (indexPath.section == 0) {
            cell.textLabel?.text = onlineConversations[indexPath.row]
        } else {
            cell.textLabel?.text = offlineConversations[indexPath.row]
        }
        
        return cell
    }
    
}


