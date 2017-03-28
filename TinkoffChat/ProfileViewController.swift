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
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textColorLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameTextField.delegate = self
        
        print(#function)
        
        descriptionPrint()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        print("Сохранение данных профиля")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(#function)
        
        descriptionPrint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(#function)
        
        descriptionPrint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        print(#function)
        
        descriptionPrint()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print(#function)
        
        descriptionPrint()
    }


}

