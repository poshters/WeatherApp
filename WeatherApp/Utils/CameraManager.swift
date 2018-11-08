//
//  CameraHandler.swift
//  WeatherApp
//
//  Created by MacBook on 11/6/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

import UIKit

class CameraManager: NSObject {
    static let shared = CameraManager()
    
    private var currentVC: UIViewController?
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(viewController: UIViewController) {
        currentVC = viewController
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,
                                            handler: { (_: UIAlertAction) -> Void in
                                                self.camera() }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default,
                                            handler: { (_: UIAlertAction) -> Void in
                                                self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func saveImage(imageName: String, image: UIImage ) {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = image
        let data = image.pngData()
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func getImage(imageName: String) -> String {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,
                                                             true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath) {
            return imagePath
        }
        return "user"
    }
}

extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else {
            print("Something went wrong")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}
