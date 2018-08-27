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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileImageBackgroundView: UIView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    
    
    var progressBarButton: UIBarButtonItem!
    var saveButtonItem: UIBarButtonItem!
    
    
    var textFieldChanged = false
    
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
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield started editing")
        textFieldChanged = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupViews()
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
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker cancelled")
        dismiss(animated:true, completion: nil)
    }
    
    func populateInfo() {
        
        AppDelegate.defaultUserPool().currentUser()?.getSession().continueOnSuccessWith(block: { (session) -> Any? in
            
            let headers: HTTPHeaders = [
                "Authorization": (session.result?.idToken?.tokenString)!
            ]
            
            
            
            var url = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com/dev/user/picture"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            
            Alamofire.request("https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com/dev/user/picture", method: HTTPMethod.get, headers: headers).responseImage(completionHandler: { (response) in
                if let image = response.result.value {
                    self.profileImageView.image = image
                } else {
                    print(response.data)
                    print(response)
                }
            })
            
            return nil
        })
        
//        profileImageView.image = #imageLiteral(resourceName: "larry_avatar")
        
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
        
        if textFieldChanged {
            
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
        
        
        self.navigationItem.rightBarButtonItem = progressBarButton
        
        AppDelegate.defaultUserPool().currentUser()?.getSession().continueOnSuccessWith(block: { (session) -> Any? in
            
            let headers: HTTPHeaders = [
                "Authorization": (session.result?.idToken?.tokenString)!
            ]
            
            
            
            var url = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com/dev/user/picture"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            guard let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.4) else {
                self.navigationItem.rightBarButtonItem = self.saveButtonItem
                return nil
            }
            
            Alamofire.upload(imageData, to: URL(string: url)!, method: .post, headers: headers).responseJSON { (response) in
                if let JSON = response.result.value as? NSDictionary {
                    print(JSON)
                } else {
                    let message = response.result.error != nil ? response.result.error!.localizedDescription : "Unable to communicate."
                    print(message)
                }
            }
            
            self.navigationItem.rightBarButtonItem = self.saveButtonItem
            
            return nil
        })
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



















