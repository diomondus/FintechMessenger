//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var ImageView: UIImageView!

    @IBOutlet weak var ColoredLabel: UILabel!

    @IBOutlet weak var BlackButton: UIButton!
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    @IBOutlet weak var PinkButton: UIButton!
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var aboutTextView: UITextView!
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
    
    @IBAction func chooseOrTakePhoto(_ sender: Any) {
        print("Выбор фотографии или камеры")
        // to do
    }
    
    @IBAction func saveProfileAction(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    
    //--- Вызывается, когда пользователь кликает на view (за пределами textField)--
    // к сожалению не будет работать, если компоненты расположены на scrollview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches , with:event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printConrollsDescription()
        self.view.endEditing(true)
        self.LoginTextField.delegate = self;  // для кнопки "готово"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printConrollsDescription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printConrollsDescription()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printConrollsDescription()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printConrollsDescription()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printConrollsDescription()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func printConrollsDescription() {
        print(BlackButton.description)
        print(RedButton.description)
        print(BlueButton.description)
        print(GreenButton.description)
        print(PinkButton.description)
        print(LoginTextField.description)
        print(aboutTextView.description)
    }

}

