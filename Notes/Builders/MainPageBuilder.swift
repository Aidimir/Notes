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
    private enum ApiConstants {
        static var apiLink: String = "https://newsapi.org/v2/everything?&"
        static var apiKey: String = "b0ef93b6103243fc944f889ab5c52567"
    }
    
    func createMainPage(router: MainPageRouterProtocol) -> UIViewController {
//        let imageDownloadService = ImageDownloadService.shared
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = NotesViewController()
        let viewModel = NotesViewModel()
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
