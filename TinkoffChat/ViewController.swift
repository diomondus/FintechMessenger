//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ColoredLabel: UILabel!

    @IBOutlet weak var BlackButton: UIButton!
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    @IBOutlet weak var PinkButton: UIButton!
    
    @IBOutlet weak var LoginTextField: UITextField!
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
    
    //--- Вызывается, когда пользователь кликает на view (за пределами textField)--
    // к сожалению не будет работать если компоненты расположены на scrollview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches , with:event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        // Do any additional setup after loading the view, typically from a nib.
        self.LoginTextField.delegate = self;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

