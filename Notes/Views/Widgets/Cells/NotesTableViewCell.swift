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
    
    private var descriptionLabel: UILabel?
    
    private var cellImageView: UIImageView?
    
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        if model.descriptionText != nil {
            descriptionLabel = {
                let label = UILabel()
                label.textAlignment = .left
                label.font = .smallSizeFont
                label.textColor = .gray
                label.lineBreakMode = .byCharWrapping
                let dateStr = model.date?.getFormattedDate(format: "dd MMMM YYYY") ?? ""
                label.text = dateStr + " " + (model.descriptionText ?? "")
                return label
            }()
            
            contentView.addSubview(descriptionLabel!)
            descriptionLabel!.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalPadding)
                make.bottom.equalToSuperview()
            }
        }
        
        if model.image != nil {
            cellImageView = {
                let imgView = UIImageView()
                imgView.contentMode = .scaleAspectFill
                imgView.backgroundColor = .lightGray
                imgView.layer.cornerRadius = 20
                imgView.clipsToBounds = true
                if let imgData = model.image {
                    imgView.image = UIImage(data: imgData)
                }
                return imgView
            }()
            
            contentView.addSubview(cellImageView!)
            cellImageView!.snp.makeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(Constants.horizontalPadding)
                make.top.bottom.right.equalToSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.readableContentGuide.layoutFrame
    }
    
    override func prepareForReuse() {
        titleLabel.removeFromSuperview()
        cellImageView?.removeFromSuperview()
        descriptionLabel?.removeFromSuperview()
        
        titleLabel = nil
        cellImageView = nil
        descriptionLabel = nil
        super.prepareForReuse()
    }
}
