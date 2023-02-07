//
//  DetailViewController.swift
//  Notes
//
//  Created by Айдимир Магомедов on 07.02.2023.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

protocol DetailViewProtocol {
    init(imageManager: ImageManagerProtocol, imagePickerController: ImagePickerProtocol)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    private let disposeBag = DisposeBag()
    
    private var textView: UITextView!
    
    private let imageManager: ImageManagerProtocol
    
    public var viewModel: DetailViewModelProtocol?
    
    private var imagePickerController: ImagePickerProtocol
    
    required init(imageManager: ImageManagerProtocol, imagePickerController: ImagePickerProtocol) {
        self.imageManager = imageManager
        self.imagePickerController = imagePickerController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        layoutSubviews()
        
        setBindings()
    }
    
    private func layoutSubviews() {
        textView = {
            let textView = UITextView()
            textView.backgroundColor = .white
            textView.text = viewModel?.text.value == nil ? "My first note !" : viewModel?.text.value
            textView.font = .mediumSizeBoldFont
            textView.autocapitalizationType = .sentences
            textView.isSelectable = true
            textView.isEditable = true
            textView.autocorrectionType = UITextAutocorrectionType.yes
            textView.spellCheckingType = UITextSpellCheckingType.yes
            textView.textAlignment = NSTextAlignment.justified
            return textView
        }()
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.size.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setBindings() {
        guard let viewModel = viewModel else { return }
        textView.rx.text.orEmpty.bind(to: viewModel.text).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.didTapOnReadyButton()
    }
    
    @objc private func presentImagePicker() {
    }
}

//let textView = UITextView(frame: CGRectMake(50, 50, 200, 300))
//let attributedString = NSMutableAttributedString(string: "before after")
//let textAttachment = NSTextAttachment()
//textAttachment.image = UIImage(named: "sample_image.jpg")!
//
//let oldWidth = textAttachment.image!.size.width;
//
//let scaleFactor = oldWidth / (textView.frame.size.width - 10); //for the padding inside the textView
//textAttachment.image = UIImage(CGImage: textAttachment.image!.CGImage, scale: scaleFactor, orientation: .Up)
//var attrStringWithImage = NSAttributedString(attachment: textAttachment)
//attributedString.replaceCharactersInRange(NSMakeRange(6, 1), withAttributedString: attrStringWithImage)
//textView.attributedText = attributedString;
//self.view.addSubview(textView)
