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
    func fetchDataByName(name: String)
    func didTapOnRow(indexPath: IndexPath)
    init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol)
}

class NotesViewModel: ContentViewModelProtocol {
    
    private lazy var notes = [Note]()
    
    private let router: MainPageRouterProtocol
    
    public let items: RxRelay.BehaviorRelay<[CellModelProtocol]> = BehaviorRelay(value: [NoteCellModel]())
    
    private let notesDataManager: NotesDataManagerProtocol
    
    public func fetchDataByName(name: String) {
//        items.accept(notes.map(NoteCellModel.init))
    }
    
    required init(notesDataManager: NotesDataManagerProtocol, router: MainPageRouterProtocol) {
        self.notesDataManager = notesDataManager
        self.router = router
        let dMAllData = notesDataManager.fetchAllData()
        if dMAllData?.isEmpty ?? true || dMAllData == nil {
            let note = Note(images: [NSRange: UUID](), title: "My first note", descriptionText: "", date: Date(), text: "", textParameters: [NSRange: TextParameter](), currentParameters: TextParameter(), id: UUID())
            notes.append(note)
        } else {
            notes = notesDataManager.fetchAllData()!
        }
        items.accept(notes.map(NoteCellModel.init))
    }
    
    func didTapOnRow(indexPath: IndexPath) {
        router.moveToDetailViewController(data: notes[indexPath.row])
        items.accept(notes.map(NoteCellModel.init))
        print(notes.count)
        print(items.value.count)
    }
}
