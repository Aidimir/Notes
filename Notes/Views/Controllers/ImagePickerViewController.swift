//
//  ImagePickerViewController.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import UIKit
import RxRelay
import AVKit

protocol ImagePickerProtocol {
    func showImagePickerOptions()
    var chosenImages: BehaviorRelay<UIImage?> { get }
    init(router: RouterProtocol)
}

class ImagePickerViewController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerProtocol {
    
    private let router: RouterProtocol
    
    
    public var chosenImages: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    required init(router: RouterProtocol) {
        self.router = router
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showImagePickerOptions() {
        let alertViewController = UIAlertController(title: "Choose from gallery", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
            guard let self = self else { return }
            let imgPicker = self.getImagePicker(sourceType: .camera)
            imgPicker.delegate = self
            self.router.navigationController?.present(imgPicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] action in
            guard let self = self else { return }
            let libraryPicker = self.getImagePicker(sourceType: .photoLibrary)
            libraryPicker.delegate = self
            self.router.navigationController?.present(libraryPicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alertViewController.addAction(cameraAction)
        alertViewController.addAction(libraryAction)
        alertViewController.addAction(cancelAction)
        
        router.navigationController?.present(alertViewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        chosenImages.accept(pickedImage)
        router.navigationController?.dismiss(animated: true)
    }
    
    private func getImagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = sourceType
        imgPicker.allowsEditing = true
        return imgPicker
    }
}
