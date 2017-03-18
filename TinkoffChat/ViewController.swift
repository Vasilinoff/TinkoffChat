//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 06.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textColorLabel: UILabel!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
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
        
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.pickerController.sourceType = .camera
            self.present(self.pickerController, animated: true, completion: nil)
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            self.pickerController.sourceType = .savedPhotosAlbum
            self.present(self.pickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let removeImageAction = UIAlertAction(title: "remove", style: .default) { (action) in
            self.userImageView.image = UIImage(named: "placeholder")
            
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        alertController.addAction(removeImageAction)
        
        present(alertController, animated: true, completion: nil)

        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String: AnyObject]) {
        self.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = pickedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}

