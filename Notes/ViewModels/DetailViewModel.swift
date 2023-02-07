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
//    var images: BehaviorRelay<[NSRange: UIImage]?> { get set }
    //    var parameters: BehaviorRelay<[NSRange: TextParameter]>
    var attributedStringData: BehaviorRelay<Data?> { get }
    var mainImage: Data? { get set }
    func didTapOnReadyButton()
    init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol, note: Note?, imageManager: ImageManagerProtocol)
}

class DetailViewModel: DetailViewModelProtocol {
    
    var attributedStringData: RxRelay.BehaviorRelay<Data?> = BehaviorRelay(value: nil)
        
    var text: RxRelay.BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var mainImage: Data?
    
    private let notesDataManager: NotesDataManagerProtocol
    
    private let router: MainPageRouterProtocol
    
    private let imageManager: ImageManagerProtocol
    
    private var note: Note?
    
    func didTapOnReadyButton() {
        let oldText = note?.text
        
        if var note = note {
            if text.value.isEmpty {
                notesDataManager.removeData(id: note.id)
                return 
            }
            
            if note.text != oldText {
                note.date = Date()
            }
            
            note.text = text.value
            note.attributedText = attributedStringData.value
            note.title = text.value.firstNotEmptyLine ?? ""
            note.image = mainImage
            note.descriptionText = text.value.secondNotEmptyLine ?? ""
            notesDataManager.saveData(data: note, id: note.id)
        } else {
            if !text.value.isEmpty {
                note = Note(title: text.value.firstNotEmptyLine ?? "",
                            descriptionText: text.value.secondNotEmptyLine ?? "",
                            date: Date(),
                            text: text.value,
                            attributedText: attributedStringData.value,
                            image: mainImage,
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
        self.mainImage = note?.image
        
        if note != nil {
            text.accept(note?.text ?? "")
            attributedStringData.accept(note?.attributedText)
        }
    }
}
