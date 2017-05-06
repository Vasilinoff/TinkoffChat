//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 06.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: скрывает вью профиля
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate let profileSaveService = ProfileSaveService()
    
    var data = ProfileModel(name: "name", about: "about", image: #imageLiteral(resourceName: "placeholder"))
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.hidesWhenStopped = true
        self.userNameTextField.delegate = self
        self.aboutTextView.delegate = self
        //self.GCDButton.isEnabled = false
        self.saveButton.isEnabled = false
        
        if !(userNameTextField.text == "name") {
            userNameTextField.textColor = UIColor.black
        }
        
        profileSaveService.loadProfileData { (profile, error) in
            guard let profileData = profile else {
                print("error")
                return
            }
            
            self.data = profileData
            DispatchQueue.main.async {
                self.aboutTextView.text = self.data.aboutValue
                self.userNameTextField.text = self.data.nameValue
                self.userImageView.image = self.data.profileImage
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
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        let view = segue.source as! ProfileImageViewController
        userImageView.image = view.pickedImage
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = UIColor.red
    }

    //MARK: Кнопка сохранения Operation
    @IBAction func saveButton(_ sender: UIButton) {
        setButtonsDisable()
        let newProfileData = setValues()
        
        profileSaveService.saveProfileData(newProfileData) { success, error in
            if error != nil {
                
                DispatchQueue.main.async {
                    let alertSaveController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить файл", preferredStyle: .alert)
                    let againAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                        self.saveButton(self.saveButton)
                    }
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertSaveController.addAction(againAction)
                    alertSaveController.addAction(okAction)
                    
                    self.present(alertSaveController, animated: true, completion: nil)
                }
            }
            
            if success {
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
    
    //MARK: делаем кнопки неактивными
    func setButtonsDisable() {
        self.saveButton.backgroundColor = UIColor(red: 1.0, green: 221/255, blue: 45/255, alpha: 1.0)
    
        self.loadingIndicator.startAnimating()
        
        self.saveButton.isEnabled = false
        
    }
    //MARK: делаем кнопки активными
    func setButtonsAble() {
        self.saveButton.backgroundColor = UIColor.red
        self.saveButton.isEnabled = true
    }
    
    //MARK: заполняем дату значениями
    func setValues() -> ProfileModel {
        let name = userNameTextField.text
        let about = aboutTextView.text
        let profileImage = userImageView.image
        //let color = textColorLabel.textColor
        
        if let nameValue = name, let aboutValue = about, let imageVale = profileImage {
            let newProfileData = ProfileModel(name: nameValue, about: aboutValue, image: imageVale)
            return newProfileData
            
        } else {
            let newProfileData = ProfileModel(name: "name", about: "about", image: #imageLiteral(resourceName: "placeholder"))
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
            self.setButtonsAble()
            
        }
        
        let flickrAction = UIAlertAction(title: "Найти в Интернете", style: .default) { (_) in
            self.performSegue(withIdentifier: "flickr", sender: self)
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(flickrAction)
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
            self.saveButton.backgroundColor = UIColor.red
            self.saveButton.isEnabled = true
        }
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

