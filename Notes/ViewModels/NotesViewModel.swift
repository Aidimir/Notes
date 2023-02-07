//
//  NotesViewModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import RxRelay
import RxSwift

protocol ContentViewModelProtocol {
    var items: BehaviorRelay<[CellModelProtocol]> { get }
    func removeElement(indexPath: IndexPath)
    func fetchDataByName(name: String)
    func didTapOnRow(indexPath: IndexPath)
    func fetchItems()
    func didTapOnAddButton()
    init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol)
}

class NotesViewModel: ContentViewModelProtocol {
    
    private lazy var notes = [Note]()
    
    private let router: MainPageRouterProtocol
    
    public let items: RxRelay.BehaviorRelay<[CellModelProtocol]> = BehaviorRelay(value: [NoteCellModel]())
    
    private let notesDataManager: NotesDataManagerProtocol
    
    public func fetchDataByName(name: String) {
        if name.isEmpty {
            fetchItems()
        } else {
            items.accept(items.value.filter({ cellModel in
                if let model = cellModel as? NoteCellModel {
                    if model.title.lowercased().contains(name.lowercased()) || ((model.descriptionText?.lowercased().contains(name.lowercased())) ?? false) {
                        return true
                    }
                }
                return false
            })
            )
        }
//        items.accept(notes.map(NoteCellModel.init))
    }
    
    required init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol) {
        self.notesDataManager = notesDataManager
        self.router = router
        fetchItems()
    }
    
    func didTapOnAddButton() {
        router.moveToDetailViewController(data: nil)
    }
    
    func didTapOnRow(indexPath: IndexPath) {
        router.moveToDetailViewController(data: notes[indexPath.row])
    }
    
    func removeElement(indexPath: IndexPath) {
        let element = notes[indexPath.row]
        notesDataManager.removeData(id: element.id)
        notes.remove(at: indexPath.row)
        items.accept(notes.map(NoteCellModel.init))
    }
    
    func fetchItems() {
        let dMAllData = notesDataManager.fetchAllData()
        if dMAllData?.isEmpty ?? true || dMAllData == nil {
            let note = Note(images: [NSRange: UUID](),
                            title: "My first note",
                            descriptionText: "",
                            date: Date(),
                            text: "My first note",
                            textParameters: [NSRange: TextParameter](),
                            currentParameters: TextParameter(),
                            id: UUID())
            
            notes.append(note)
            notesDataManager.saveData(data: note, id: note.id)
        } else {
            notes = notesDataManager.fetchAllData()!
        }
        items.accept(notes.map(NoteCellModel.init))
    }
}
