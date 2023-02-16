//
//  ImageService.swift
//  Notes
//
//  Created by Айдимир Магомедов on 06.02.2023.
//

import Foundation
import UIKit
import CoreData

protocol ImageManagerProtocol: DataManagerProtocol {
    func fetchImage(id: UUID) throws -> UIImage?
    func saveImage(image: UIImage) throws -> UUID?
    func fetchByDataOrSave(data: Data?) throws -> (UIImage?, UUID?)
    func removeImage(id: UUID) throws
}

class ImageManager: DataManager, ImageManagerProtocol {
    
    func fetchByDataOrSave(data: Data?) throws -> (UIImage?, UUID?) {
        guard let data = data else { return (nil, nil) }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        var photoEntities: [PhotoEntity]? = nil
        
        do {
            photoEntities = try context.fetch(fetchRequest)
            if let photoEntities = photoEntities {
                for i in photoEntities {
                    if i.image == data {
                        return (UIImage(data: data), i.id)
                    }
                }
            }
            
            return (nil, nil)
        } catch {
            throw error
        }
    }
    
    func removeImage(id: UUID) throws {
        let fetchRequest: NSFetchRequest<PhotoEntity>
        fetchRequest = PhotoEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", id.uuidString
        )
        fetchRequest.includesPropertyValues = false
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let object = try context.fetch(fetchRequest).first
            
            if object != nil {
                context.delete(object!)
                try context.save()
            }
        } catch {
            throw error
        }
    }
    
    func saveImage(image: UIImage) throws -> UUID? {
        let context = appDelegate.persistentContainer.viewContext
        let id = UUID()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoEntity", in: context) else { return nil }
        
        let object = PhotoEntity(entity: entity, insertInto: context)
        
        guard let data = image.pngData() else { return nil }
        
        object.image = data
        object.id = id
        
        do {
            try context.save()
        } catch {
            throw error
        }
        
        return id
    }
    
    func fetchImage(id: UUID) throws -> UIImage? {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", id.uuidString
        )
        
        var photoEntity: PhotoEntity? = nil
        
        do {
            photoEntity = try context.fetch(fetchRequest).first
            
            if let photoEntity = photoEntity {
                guard let data = photoEntity.image else { return nil }
                return UIImage(data: data)
            }
            
            return nil
        }
        catch {
            throw error
        }
    }
}
