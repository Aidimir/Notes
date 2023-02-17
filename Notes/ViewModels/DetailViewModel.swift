//
//  DetailViewModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import RxRelay

protocol DetailViewModelProtocol: ViewModelProtocol {
    var text: BehaviorRelay<String> { get }
    var currentTextParameters: TextParameter { get set }
    var attributedStringData: Data? { get set }
    var mainImage: Data? { get set }
    func didTapOnReadyButton()
    init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol, note: Note?, imageManager: ImageManagerProtocol)
}

class DetailViewModel: DetailViewModelProtocol {
    
    var currentTextParameters: TextParameter = TextParameter()
    
    var attributedStringData: Data?
        
    var text: RxRelay.BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var mainImage: Data?
    
    private let notesDataManager: NotesDataManagerProtocol
    
    private let router: MainPageRouterProtocol
    
    private let imageManager: ImageManagerProtocol
    
    private var note: Note?
    
    func didTapOnReadyButton() {
        
        do {
            if var note = note {
                if text.value.isEmpty && mainImage == nil {
                    try notesDataManager.removeData(id: note.id)
                    return
                }
                
                note.text = text.value
                note.attributedText = attributedStringData
                note.title = text.value.firstNotEmptyLine ?? ""
                note.currentParameters = currentTextParameters
                note.image = mainImage
                note.descriptionText = text.value.secondNotEmptyLine ?? ""
                try notesDataManager.saveData(data: note, id: note.id)
            } else {
                    note = Note(title: text.value.firstNotEmptyLine ?? "",
                                descriptionText: text.value.secondNotEmptyLine ?? "",
                                date: Date(),
                                text: text.value,
                                attributedText: attributedStringData,
                                image: mainImage,
                                currentParameters: currentTextParameters,
                                id: UUID())
                    
                    try notesDataManager.saveData(data: note!, id: note!.id)
            }
        } catch {
            errorHandler(error: error)
        }
    }
    
    func errorHandler(error: Error) {
        router.showAlert(title: "Error",
                         error: error,
                         msgWithError: nil,
                         action: nil)
    }
    
    required init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol, note: Note?, imageManager: ImageManagerProtocol) {
        self.notesDataManager = notesDataManager
        self.router = router
        self.note = note
        self.imageManager = imageManager
        self.mainImage = note?.image
        
        if note != nil {
            self.currentTextParameters = note!.currentParameters
            text.accept(note?.text ?? "")
            attributedStringData = note?.attributedText
        }
    }
}
