//
//  NotesDataManager.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import CoreData

protocol NotesDataManagerProtocol: DataManagerProtocol {
    func saveData(data: Codable, id: UUID)
    func removeData(id: UUID)
    func fetchData(id: UUID) -> Note?
    func fetchAllData() -> [Note]?
}

class NotesDataManager: DataManager, NotesDataManagerProtocol {
    
    private func convertDataToNote(data: Data?) -> Note? {
        guard let data = data else { return nil }
        do {
            let result = try JSONDecoder().decode(Note.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    func fetchData(id: UUID) -> Note? {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id LIKE %@", id.uuidString
        )
        
        var noteEntity: NoteEntity? = nil
        
        do {
            noteEntity = try context.fetch(fetchRequest).first
            
            if let noteEntity = noteEntity {
                let note = convertDataToNote(data: noteEntity.noteObject)
                return note
            }
            
            return nil
        } catch {
            return nil
        }
    }
    
    func fetchAllData() -> [Note]? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        var noteEntities: [NoteEntity]? = nil
        
        do {
            noteEntities = try context.fetch(fetchRequest)
            
            if let noteEntities = noteEntities {
                var res = [Note]()
                noteEntities.forEach { entity in
                    if entity.noteObject != nil {
                        if let converted = convertDataToNote(data: entity.noteObject!) {
                            res.append(converted)
                        }
                    }
                }
                
                return res
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func saveData(data: Codable, id: UUID) {
        let context = appDelegate.persistentContainer.viewContext
        let existingEntity = fetchEntity(id: id)
        if existingEntity != nil {
            existingEntity?.noteObject = data.saveAsJsonData()
            do {
                try context.save()
            } catch let error as NSError {
                print("Didn't save to core data")
                print(error.localizedDescription)
            }
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: context) else { return }
        let object = NoteEntity(entity: entity, insertInto: context)
        object.noteObject = data.saveAsJsonData()
        object.id = id
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Didn't save to core data")
            print(error)
        }
    }
    
    func removeData(id: UUID) {
        let fetchRequest: NSFetchRequest<NoteEntity>
        fetchRequest = NoteEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id LIKE %@", id.uuidString
        )
        fetchRequest.includesPropertyValues = false
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let object = try context.fetch(fetchRequest).first
            
            if object != nil {
                context.delete(object!)
                try context.save()
            }
        } catch let error {
            print(error)
        }
    }
    
    private func fetchEntity(id: UUID) -> NoteEntity? {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id LIKE %@", id.uuidString
        )
        
        do {
            let entity = try context.fetch(fetchRequest).first
            return entity
        } catch let error {
            print(error)
            return nil
        }
    }
}
