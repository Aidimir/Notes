//
//  MainPageRouter.swift
//  Notes
//
//  Created by Айдимир Магомедов on 06.02.2023.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
}

protocol MainPageRouterProtocol: RouterProtocol {
    var builder: MainBuilderProtocol? { get set }
    func initStartViewController()
    func moveToDetailViewController(data: Note?)
    func popToRoot()
    func showAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)?)
}

class MainPageRouter: MainPageRouterProtocol {
    
    var navigationController: UINavigationController?
    
    var builder: MainBuilderProtocol?
    
    init(navigationController: UINavigationController, builder: MainBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func initStartViewController() {
        if let navigationController = navigationController {
            guard let viewController = builder?.createMainPage(router: self) else { return }
            navigationController.viewControllers = [viewController]
        }
    }
    
    func moveToDetailViewController(data: Note?) {
        if let navigationController = navigationController {
            guard let detailViewController = builder?.createDetailPage(data: data, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func showAlert(title: String, error: Error?, msgWithError: String?, action: (() -> Void)? = nil) {
        guard let alert = builder?.createAlert(title: title, error: error, msgWithError: msgWithError, action: {
            action?()
        }) else { return }
        
        if let navigationController = navigationController {
            navigationController.present(alert, animated: true)
        }
    }
}

