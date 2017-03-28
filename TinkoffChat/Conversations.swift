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
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
//    func tableView(_ tableView: UITableView, estimateForRowAt indexPath: IndexPath ) -> CGFloat? {
//        return UITableViewAutomaticDimension
//    }
    
    let lightYellow = UIColor(colorLiteralRed: 255, green: 255, blue: 0, alpha: 0.18)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell") as! DialogCell
        if (indexPath.section == 0) {
            cell.nameLabel.text = onlineConversations[indexPath.row]
            cell.messLabel.text = ""
            cell.timeLabel.text = "23:59"
            cell.backgroundColor = lightYellow
        } else {
            cell.nameLabel.text = historyConversations[indexPath.row]
            cell.messLabel.text = ""
            cell.timeLabel.text = "23:30"
            //cell.backgroundColor = specialColor
        }
        return cell
    }
    
}
