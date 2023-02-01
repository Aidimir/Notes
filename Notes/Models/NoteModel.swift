//
//  NoteModel.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation

protocol NotesCellProtocol {
    var title: String { get }
    var images: [NSRange: String] { get }
    var description: String? { get }
    var date: Date { get }
}

struct Note: NotesCellProtocol {
    var images: [NSRange: String]
    var title: String
    var description: String?
    var date: Date
    var text: String
    var textParameters: [NSRange: TextParameter]
    var currentParameters: TextParameter
}
