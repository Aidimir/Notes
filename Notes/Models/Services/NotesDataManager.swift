//
//  NotesDataManager.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import CoreData

protocol NotesDataManagerProtocol: DataManagerProtocol {
    func saveData(data: Codable, id: UUID) throws -> Void
    func removeData(id: UUID) throws
    func fetchData(id: UUID) throws -> Note?
    func fetchAllData() throws -> [Note]
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
    
    func fetchData(id: UUID) throws -> Note? {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", id.uuidString
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
            throw error
        }
    }
    
    func fetchAllData() throws -> [Note] {
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
                let note = Note(title: "My first note",
                                descriptionText: "",
                                date: Date(),
                                text: "My first note",
                                attributedText: nil,
                                currentParameters: TextParameter(),
                                id: UUID())
                return [note]
            }
        } catch {
            throw error
        }
    }
    
    func saveData(data: Codable, id: UUID) throws {
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let existingEntity = try fetchEntity(id: id)
            
            if existingEntity != nil {
                existingEntity?.noteObject = data.saveAsJsonData()
                try context.save()
            } else {
                guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: context) else { return }
                
                let object = NoteEntity(entity: entity, insertInto: context)
                object.noteObject = data.saveAsJsonData()
                object.id = id
                try context.save()
            }
        } catch {
            throw error
        }
    }
    
    func removeData(id: UUID) throws {
        let fetchRequest: NSFetchRequest<NoteEntity>
        fetchRequest = NoteEntity.fetchRequest()
        
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
    
    private func fetchEntity(id: UUID) throws -> NoteEntity? {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", id.uuidString
        )
        
        do {
            let entity = try context.fetch(fetchRequest).first
            return entity
        } catch {
            throw error
        }
    }
}
