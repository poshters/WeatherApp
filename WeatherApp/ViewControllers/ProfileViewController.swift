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

class ProfileViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet private weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var custonView: ProfileCustomView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var signInButton: GIDSignInButton!
    @IBOutlet private weak var loginButtonState: FBSDKLoginButton!
    private let result = ProfileDBManager.getProfile()
    private let modelRegistration = ProfileModels()
    private let realm = try? Realm()
    private var editable = false
    private var flag = false
    
    /// getDatawithDB
    private func getDataWithDB() {
        custonView.setImageToButtonMaleAndWoman(male: result?.first?.maleButton ?? ProfileConstant.success2 ,
                                                woman: result?.first?.womanButton ?? ProfileConstant.success2)
        nameTextField.text = result?.last?.name
        lastNameTextField.text = result?.last?.lastName
        emailTextField.text = result?.last?.email
        phoneTextField.text = result?.last?.phoneNumber
    }
    
    /// getFacebookProfileInfo
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
    
    /// getImageFacebookProfile
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
    
    /// setImageBackground
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
        custonView.setImageToButtonMaleAndWoman(male: ProfileConstant.success2,
                                                woman: ProfileConstant.success2)
        getDataWithDB()
        custonView.profileCustomViewDelegate = self
        loginButtonState.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        signInButton.isEnabled = false
        loginButtonState.isEnabled = false
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return editable
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

// MARK: Action Button
extension ProfileViewController {
    @IBAction private func photoButtonAction(_ sender: UIButton) {
        if editable {
            CameraManager.shared.showActionSheet(viewController: self)
            CameraManager.shared.imagePickedBlock = { (image) in
                sender.setImage(image, for: .normal)
                CameraManager.shared.saveImage(imageName: ProfileConstant.avatar, image: image)
            }
        }
    }
    
    @IBAction func clearAllButton(_ sender: Any) {
        nameTextField.text = DefoultConstant.empty
        lastNameTextField.text = DefoultConstant.empty
        emailTextField.text = DefoultConstant.empty
        phoneTextField.text = DefoultConstant.empty
        ProfileDBManager.deleteProfile(object: modelRegistration)
        photoButton.setImage( UIImage(named: ProfileConstant.user), for: .normal)
        custonView.setImageToButtonMaleAndWoman(male: ProfileConstant.success2, woman: ProfileConstant.success2)
        CameraManager.shared.saveImage(imageName: ProfileConstant.avatar,
                                       image: UIImage(named: ProfileConstant.user) ?? UIImage())
        GIDSignIn.sharedInstance().signOut()
    }
    
    /// editButton and save data in DB
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if editable {
            sender.title = ProfileConstant.edit
            custonView.disableButton(disable: true)
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
    }
    @IBAction func loginFacebookButtonAction(_ sender: Any) {
        getFacebookProfileInfo()
    }
}

// MARK: - ProfileCustomViewDelegate
extension ProfileViewController: ProfileCustomViewDelegate {
    func changeButtonWoman(maleButton: UIButton, womanButton: UIButton) {
        maleButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        try? realm?.write {
            modelRegistration.maleButton = ProfileConstant.success2
        }
        
        if flag == false {
            womanButton.setImage(UIImage(named: ProfileConstant.success), for: .normal)
            try? realm?.write {
                modelRegistration.womanButton = ProfileConstant.success
            }
            flag = true
        } else {
            womanButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
            try? realm?.write {
                modelRegistration.womanButton = ProfileConstant.success2
            }
            flag = false
        }
    }
    
    func changeButtonMale(maleButton: UIButton, womanButton: UIButton) {
        womanButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        try? realm?.write {
            modelRegistration.womanButton = ProfileConstant.success2
        }
        
        if flag == false {
            maleButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
            try? realm?.write {
                modelRegistration.maleButton = ProfileConstant.success2
                flag = true
            }
        } else {
            maleButton.setImage(UIImage(named: ProfileConstant.success), for: .normal)
            try? realm?.write {
                modelRegistration.maleButton = ProfileConstant.success
            }
            flag = false
        }
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

// MARK: - LoginButtonDelegateFacebook
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
