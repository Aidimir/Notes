//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import UIKit
import SnapKit

class NotesTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let horizontalPadding = 10
        
        static let verticalPadding = 10
    }
    
    private var titleLabel: UILabel!
    
    private var descriptionLabel: UILabel!
    
    private var cellImageView: UIImageView!
    
    public func setup(model: CellModelProtocol, imageManager: ImageManagerProtocol? = nil) {
        titleLabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = .mediumSizeBoldFont
            label.textColor = .black
            label.lineBreakMode = .byCharWrapping
            label.text = model.title
            return label
        }()
        
        descriptionLabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = .smallSizeFont
            label.textColor = .gray
            label.lineBreakMode = .byCharWrapping
            let dateStr = model.date?.getFormattedDate(format: "dd MMMM") ?? ""
            label.text = dateStr + " " + (model.descriptionText ?? "")
            return label
        }()
        
        cellImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            imgView.backgroundColor = .lightGray
            imgView.layer.cornerRadius = 20
            imgView.clipsToBounds = true
            if let imgId = model.image {
                imgView.image = imageManager?.fetchImage(id: imgId)
            }
            return imgView
        }()
        
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalPadding)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(Constants.horizontalPadding)
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.readableContentGuide.layoutFrame
    }
}

