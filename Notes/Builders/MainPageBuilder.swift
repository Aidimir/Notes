//
//  MainPageBuilder.swift
//  Notes
//
//  Created by Айдимир Магомедов on 06.02.2023.
//

import Foundation
import UIKit

protocol MainBuilderProtocol {
    func createMainPage(router: MainPageRouterProtocol) -> UIViewController
    func createDetailPage(data: Note?, router: MainPageRouterProtocol) -> UIViewController
    func createAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)?) -> UIAlertController
}

class MainBuilder: MainBuilderProtocol {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func createMainPage(router: MainPageRouterProtocol) -> UIViewController {
        let dataManager = NotesDataManager(appDelegate: appDelegate)
        
        let imageManager = ImageManager(appDelegate: appDelegate)
        
        let viewController = NotesViewController(imageManager: imageManager)
        
        let viewModel = NotesViewModel(notesDataManager: dataManager, router: router)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func createDetailPage(data: Note?, router: MainPageRouterProtocol) -> UIViewController {
        let imageManager = ImageManager(appDelegate: appDelegate)
        
        let dataManager = NotesDataManager(appDelegate: appDelegate)
        
        let imagePicker = ImagePickerViewController(router: router)
        
        let detailViewController = DetailViewController(imagePickerController: imagePicker)
        
        let viewModel = DetailViewModel(notesDataManager: dataManager, router: router, note: data, imageManager: imageManager)
        detailViewController.viewModel = viewModel
        
        return detailViewController
    }
    
    func createAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: (error?.localizedDescription ?? "") + " " + (msgWithError ?? ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        })
        return alert
    }
}
