//
//  SignUpViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/21/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self 
        profileImage.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //Hide the error lable
        errorLable.alpha = 0
        //Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            profileImage.image == nil{
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    @IBAction func selectImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            
            saveFIRData()
            
//            // Create cleaned versions of the data
//            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//            // Create the user
//            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//                // Check for errors
//                if err != nil {
//                    // There was an error creating the user
//                    self.showError("Error creating user")
//                }
//                else {
//                    // User was created successfully, now store the first name and last name
//                    let db = Firestore.firestore()
//                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName,"email":email, "uid": result!.user.uid ]) { (error) in
//                        if error != nil {
//                            // Show error message
//                            self.showError("Error saving user data")
//                        }
//                    }
//                    // Transition to the home screen
//                    self.transitionToHome()
//                }
//            }
        }
    }
    
    
    func saveFIRData(){
        self.uploadMedia(image: profileImage.image!){ url in
            self.saveImage(profileImageURL: url!){ success in
                if (success != nil){
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func uploadMedia(image :UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("users").child(imageName)
        let imgData = self.profileImage.image?.pngData()
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
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                // There was an error creating the user
                self.showError("Error creating user")
            }
            else {
                // User was created successfully, now store the first name and last name
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName,"email":email,"imageUrl":profileImageURL.absoluteString, "uid": result!.user.uid ]) { (error) in
                    if error != nil {
                        // Show error message
                        self.showError("Error saving user data")
                    }
                }
                // Transition to the home screen
                self.transitionToHome()
            }
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLable.text = message
        errorLable.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


