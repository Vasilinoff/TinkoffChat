//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 06.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: скрывает вью профиля
    @IBAction func dismissProfile(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var data = ProfileData(name: "names", about: "about", image: #imageLiteral(resourceName: "placeholder"), color: UIColor.black)
    var gcdDataManager: DataManager = GCDDataManager()
    var operationDataManager: DataManager = OperationDataManager()
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textColorLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GCDButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.hidesWhenStopped = true
        self.userNameTextField.delegate = self
        self.aboutTextView.delegate = self
        self.GCDButton.isEnabled = false
        self.operationButton.isEnabled = false
        
        if !(userNameTextField.text == "name") {
            userNameTextField.textColor = UIColor.black
        }
        //-----Для того чтобы проверить load с помощью GCD
        //-----Нужно изменить operationDataManager на GCDDataManager, оставив такой же метод
        
        operationDataManager.loadProfileData { (profileData, error) in
            guard let profileData = profileData else {
                print("error")
                return
            }
            
            self.data = profileData
            DispatchQueue.main.async {
                self.aboutTextView.text = self.data.aboutValue
                self.userNameTextField.text = self.data.nameValue
                self.userImageView.image = self.data.profileImage
                self.textColorLabel.textColor = self.data.colorValue
            }
        }
        

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return (true)
    }
    //MARK: отслеживаем изменения тексвью
    func textViewDidChange(_ textView: UITextView) {
        setButtonsAble()
    }
    //MARK: отслеживаем изменения имени пользователя
    @IBAction func usernameDidChanded(_ sender: UIButton) {
        setButtonsAble()
    }
    //MARK: кнопка сохранения GCD
    @IBAction func GCDSaveButtonAction(_ sender: UIButton) {
        
        setButtonsDisable()
        let newProfileData = setValues()
            
        gcdDataManager.save(profileData: newProfileData) { (error) in
                
        if error == nil {
                
            DispatchQueue.main.async {
    
                let alertSaveController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить файл", preferredStyle: .alert)
                let againAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                    self.GCDSaveButtonAction(self.GCDButton)
                }
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertSaveController.addAction(againAction)
                alertSaveController.addAction(okAction)
                self.present(alertSaveController, animated: true, completion: nil)
                }
                    
            } else {
            DispatchQueue.main.async {
                let alertSaveController = UIAlertController(title: "Файл сохранен", message: "Успех!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertSaveController.addAction(okAction)
                self.present(alertSaveController, animated: true, completion: nil)
            }
                }
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    //MARK: Кнопка сохранения Operation
    @IBAction func operationSaveButton(_ sender: UIButton) {
        setButtonsDisable()
        let newProfileData = setValues()
            
        operationDataManager.save(profileData: newProfileData) { (error) in
                
            if error == nil {
                
                DispatchQueue.main.async {
                    let alertSaveController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить файл", preferredStyle: .alert)
                    let againAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                        self.operationSaveButton(self.operationButton)
                    }
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertSaveController.addAction(againAction)
                    alertSaveController.addAction(okAction)
                    
                    self.present(alertSaveController, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let alertSaveController = UIAlertController(title: "Файл сохранен", message: "Успех!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertSaveController.addAction(okAction)
                    self.present(alertSaveController, animated: true, completion: nil)
                }
            }
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
        
    }
    //MARK: меняем цвет текста и активируем кнопки сохранения
    @IBAction func changeColorButton(_ sender: UIButton) {
        textColorLabel.textColor = sender.backgroundColor
        setButtonsAble()
    }
    
    //MARK: делаем кнопки неактивными
    func setButtonsDisable() {
        self.GCDButton.backgroundColor = UIColor(red: 1.0, green: 221/255, blue: 45/255, alpha: 1.0)
        self.operationButton.backgroundColor = UIColor(red: 1.0, green: 221/255, blue: 45/255, alpha: 1.0)
        
        self.loadingIndicator.startAnimating()
        
        self.GCDButton.isEnabled = false
        self.operationButton.isEnabled = false
        
    }
    //MARK: делаем кнопки активными
    func setButtonsAble() {
        self.GCDButton.backgroundColor = UIColor.red
        self.GCDButton.isEnabled = true
        
        self.operationButton.backgroundColor = UIColor.red
        self.operationButton.isEnabled = true
    }
    
    //MARK: заполняем дату значениями
    func setValues() -> ProfileData {
        let name = userNameTextField.text
        let about = aboutTextView.text
        let profileImage = userImageView.image
        let color = textColorLabel.textColor
        
        if let nameValue = name, let aboutValue = about, let imageVale = profileImage, let colorValue = color {
            let newProfileData = ProfileData(name: nameValue, about: aboutValue, image: imageVale, color: colorValue)
            return newProfileData
            
        } else {
            let newProfileData = ProfileData(name: "name", about: "about", image: #imageLiteral(resourceName: "placeholder"), color: .black)
            return newProfileData
        }
    }
    
    //MARK: выбираем картинку
    @IBAction func choosePicture(_ sender: Any) {
        pickerController.delegate = self
        pickerController.allowsEditing = false
        
        let alertController = UIAlertController(title: "Добавить Изображение", message: "Выбрать из", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
            self.pickerController.sourceType = .camera
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let photosLibraryAction = UIAlertAction(title: "Библиотека Фото", style: .default) { (action) in
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let savedPhotosAction = UIAlertAction(title: "Сохраненные Фото", style: .default) { (action) in
            self.pickerController.sourceType = .savedPhotosAlbum
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        let removeImageAction = UIAlertAction(title: "Удалить фото", style: .destructive) { (action) in
            self.userImageView.image = UIImage(named: "placeholder")
            
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        alertController.addAction(removeImageAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String: Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = pickedImage
            self.GCDButton.backgroundColor = UIColor.red
            self.operationButton.backgroundColor = UIColor.red
            self.GCDButton.isEnabled = true
            self.operationButton.isEnabled = true
        }
    }
    
    func descriptionPrint() {
        let outlets = [aboutTextView, userImageView, userNameTextField, textColorLabel] as [UIView]
        
        print("\n")
        
        for control in outlets {
            print(control.description)
            print("\n")
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

