//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ColoredLabel: UILabel!

    @IBOutlet weak var BlackButton: UIButton!
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    @IBOutlet weak var PinkButton: UIButton!
    
    @IBAction func paintTextToBlack(_ sender: Any) {
        ColoredLabel.textColor = UIColor.black
    }
    
    @IBAction func paintTextToRed(_ sender: Any) {
         ColoredLabel.textColor = UIColor.red
    }
    
    @IBAction func paintTextToGreen(_ sender: Any) {
        ColoredLabel.textColor = UIColor.green
    }
    
    @IBAction func paintTextToBlue(_ sender: Any) {
        ColoredLabel.textColor = UIColor.blue
    }
    
    @IBAction func paintTextToPurple(_ sender: Any) {
        ColoredLabel.textColor = UIColor.purple
    }
    
    @IBAction func saveProfileAction(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

