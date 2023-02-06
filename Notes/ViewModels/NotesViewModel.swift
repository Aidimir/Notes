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
}

class NotesViewModel: ContentViewModelProtocol {
    
    private lazy var notes = [Note]()
    
    public let items: RxRelay.BehaviorRelay<[CellModelProtocol]> = BehaviorRelay(value: [NoteCellModel]())
    
    private let disposeBag = DisposeBag()
    
    public func fetchDataByName(name: String) {
        let note = Note(images: [NSRange : String](), title: "TEST", descriptionText: "Description", date: Date(), text: "", textParameters: [NSRange : TextParameter](), currentParameters: TextParameter(), id: UUID())
//        notes = [note,note,note,note,note,note]
        notes.append(note)
        items.accept(notes.map(NoteCellModel.init))
    }
}
