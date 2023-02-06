//
//  ImageService.swift
//  Notes
//
//  Created by Айдимир Магомедов on 06.02.2023.
//

import Foundation
import UIKit

protocol ImageManagerProtocol {
    func fetchImage(text: String) -> UIImage?
}

class ImageManager: ImageManagerProtocol {
    func fetchImage(text: String) -> UIImage? {
        //
        return nil
    }
}
