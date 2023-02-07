//
//  NoteModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation

protocol CellModelProtocol {
    var title: String { get }
    var image: Data? { get }
    var descriptionText: String? { get }
    var date: Date? { get }
}

struct Note: Codable {
    var title: String
    var descriptionText: String?
    var date: Date
    var text: String
    var attributedText: Data? = nil
    var image: Data?
    var currentParameters: TextParameter
    var id: UUID
}

struct NoteCellModel: CellModelProtocol {
    var title: String
    var image: Data?
    var descriptionText: String?
    var date: Date?
    var id: UUID
    
    init(note: Note) {
        self.title = note.title
        self.image = note.image
        self.descriptionText = note.descriptionText
        self.date = note.date
        self.id = note.id
    }
}
