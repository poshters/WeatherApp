//
//  RegistrationViewController.swift
//  WeatherApp
//
//  Created by MacBook on 11/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

final class ProfileViewController: UIViewController, GIDSignInUIDelegate {
    // MARK: - UI
    @IBOutlet private weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var custonView: ProfileCustomView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var signInButton: GIDSignInButton!
    @IBOutlet private weak var loginButtonState: FBSDKLoginButton!
    
    // MARK: - Instance
    private let result = ProfileDBManager.getProfile()
    private let modelRegistration = ProfileModels()
    private let realm = try? Realm()
    private var editable = false
    private var flag = false
    
    /// Get data with data base
    private func getDataWithDB() {
        nameTextField.text = result?.last?.name
        lastNameTextField.text = result?.last?.lastName
        emailTextField.text = result?.last?.email
        phoneTextField.text = result?.last?.phoneNumber
    }
    
    /// Get Facebook profile info
    private func getFacebookProfileInfo() {
        let requestMe: FBSDKGraphRequest = FBSDKGraphRequest.init(
            graphPath: "me",
            parameters: ["fields": "id, name, last_name, email, picture.width(150).height(150)"])
        let connection: FBSDKGraphRequestConnection = FBSDKGraphRequestConnection()
        connection.add(requestMe, completionHandler: { (_, userresult, _) in
            if let dictData: [String: Any] = userresult as? [String: Any] {
                self.phoneTextField.text = dictData["id"] as? String
                self.nameTextField.text = dictData["name"] as? String
                self.emailTextField.text = dictData["email"] as? String
                self.lastNameTextField.text = dictData["last_name"] as? String
                if let pictureData: [String: Any] = dictData["picture"] as? [String: Any] {
                    if let data : [String: Any] = pictureData["data"] as? [String: Any] {
                        self.fetchImage(url: data["url"] as? String)
                    }
                }
            }
            try? self.realm?.write {
                self.modelRegistration.name = self.nameTextField.text ?? DefoultConstant.empty
                self.modelRegistration.lastName = self.lastNameTextField.text ?? DefoultConstant.empty
                self.modelRegistration.email = self.emailTextField.text ?? DefoultConstant.empty
                self.modelRegistration.phoneNumber = self.phoneTextField.text ?? DefoultConstant.empty
            }
        }, batchEntryName: "me")
        connection.start()
    }
    
