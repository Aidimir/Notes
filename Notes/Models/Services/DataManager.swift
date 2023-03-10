//
//  DataManager.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    var appDelegate: AppDelegate { get }
    func resetStorage() throws
    init(appDelegate: AppDelegate)
}

class DataManager: DataManagerProtocol {
    
    var appDelegate: AppDelegate
    
    final func resetStorage() throws {
        let storeContainer = appDelegate.persistentContainer.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch {
                throw error
            }
        }
        
        appDelegate.persistentContainer = NSPersistentContainer(
            name: "Note"
        )
        
        appDelegate.persistentContainer.loadPersistentStores {
            (store, error) in
        }
    }
    
    required init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
}
