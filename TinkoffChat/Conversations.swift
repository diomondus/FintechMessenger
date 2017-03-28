//
//  Conversations.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 25.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import Foundation
import UIKit

class ConversationsViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    let onlineConversations = ["Марина","Сережа","Юрец","Маша","Катя"]
    let historyConversations = ["Саня","Коля","Настя","Стас","Андрей","Никита","Саня","Коля","Света","Полина"]
    
    let specialColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0.1)
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = specialColor
//        tableView.backgroundColor = specialColor
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0) {
            return onlineConversations.count
        } else if (section == 1) {
            return historyConversations.count
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Online"
        } else if (section == 1) {
            return "History"
        } else {
            return "";
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    let lightYellow = UIColor(colorLiteralRed: 255, green: 255, blue: 0, alpha: 0.18)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell")! as UITableViewCell
        if (indexPath.section == 0) {
            cell.textLabel?.text = onlineConversations[indexPath.row]
            cell.backgroundColor = lightYellow
        } else {
            cell.textLabel?.text = historyConversations[indexPath.row]
            //cell.backgroundColor = specialColor
        }
        return cell
    }
    
}
