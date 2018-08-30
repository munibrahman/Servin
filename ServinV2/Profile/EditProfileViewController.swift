//
//  EditProfileViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSCognitoIdentityProvider

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileImageBackgroundView: UIView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    
    
    var progressBarButton: UIBarButtonItem!
    var saveButtonItem: UIBarButtonItem!
    
    
    var textFieldChanged = false
    var didPickImage = false
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        schoolTextField.delegate = self
        
        imagePicker.delegate = self
        setupNavigationController()
        populateInfo()
        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield started editing")
        textFieldChanged = true
    }
    
    func setupViews() {
        
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.isUserInteractionEnabled = false
        
        
        let tinyCameraView = UIImageView.init(frame: CGRect.init(x: profileImageBackgroundView.frame.size.width - 36.0, y: profileImageBackgroundView.frame.size.height - 31.0, width: 24.0, height: 25.0))
        tinyCameraView.contentMode = .scaleAspectFit
        tinyCameraView.image = #imageLiteral(resourceName: "camera_icon")
        tinyCameraView.isUserInteractionEnabled = false
        
        profileImageBackgroundView.addSubview(tinyCameraView)
        
        profileImageBackgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(editPicture)))
        
        firstNameTextField.backgroundColor = .clear
        firstNameTextField.addBottomBorderWithColor(color: UIColor.contentDivider, width: 1.0)
        
        firstNameTextField.text = DefaultsWrapper.getString(key: Key.firstName, defaultValue: "")
        
        lastNameTextField.backgroundColor = .clear
        lastNameTextField.addBottomBorderWithColor(color: UIColor.contentDivider, width: 1.0)
        lastNameTextField.text = DefaultsWrapper.getString(key: Key.lastName, defaultValue: "")
        
        schoolTextField.backgroundColor = .clear
        schoolTextField.addBottomBorderWithColor(color: UIColor.contentDivider, width: 1.0)
        
        
    }
    
    @objc func editPicture() {
        print("edit picture")
        
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction.init(title: "Take Photo", style: .default) { (alert) in
            print("Take Photo")
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        }
        
        let choosePhoto = UIAlertAction.init(title: "Choose Photo", style: .default) { (alert) in
            print("Choose photo")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(choosePhoto)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Image picked")
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = chosenImage //4
            
            didPickImage = true
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker cancelled")
        dismiss(animated:true, completion: nil)
    }
    
    func populateInfo() {
        
        profileImageView.image = BackendServer.shared.fetchProfileImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationController() {
        
        let progressSpinner = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        progressSpinner.color = UIColor.black
        progressSpinner.startAnimating()
        
        progressBarButton = UIBarButtonItem.init(customView: progressSpinner)
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = "Edit Profile"
        
        saveButtonItem = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveProfile))
        
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    @objc func barButtonPressed() {
        
        if textFieldChanged  || didPickImage {
            
            let alertViewController = UIAlertController.init(title: "If you exit now, your edits won't be saved.", message: "" , preferredStyle: .alert)
            
            
            // Don't do anything, just go back to editing.
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                print("cancel pressed")
                
            })
            
            
            // Leave the current VC then
            let exitAction = UIAlertAction.init(title: "Exit", style: .destructive, handler: { (action) in
                print("exit pressed")
                self.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(exitAction)
            
            self.present(alertViewController, animated: true, completion: nil)
            
            
        } else {
            // Don't do anything, just dismiss the VC
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @objc func saveProfile() {
        // TODO: Save changes here
        print("Saving profile")
        
        self.resignFirstResponder()
        
        self.navigationItem.rightBarButtonItem = progressBarButton
        
        let myGroup = DispatchGroup()
        
        if didPickImage {
            
            myGroup.enter()
            print("started request for profile pic")
            if let idToken = KeyChainStore.shared.fetchIdToken() {
                let headers: HTTPHeaders = [
                    "Authorization": idToken
                ]
                
                guard let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.4) else {
                    self.navigationItem.rightBarButtonItem = self.saveButtonItem
                    
                    return
                }
                
                var url = "\(BackendServer.shared.baseUrl)/dev/user/picture"
                url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                Alamofire.upload(imageData, to: URL(string: url)!, method: .post, headers: headers).responseJSON { (response) in
                    if let JSON = response.result.value as? NSDictionary {
                        
                        // saved the image
                        _ = DefaultsWrapper.set(image: self.profileImageView.image!, named: Key.imagePath)
                        print(JSON)
                    } else {
                        
                        // show error
                        let message = response.result.error != nil ? response.result.error!.localizedDescription : "Unable to communicate."
                        print(message)
                        
                        self.navigationItem.rightBarButtonItem = self.saveButtonItem
                        
                    }
                    
                    print("finished request for profile pic")
                    myGroup.leave()
                }
            }
        }
        
        if textFieldChanged {
            myGroup.enter()
            print("started request for text field")
            if let user = AppDelegate.defaultUserPool().currentUser() {
                
                var attributes = [AWSCognitoIdentityUserAttributeType]()
                
                if let firstName = self.firstNameTextField.text {
                    let attr = AWSCognitoIdentityUserAttributeType.init(name: "given_name", value: firstName)
                    DefaultsWrapper.setString(key: Key.firstName, value: firstName)
                    attributes.append(attr)
                }
                
                if let lastName = self.lastNameTextField.text {
                    let attr = AWSCognitoIdentityUserAttributeType.init(name: "family_name", value: lastName)
                    DefaultsWrapper.setString(key: Key.lastName, value: lastName)
                    attributes.append(attr)
                }
                
                user.update(attributes).continueOnSuccessWith { (res) -> Any? in
                    
                    print("finished request for textfield")
                    myGroup.leave()
                    return nil
                    
                }
                
            }
            
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests, exiting now")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func editAboutMePressed(_ sender: UIButton) {
        
        // TODO: Show edit about me section here
        print("edit about me")
        
        let navVC = UINavigationController.init(rootViewController: EditAboutMeViewController())
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class EditAboutMeViewController: UIViewController, UITextViewDelegate {
    
    
    var aboutMeTextInput = UITextView()
    var textViewChanged = false
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        print("frame width \(self.view.frame.size.width)")
        
        let aboutMeLabel = UILabel.init(frame: CGRect.init(x: 24.0, y: self.topbarHeight + 20.0, width: 135.0, height: 36.0))
        aboutMeLabel.adjustsFontSizeToFitWidth = true
        aboutMeLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .semibold)
        aboutMeLabel.textColor = UIColor.blackFontColor
        aboutMeLabel.text = "About me"
        
        view.addSubview(aboutMeLabel)
        
        aboutMeTextInput = UITextView.init(frame: CGRect.init(x: 24.0, y: self.topbarHeight + aboutMeLabel.frame.size.height + 30.0, width: self.view.frame.size.width - 48.0, height: 250.0))
        aboutMeTextInput.backgroundColor = .white
        aboutMeTextInput.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        aboutMeTextInput.textColor = UIColor.blackFontColor
        aboutMeTextInput.toolbarPlaceholder = "Say something nice about yourself!"
        aboutMeTextInput.delegate = self
        aboutMeTextInput.textContainer.lineFragmentPadding = 0
        view.addSubview(aboutMeTextInput)
        
        
        setupNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aboutMeTextInput.becomeFirstResponder()
        
    }
    
    // Keeps track if the input was changed.
    func textViewDidChange(_ textView: UITextView) {
        textViewChanged = true
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = .white
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = ""
        
        let editButtonItem = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveAboutMe))
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    @objc func barButtonPressed() {
        
        // Text has been changed, ask to save or not.
        if textViewChanged {
            
            let alertViewController = UIAlertController.init(title: "If you exit now, your edits won't be saved.", message: "" , preferredStyle: .alert)
            
            
            // Don't do anything, just go back to editing.
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                print("cancel pressed")
                
            })
            
            
            // Leave the current VC then
            let exitAction = UIAlertAction.init(title: "Exit", style: .destructive, handler: { (action) in
                print("exit pressed")
                self.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(exitAction)
            
            self.present(alertViewController, animated: true, completion: nil)
            

        } else {
            // Don't do anything, just dismiss the VC
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    @objc func saveAboutMe() {
        // TODO: Save changes here
        print("Saving about me")
    }
    
    
    
    
    
}



















