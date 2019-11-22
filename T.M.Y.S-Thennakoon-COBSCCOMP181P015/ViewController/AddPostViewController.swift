//
//  AddPostViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/21/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var usenameTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var postSaveButton: UIButton!
    
    var imagePicker:UIImagePickerController!
//    var ref = DatabaseReference.init()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        postImage.isUserInteractionEnabled = true
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: Any) {
        if (postTitleTextField.text == "") {
            let alert = UIAlertController(title: "Notification", message: "Title is Required.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (postContentTextView.text == ""){
            let alert = UIAlertController(title: "Notification", message: "Description Is Required.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (postImage.image == nil){
            let alert = UIAlertController(title: "Notification", message: "Image Is Required.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.saveFIRData()
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Notification", message: "Post Stored.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveFIRData(){
        self.uploadMedia(image: postImage.image!){ url in
            self.saveImage(profileImageURL: url!){ success in
                if (success != nil){
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func uploadMedia(image :UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(imageName)
        let imgData = self.postImage.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                print("error in save image")
                completion(nil)
            }
        }
    }
    
    func saveImage(profileImageURL: URL , completion: @escaping ((_ url: URL?) -> ())){
        let db = Firestore.firestore()
        
        db.collection("posts").addDocument(data: ["title":postTitleTextField.text!,"username":usenameTextField.text!,"desc":postContentTextView.text!,"imageUrl":profileImageURL.absoluteString]){
            (error)in
            if error != nil{
                let alert = UIAlertController(title: "Notification", message:"error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            print("item added")
            self.clear()
        }
        
    }
    
    func clear(){
        postTitleTextField.text?.removeAll()
        usenameTextField.text?.removeAll()
        postContentTextView.text?.removeAll()
        postImage.image = nil
    }
    
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.postImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
