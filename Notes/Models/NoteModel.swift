//
//  NoteModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation

protocol CellModelProtocol {
    var title: String { get }
    var image: String? { get }
    var descriptionText: String? { get }
    var date: Date? { get }
}

struct Note: Codable {
    var images: [NSRange: String]
    var title: String
    var descriptionText: String?
    var date: Date
    var text: String
    var textParameters: [NSRange: TextParameter]
    var currentParameters: TextParameter
    var id: UUID
}

struct NoteCellModel: CellModelProtocol {
    var title: String
    var image: String?
    var descriptionText: String?
    var date: Date?
    
    init(note: Note) {
        self.title = note.title
        self.image = note.images.first?.value
        self.descriptionText = note.descriptionText
        self.date = note.date
    }
}
