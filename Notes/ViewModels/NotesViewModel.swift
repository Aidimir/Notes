//
//  NotesViewModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import RxRelay

class NotesViewModel {
    public let notes: BehaviorRelay<[Note]> = BehaviorRelay(value: [Note]())
    
    public func fetchNotes(text: String) {
        //
    }
}
