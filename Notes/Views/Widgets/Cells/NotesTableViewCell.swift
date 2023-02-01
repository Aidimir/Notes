//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import UIKit

class NotesTableViewCell: UITableViewCell {
    public func setup(model: NotesCellProtocol) {
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        textLabel?.font = .mediumSizeBoldFont
        detailTextLabel?.font = .smallSizeFont
        detailTextLabel?.textColor = .gray
        textLabel?.text = model.title
        
        var formattedDate = model.date.formatted(date: .abbreviated, time: .shortened)
        
        let mainImgName = {
            var res = model.images.sorted(by: { $0.key.location < $1.key.location })
            return res.first?.value
        }()
        
        // let imageData = DataManager.shared.fetchImage(imageId: mainImgName)
        // let image = UIImage(data: imageData)
        // self.imageView?.image = model.images
        
        
        detailTextLabel?.text = formattedDate + " " + (model.description ?? " ")
    }
}

