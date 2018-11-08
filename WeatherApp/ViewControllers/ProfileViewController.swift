//
//  RegistrationViewController.swift
//  WeatherApp
//
//  Created by MacBook on 11/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var custonView: ProfileCustomView!
    @IBOutlet private weak var nameTextField: UITextField!
    private let result = ProfileDBManager.getProfile()
    private let modelRegistration = ProfileModels()
    private let realm = try? Realm()
    private var editable = false
    private var flag = false
    
    private func getDataWithDB() {
        custonView.setImageToButtonMaleAndWoman(male: result?.first?.maleButton ?? ProfileConstant.success2 ,
                                                woman: result?.first?.womanButton ?? ProfileConstant.success2)
        nameTextField.text = result?.first?.name
        lastNameTextField.text = result?.first?.lastName
        emailTextField.text = result?.first?.email
        phoneTextField.text = result?.first?.phoneNumber
    }
}

// MARK: - Life cycle
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        photoButton.setImage(UIImage(named: CameraManager.shared.getImage(
            imageName: ProfileConstant.avatar)), for: .normal)
        photoButton.layer.cornerRadius = photoButton.layer.bounds.size.height / 2
        photoButton.clipsToBounds = true
        custonView.setImageToButtonMaleAndWoman(male: ProfileConstant.success2,
                                                woman: ProfileConstant.success2)
        getDataWithDB()
        custonView.profileCustomViewDelegate = self
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
    }
    
    /// editButton and save data in DB
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if editable {
            sender.title = ProfileConstant.edit
            custonView.disbleButton(editable: true)
            ProfileDBManager.addDBProfile(object: modelRegistration)
        } else {
            custonView.disbleButton(editable: false)
            sender.title = ProfileConstant.editing
        }
        editable = !editable
    }
}

// MARK: - ProfileCustomViewDelegate
extension ProfileViewController: ProfileCustomViewDelegate {
    func changeButtonWoman(maleButton: UIButton, womanButton: UIButton) {
        maleButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        modelRegistration.maleButton = ProfileConstant.success2
        if flag == false {
            womanButton.setImage(UIImage(named: ProfileConstant.success), for: .normal)
            modelRegistration.womanButton = ProfileConstant.success
            flag = true
        } else {
            womanButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
            modelRegistration.womanButton = ProfileConstant.success2
            flag = false
        }
    }
    
    func changeButtonMale(maleButton: UIButton, womanButton: UIButton) {
        womanButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        modelRegistration.womanButton = ProfileConstant.success2
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
