//
//  NotesViewModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import RxRelay
import RxSwift

protocol ViewModelProtocol {
    func errorHandler(error: Error)
}

protocol ContentViewModelProtocol: ViewModelProtocol {
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
        items.accept(fetchFilteredData(name: name))
    }
    
    private func fetchFilteredData(name: String) -> [NoteCellModel] {
        var res = [NoteCellModel]()
        res = notes.filter { model in
            if model.title.lowercased().contains(name.lowercased()) ||
                ((model.descriptionText?.lowercased().contains(name.lowercased())) ?? false) {
                return true
            }
            return false
        }.map(NoteCellModel.init)
        return res
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
        var neededCell = items.value[indexPath.row] as! NoteCellModel
        let neededNote = notes.filter({ $0.id == neededCell.id }).first
        router.moveToDetailViewController(data: neededNote)
    }
    
    func removeElement(indexPath: IndexPath) {
        var neededCell = items.value[indexPath.row] as! NoteCellModel
        let neededNote = notes.filter({ $0.id == neededCell.id }).first
        do {
            try notesDataManager.removeData(id: neededNote!.id)
        } catch {
            errorHandler(error: error)
        }
        notes.removeAll(where: { $0.id == neededNote?.id })
        items.accept(notes.map(NoteCellModel.init))
    }
    
    func fetchItems() {
        do {
            notes = try notesDataManager.fetchAllData()
        } catch {
            errorHandler(error: error)
        }
        
        items.accept(notes.map(NoteCellModel.init))
    }
    
    func errorHandler(error: Error) {
        router.showAlert(title: "Error",
                         error: error,
                         msgWithError: nil,
                         action: nil)
    }
}
