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
import AWSAppSync
import AWSS3
import AWSMobileClient

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
    
    var appSyncClient: AWSAppSyncClient?
    
    // This var keeps track of the about me text
    var aboutMe: String?
    
    var imagePicker = UIImagePickerController()
    
    let progressView: UIProgressView = {
        let progressBar = UIProgressView.init(progressViewStyle: UIProgressView.Style.bar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appSyncClient = appDelegate.appSyncClient
        }

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        schoolTextField.delegate = self
        
        schoolTextField.isUserInteractionEnabled = false
        
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
        
        
        lastNameTextField.backgroundColor = .clear
        lastNameTextField.addBottomBorderWithColor(color: UIColor.contentDivider, width: 1.0)
        
        schoolTextField.backgroundColor = .clear
        schoolTextField.addBottomBorderWithColor(color: UIColor.contentDivider, width: 1.0)
        
        view.addSubview(progressView)
        
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        
    }
    
    @objc func editPicture() {
        print("edit picture")
        
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction.init(title: "Take Photo", style: .default) { (alert) in
            print("Take Photo")
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image picked")
        
        if let chosenImage = info[.originalImage] as? UIImage {
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
        
        appSyncClient?.fetch(query: MeQuery(), cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "Can't unwrap error")
                return
            }
            
            if let me = result?.data?.me {
                self.firstNameTextField?.text = me.givenName
                self.lastNameTextField.text = me.familyName
                self.schoolTextField.text = me.school
                self.aboutMe = me.about
            } else {
                print("Can't unwrap the me object, show error")
            }
            
            
            
        })
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
        
        self.view.resignFirstResponder()
        
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
        
        self.view.resignFirstResponder()
        
        self.navigationItem.rightBarButtonItem = progressBarButton
        
        let myGroup = DispatchGroup()
        
        if didPickImage {
            
            // This is the S3 key used to store this person's current image.
            let key = S3ProfileImageKeyName
            
            DispatchQueue.main.async(execute: {
                self.progressView.progress = 0
            })
            
            guard let image = self.profileImageView.image, let data = image.pngData() else {
                print("Can't extract image, so won't even try to upload it")
                return
            } // Data to be uploaded
            
            let expression = AWSS3TransferUtilityMultiPartUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Update a progress bar.
                    if (self.progressView.progress < Float(progress.fractionCompleted)) {
                        self.progressView.progress = Float(progress.fractionCompleted)
                    }
                })
            }
            
            var completionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    
                    if let error = error {
                        print("Failed to upload image, please try again!")
                        print(error)
                        self.showErrorNotification(title: "Error", subtitle: "Unable to upload your profile image, please try again")
                        return
                    }
                    DefaultsWrapper.set(image: image, named: Key.imagePath)
                    print("finished request for profile pic")
                    
                    self.appSyncClient?.perform(mutation: UpdateProfilePictureMutation.init(key: key), resultHandler: { (result, error) in
                        myGroup.leave()
                        if let error = error, let errors = result?.errors {
                            print(error)
                            print(errors)
                            print("Error updating the profile information key")
                            return
                        }
                        
                        if let data = result?.data?.updateProfilePicture?.profilePic {
                            print("Updated profile image, should be in the db now!")
                        }
                        
                    })
                    
                    
                    
                    // Do something e.g. Alert a user for transfer completion.
                    // On failed uploads, `error` contains the error object.
                })
            }
            
            let transferUtility = AWSS3TransferUtility.default()
            
            myGroup.enter()
            
            
            
            
            print(key)
            transferUtility.uploadUsingMultiPart(data: data, key: key, contentType: "image/png", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                if let error = task.error {
                    print(error)
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with uploadTask.
                }
                return nil;
            }
            
            
            
//            if let idToken = KeyChainStore.shared.fetchIdToken() {
//                let headers: HTTPHeaders = [
//                    "Authorization": idToken
//                ]
//
//                guard let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.4)  else {
//                    self.navigationItem.rightBarButtonItem = self.saveButtonItem
//
//                    return
//                }
//
//                var url = "\(BackendServer.shared.baseUrl)/dev/user/picture"
//                url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//                Alamofire.upload(imageData, to: URL(string: url)!, method: .post, headers: headers).responseJSON { (response) in
//                    if let JSON = response.result.value as? NSDictionary {
//
//                        // saved the image
//                        _ = DefaultsWrapper.set(image: self.profileImageView.image!, named: Key.imagePath)
//                        print(JSON)
//                    } else {
//
//                        // show error
//                        let message = response.result.error != nil ? response.result.error!.localizedDescription : "Unable to communicate."
//                        print(message)
//
//
//
//                    }
//
//
//                }
//            }
        }
        
        myGroup.enter()
        print("started request for text field")
        
        
        
        let mutation = UpdateProfileInformationMutation.init(given_name: firstNameTextField.text, family_name: lastNameTextField.text, about: aboutMe, school: "University Of Calgary")
        
        print("About me for request is \(aboutMe ?? " Nothing ")")
        
        appSyncClient?.perform(mutation: mutation, resultHandler: { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                
                print("Error occurred: \(error.localizedDescription )")
                print(error)
                return
            }
            
            if let errors = result?.errors {
                print("Error occured:")
                print(errors)
                
            }
            
            
            // Everything went smoothly
            myGroup.leave()
            
        })
            
        
        myGroup.notify(queue: .main) {
            self.navigationItem.rightBarButtonItem = self.saveButtonItem
            print("Finished all requests, exiting now")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func editAboutMePressed(_ sender: UIButton) {
        
        // TODO: Show edit about me section here
        print("edit about me")
        let vc = EditAboutMeViewController()
        vc.aboutMeTextInput.text = aboutMe
        vc.editingVC = self
        let navVC = UINavigationController.init(rootViewController: vc)
        
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

private class EditAboutMeViewController: UIViewController, UITextViewDelegate {
    
    
    var aboutMeTextInput = UITextView()
    var textViewChanged = false
    
    var progressBarButton: UIBarButtonItem!
    var saveButtonItem: UIBarButtonItem!
    
    // This is the vc that is calling me
    var editingVC: EditProfileViewController?
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInfo()
    }
    
    func fetchInfo() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            appSyncClient?.fetch(query: MeQuery(), cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "Can't unwrap error")
                    return
                }
                
                if let me = result?.data?.me {
                    
                    self.aboutMeTextInput.text = me.about
                } else {
                    print("Can't unwrap the me object, show error")
                }
                
            })
        }
        
        
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
        
        let progressSpinner = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        progressSpinner.color = UIColor.black
        progressSpinner.startAnimating()
        
        progressBarButton = UIBarButtonItem.init(customView: progressSpinner)
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = .white
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = ""
        
        saveButtonItem = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveAboutMe))
        
        navigationItem.rightBarButtonItem = saveButtonItem
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
        
        // Pass the string back to the parent VC.
        
        editingVC?.aboutMe = aboutMeTextInput.text
        self.dismiss(animated: true, completion: nil)
        
    }
    
}



