    /// Get image Facebook profile
    ///
    /// - Parameter url: imageURL
    private func fetchImage(url: String?) {
        let imageURL = URL(string: url ?? DefoultConstant.empty)
        var image: UIImage?
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData as Data? ?? Data())
                        self.photoButton.setImage(image, for: .normal)
                        CameraManager.shared.saveImage(imageName: ProfileConstant.avatar, image: image ?? UIImage())
                    } else {
                        image = nil
                    }
                }
            }
        }
    }
    
    /// Set image background
    private func setImageBackground() {
        let backgroundImage = UIImageView(image: UIImage(named: ProfileConstant.profileImage))
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(backgroundImage, at: 0)
        NSLayoutConstraint.activate([backgroundImage.leftAnchor.constraint(
            equalTo: view.leftAnchor),
                                     backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                                     backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

// MARK: - Life cycle
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageBackground()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        photoButton.setImage(UIImage(named: CameraManager.shared.getImage(
            imageName: ProfileConstant.avatar)), for: .normal)
        photoButton.layer.cornerRadius = photoButton.layer.bounds.size.height / 2
        photoButton.clipsToBounds = true
        getDataWithDB()
        custonView.profileCustomViewDelegate = self
        loginButtonState.delegate = self
        Analytics.logEvent("ProfileVC", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        signInButton.isEnabled = false
        loginButtonState.isEnabled = false
        custonView.buttonStateWithDB(state: result?.last?.state ?? 0)
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return editable
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Analytics.logEvent("TextFieldReturn", parameters: nil)
        textField.resignFirstResponder()
        switch textField {
        case nameTextField:
            try? realm?.write {
                modelRegistration.name = nameTextField.text ?? DefoultConstant.empty
            }
        case lastNameTextField:
            try? realm?.write {
                modelRegistration.lastName = lastNameTextField.text ?? DefoultConstant.empty
            }
        case emailTextField:
            try? realm?.write {
                modelRegistration.email = emailTextField.text ?? DefoultConstant.empty
            }
        case phoneTextField:
            try? realm?.write {
                modelRegistration.phoneNumber = phoneTextField.text ?? DefoultConstant.empty
            }
        default:
            return true
        }
        return true
    }
}

// MARK: Action button
extension ProfileViewController {

    /// Photo button action
    ///
    /// - Parameter sender: UIButton
    @IBAction func photoButtonAction(_ sender: UIButton) {
        if editable {
            CameraManager.shared.showActionSheet(viewController: self)
            CameraManager.shared.imagePickedBlock = { (image) in
                sender.setImage(image, for: .normal)
                CameraManager.shared.saveImage(imageName: ProfileConstant.avatar, image: image)
            }
        }
        Analytics.logEvent("PhotoButton", parameters: nil)
    }
    
    /// ClearAllButton
    ///
    /// - Parameter sender: Any
    @IBAction func clearAllButton(_ sender: Any) {
        nameTextField.text = DefoultConstant.empty
        lastNameTextField.text = DefoultConstant.empty
        emailTextField.text = DefoultConstant.empty
        phoneTextField.text = DefoultConstant.empty
        ProfileDBManager.deleteProfile(object: modelRegistration)
        photoButton.setImage( UIImage(named: ProfileConstant.user), for: .normal)
        CameraManager.shared.saveImage(imageName: ProfileConstant.avatar,
                                       image: UIImage(named: ProfileConstant.user) ?? UIImage())
        GIDSignIn.sharedInstance().signOut()
        custonView.disableButton()
        Analytics.logEvent("ClearAllButton", parameters: nil)
    }
    
    /// Edit button and save data in data base
    ///
    /// - Parameter sender: UIBarButtonItem
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if editable {
            sender.title = ProfileConstant.edit
            signInButton.isEnabled = false
            loginButtonState.isEnabled = false
            ProfileDBManager.addDBProfile(object: modelRegistration)
        } else {
            custonView.disableButton(disable: false)
            signInButton.isEnabled = true
            loginButtonState.isEnabled = true
            sender.title = ProfileConstant.editing
        }
        editable = !editable
        Analytics.logEvent("EditButton", parameters: nil)
    }
    
    /// Facebook button action
    ///
    /// - Parameter sender: Any
    @IBAction func loginFacebookButtonAction(_ sender: Any) {
        getFacebookProfileInfo()
        Analytics.logEvent("LoginFacebookButton", parameters: nil)
    }
}

// MARK: - ProfileCustomViewDelegate
extension ProfileViewController: ProfileCustomViewDelegate {
    
    /// Change button woman state
    ///
    /// - Parameters:
    ///   - maleButton: ChekBoxButton
    ///   - womanButton: ChekBoxButton
    func changeButtonWoman(maleButton: ChekBoxButton, womanButton: ChekBoxButton) {
        
        if maleButton.isChecked {
            maleButton.isChecked = false
            maleButton.clickOff()
            try? realm?.write {
                modelRegistration.state = State.nonsel.rawValue
            }
        }
        
        if womanButton.isChecked {
            womanButton.clickOff()
            try? realm?.write {
                modelRegistration.state = State.nonsel.rawValue
            }
            
        } else {
            womanButton.clickOn()
            try? realm?.write {
                modelRegistration.state = State.woman.rawValue
            }
            
        }
        Analytics.logEvent("CheckWomanButton", parameters: nil)
    }
    
    /// Change button male state
    ///
    /// - Parameters:
    ///   - maleButton: ChekBoxButton
    ///   - womanButton: ChekBoxButton
    func changeButtonMale(maleButton: ChekBoxButton, womanButton: ChekBoxButton) {
        
        if womanButton.isChecked {
            womanButton.isChecked = false
            try? realm?.write {
                modelRegistration.state = State.nonsel.rawValue
            }
            womanButton.clickOff()
        }
        
        if maleButton.isChecked {
            maleButton.clickOff()
            try? realm?.write {
                modelRegistration.state = State.nonsel.rawValue
            }
            
        } else {
            maleButton.clickOn()
            try? realm?.write {
                modelRegistration.state = State.man.rawValue
            }
            
        }
        Analytics.logEvent("CheckMaleButton", parameters: nil)
    }
}

// MARK: - GIDSignInDelegate
extension ProfileViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        guard let user = user else {
            return
        }
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            nameTextField.text = user.profile.name
            lastNameTextField.text = user.profile.familyName
            emailTextField.text = user.profile.email
            phoneTextField.text = user.userID
            
            try? realm?.write {
                modelRegistration.name = user.profile.name
                modelRegistration.lastName = user.profile.familyName ?? DefoultConstant.empty
                modelRegistration.email = user.profile.email
                modelRegistration.phoneNumber = user.userID
            }
        }
    }
}

// MARK: - FBSDKLoginButtonDelegate
extension ProfileViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton? ,
                     didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error?) {
        getFacebookProfileInfo()
        dismiss(animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton?) {
        dismiss(animated: true, completion: nil)
    }
}
