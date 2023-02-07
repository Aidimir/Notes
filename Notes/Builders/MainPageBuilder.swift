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
    func createDetailPage(data: Note, router: MainPageRouterProtocol) -> UIViewController
    func createAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)?) -> UIAlertController
}

class MainBuilder: MainBuilderProtocol {
    
    func createMainPage(router: MainPageRouterProtocol) -> UIViewController {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataManager = NotesDataManager(appDelegate: appDelegate)
        let imageManager = ImageManager(appDelegate: appDelegate)
        let viewController = NotesViewController(imageManager: imageManager)
        let viewModel = NotesViewModel(notesDataManager: dataManager, router: router)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func createDetailPage(data: Note, router: MainPageRouterProtocol) -> UIViewController {
        return UIViewController()
    }
    
    func createAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: (error?.localizedDescription ?? "") + " " + (msgWithError ?? ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        })
        return alert
    }
}
