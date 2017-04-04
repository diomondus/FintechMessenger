//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.03.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let specialColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0.1)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ColoredLabel: UILabel!
    
    @IBAction func dismissProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBAction func changeTextColorAction(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            newProfile = newProfile.getModifiedProfile(textColor: color)
        }
    }

    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    
    var gcdDataManager = GCDDataManager()
    var operationDataManager = OperationDataManager()
    
    @IBAction func gcdSaveDataToFile(_ sender: UIButton) {
        print("Сохранение данных профиля")
        saveProfile(using: gcdDataManager)
        //print("Сохранение завершено")
    }
    @IBAction func operationSaveDateToFile(_ sender: UIButton) {
        print("Сохранение данных профиля")
        saveProfile(using: operationDataManager)
        //print("Сохранение завершено")
    }
    
    var oldProfile = Profile.initStartPtofile()
    var newProfile = Profile.initStartPtofile() {
        didSet {
            setButtonsEnabled(!(oldProfile == newProfile))
            LoginTextField.text = newProfile.name
            aboutTextView.text = newProfile.about
            imageView.image = newProfile.image
            ColoredLabel.textColor = newProfile.textColor
        }
    }
    
    func saveProfile(using manager: DataManager) {
        activityIndicator.startAnimating()
        setButtonsEnabled(false)
        manager.saveData(newProfile) {
            success, error in
            self.activityIndicator.stopAnimating()
            if success {
                self.showSavedDataAlert()
                self.oldProfile = self.newProfile
            }
            else {
                self.showFailedAlert(withDataStore: manager)
            }
            self.setButtonsEnabled(true)
        }
    }
    
    func showSavedDataAlert() {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFailedAlert(withDataStore manager: DataManager) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) {
            [unowned self] action in
            self.saveProfile(using: manager)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func setButtonsEnabled(_ enabled: Bool) {
        gcdSaveButton.isEnabled = enabled
        gcdSaveButton.isHidden = !enabled
        operationSaveButton.isEnabled = enabled
        operationSaveButton.isHidden = !enabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = specialColor
        // printConrollsDescription()
        
        LoginTextField.delegate = self  // для кнопки "готово"
        aboutTextView.delegate = self
        photoPicker.delegate = self
        
        dismissKeyboard()
        setButtonsEnabled(false)
        initGestureRecognizer()
        loadProfile()
    }
    
    
// Edit profile photo

    lazy var photoPicker : UIImagePickerController = {
        return UIImagePickerController()
    }()
    lazy var imageActionSheet : UIAlertController = {
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }()
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        initImageActionSheet(imageActionSheet)
        if (!newProfile.hasDefaultImage()) {
            addDeleteActionToImageActionSheet(imageActionSheet)
        }
        present(imageActionSheet, animated: true)
    }
    
    func initGestureRecognizer() {
        // Вызывается, когда пользователь кликает на view (за пределами textField)--
        // к сожалению не будет работать, если компоненты расположены на scrollview
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(viewTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
    }
    
    func initImageActionSheet(_ actionSheet: UIAlertController) {
        actionSheet.addAction(UIAlertAction(title: "Сделать снимок", style: .default) {
            [unowned self] action in
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Выбрать фото", style: .default) {
            [unowned self] action in
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel) { action in })
    }
    
    func addDeleteActionToImageActionSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive) {
            [unowned self] action in
            self.imageView.image = #imageLiteral(resourceName: "placeholder-user")
            self.newProfile = self.newProfile.getModifiedProfile(image: #imageLiteral(resourceName: "placeholder-user"))
        })
    }
    
    
// UIImagePicke
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        newProfile = newProfile.getModifiedProfile(image: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadProfile() {
        activityIndicator.startAnimating()
        gcdDataManager.loadData() {
            self.activityIndicator.stopAnimating()
            if let profile = $0 {
                self.oldProfile = profile
                self.newProfile = profile
            }
            else {
                self.newProfile = Profile.initStartPtofile()
            }
            if let error = $1 {
                print("\(error)")
            }
        }
    }
    
    
//  TextField&View
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            newProfile = newProfile.getModifiedProfile(name: text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            newProfile = newProfile.getModifiedProfile(about: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//  Debug info
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func printConrollsDescription() {
        print(LoginTextField.description)
        print(aboutTextView.description)
        print(ColoredLabel.description)
        print(imageView.description)
        print(navigationBar.description)
    }
}

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let _ = touches.first {
//            view.endEditing(true)
//        }
//        super.touchesBegan(touches , with:event)
//    }

extension Profile: Equatable {}

func ==(lhs: Profile, rhs: Profile) -> Bool {
    return lhs.name == rhs.name &&
        lhs.about == rhs.about &&
        lhs.textColor == rhs.textColor &&
        lhs.image == rhs.image
}

struct Profile {
    let name: String
    let about: String
    let textColor: UIColor
    let image: UIImage
    
    static func initStartPtofile() -> Profile {
        let name = ""
        let about = "Здесь вы можете написать немного о себе"
        return Profile(name: name, about: about, textColor: UIColor.black, image: #imageLiteral(resourceName: "placeholder-user"))
    }
    
    func hasDefaultImage() -> Bool {
        return self.image == #imageLiteral(resourceName: "placeholder-user")
    }
    
    func getModifiedProfile(name: String? = nil, about: String? = nil, textColor: UIColor? = nil,image: UIImage? = nil) -> Profile {
        return Profile(name: name ?? self.name, about: about ?? self.about, textColor: textColor ?? self.textColor, image: image ?? self.image)
    }
}

