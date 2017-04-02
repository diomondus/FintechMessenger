//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!


    @IBOutlet weak var ColoredLabel: UILabel!

    @IBOutlet weak var BlackButton: UIButton!
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    @IBOutlet weak var PinkButton: UIButton!
    
    @IBAction func dismissProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
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
    
    @IBAction func saveProfileAction(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    
    let specialColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0.1)
    
    lazy var photoPicker : UIImagePickerController = {
        
        return UIImagePickerController()
    }()
    
    lazy var avatarImageActionSheet : UIAlertController = {
        
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }()

    
//    //--- Вызывается, когда пользователь кликает на view (за пределами textField)--
//    // к сожалению не будет работать, если компоненты расположены на scrollview
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let _ = touches.first {
//            view.endEditing(true)
//        }
//        super.touchesBegan(touches , with:event)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = specialColor
        printConrollsDescription()
        
        view.endEditing(true)
        LoginTextField.delegate = self;  // для кнопки "готово"
        
        photoPicker.delegate = self
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        let tapOnEmptySpace = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOnEmptySpace)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapOnImage)
    }
    
    func setupDefaultActionSheet() {
        avatarImageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Сделать снимок", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true, completion: nil)
        })
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Выбрать фото", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel) { action in })
    }
    
    func addDeleteActionToDefaultActionSheet() {
        avatarImageActionSheet.addAction(UIAlertAction(title: "Удалить", style: .destructive) {
            [unowned self] action in
            
            self.imageView.image = #imageLiteral(resourceName: "placeholder-user")
            self.setupDefaultActionSheet()
        })
    }
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        present(avatarImageActionSheet, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
        addDeleteActionToDefaultActionSheet()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDefaultActionSheet()
//        printConrollsDescription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        printConrollsDescription()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        printConrollsDescription()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        printConrollsDescription()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        printConrollsDescription()
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

