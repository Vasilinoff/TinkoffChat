//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 06.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func dismissProfile(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var data = ProfileData(name: "names", about: "about", image: #imageLiteral(resourceName: "placeholder"), color: UIColor.black)
    var manager = GCDManager()
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textColorLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GCDButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    
//    var filePath: String {
//        let manager = FileManager.default
//        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
//        return url!.appendingPathComponent("ProfileData").path
//    }
//    private func loadData() {
//        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? ProfileData {
//            data = ourData
//        }
//        
//    }
//    
//    private func saveData(profileData: ProfileData) {
//        data = profileData
//        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
//        
//        print("saveData")
//    }
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.hidesWhenStopped = true
        self.userNameTextField.delegate = self
        
        if !(userNameTextField.text == "name") {
            userNameTextField.textColor = UIColor.black
        }
        manager.loadData { (profileData) in
            self.data = profileData
            DispatchQueue.main.async {
                self.aboutTextView.text = self.data.aboutValue
                self.userNameTextField.text = self.data.nameValue
                self.userImageView.image = self.data.profileImage
                self.textColorLabel.textColor = self.data.color
            }
        }
        
        
        
        
        
        
        //print(#function)
        
        //descriptionPrint()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func GCDSaveButtonAction(_ sender: UIButton) {
        self.loadingIndicator.startAnimating()
        self.GCDButton.isEnabled = false
        self.operationButton.isEnabled = false
        let name = userNameTextField.text
        let about = aboutTextView.text
        let profileImage = userImageView.image
        let color = textColorLabel.textColor
        
        if let nameValue = name, let aboutValue = about, let imageVale = profileImage, let colorValue = color {
            let newProfileData = ProfileData(name: nameValue, about: aboutValue, image: imageVale, color: colorValue)
            
            //print(String(profileImage))
            manager.saveData(profileData: newProfileData)
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.GCDButton.isEnabled = true
                self.operationButton.isEnabled = true
            }
            
        }
        
    }
    @IBAction func operationSaveButton(_ sender: Any) {
    }
    
    @IBAction func changeColorButton(_ sender: UIButton) {
        textColorLabel.textColor = sender.backgroundColor
    }
    
    
    
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

