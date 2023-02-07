//
//  DetailViewModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import RxRelay

protocol DetailViewModelProtocol {
    var text: BehaviorRelay<String> { get }
    var images: BehaviorRelay<[NSRange: UIImage]?> { get set }
    //    var parameters: BehaviorRelay<[NSRange: TextParameter]>
    func didTapOnReadyButton()
    init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol, note: Note?, imageManager: ImageManagerProtocol)
}

class DetailViewModel: DetailViewModelProtocol {
    
    var images: RxRelay.BehaviorRelay<[NSRange: UIImage]?> = BehaviorRelay(value: nil)
    
    var text: RxRelay.BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let notesDataManager: NotesDataManagerProtocol
    
    private let router: MainPageRouterProtocol
    
    private let imageManager: ImageManagerProtocol
    
    private var note: Note?
    
    func didTapOnReadyButton() {
        var imgs = [NSRange: UUID]()
        images.value?.forEach({ key, value in
            let img = imageManager.fetchByDataOrSave(data: value.pngData())
            if img.1 != nil {
                imgs[key] = img.1
            }
        })
        
        let oldText = note?.text
        
        if var note = note {
            if text.value.isEmpty {
                notesDataManager.removeData(id: note.id)
                return 
            }
            var imgs = [NSRange: UUID]()
            
            images.value?.forEach({ key, value in
                let img = imageManager.fetchByDataOrSave(data: value.pngData())
                if img.1 != nil {
                    imgs[key] = img.1
                }
            })
            
            note.images = imgs
            
            if note.text != oldText {
                note.date = Date()
            }
            
            note.text = text.value
            note.title = "NEW NOTE"
            note.descriptionText = text.value
            notesDataManager.saveData(data: note, id: note.id)
        } else {
            if !text.value.isEmpty {
                note = Note(images: imgs,
                            title: "NEW NOTE",
                            date: Date(),
                            text: text.value,
                            textParameters: [NSRange : TextParameter](),
                            currentParameters: TextParameter(),
                            id: UUID())
                
                notesDataManager.saveData(data: note!, id: note!.id)
            }
        }
    }
    
    required init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol, note: Note?, imageManager: ImageManagerProtocol) {
        self.notesDataManager = notesDataManager
        self.router = router
        self.note = note
        self.imageManager = imageManager
        
        if note != nil {
            text.accept(note?.text ?? "")
        }
    }
}
