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
    init(imagePickerController: ImagePickerProtocol)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    private let disposeBag = DisposeBag()
    
    private var textView: UITextView!
    
    public var viewModel: DetailViewModelProtocol?
    
    private var imagePickerController: ImagePickerProtocol
    
    private var addImageButton: UIButton!
    
    required init(imagePickerController: ImagePickerProtocol) {
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
            if let data = viewModel?.attributedStringData.value {
                do {
                    let attributedStr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
                    textView.attributedText = attributedStr
                } catch {
                    print(error)
                }
            }
            textView.font = .mediumSizeBoldFont
            textView.contentScaleFactor = 8
            textView.autocapitalizationType = .sentences
            textView.isSelectable = true
            textView.isEditable = true
            textView.autocorrectionType = UITextAutocorrectionType.yes
            textView.spellCheckingType = UITextSpellCheckingType.yes
            textView.textAlignment = NSTextAlignment.justified
            return textView
        }()
        prepareTextImages()
        
        addImageButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.width.left.right.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(addImageButton.snp.top)
        }
    }
    
    private func setBindings() {
        guard let viewModel = viewModel else { return }
        textView.rx.text.orEmpty.bind(to: viewModel.text).disposed(by: disposeBag)
        
        textView.rx.text.throttle(.milliseconds(500), scheduler: MainScheduler()).subscribe { str in
            viewModel.didTapOnReadyButton()
        }.disposed(by: disposeBag)

        
        imagePickerController.chosenImages.filter({ $0 != nil }).subscribe { [weak self] image in
            guard let self = self else { return }
            let attributedString = NSMutableAttributedString(attributedString: self.textView.attributedText!)
            let textAttachment = NSTextAttachment()
            textAttachment.image = image
            
            let oldWidth = textAttachment.image!.size.width;
            
            let scaleFactor = oldWidth / (self.textView.frame.size.width); //for the padding inside the textView
            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            
            let aspect = textAttachment.image!.size.width / textAttachment.image!.size.height
            textAttachment.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width / aspect )
            
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.replaceCharacters(in: (self.textView.selectedRange), with: attrStringWithImage)
            self.textView.attributedText = attributedString;
            self.textView.font = .mediumSizeBoldFont
            self.setImageAsMain()
            self.textView.reloadInputViews()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            let textData = try textView.attributedText.data(from: .init(location: 0, length: textView.attributedText.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            viewModel?.attributedStringData.accept(textData)
        } catch {
            print(error)
        }
        viewModel?.didTapOnReadyButton()
    }
    
    @objc private func presentImagePicker() {
        imagePickerController.showImagePickerOptions()
    }
    
    private func prepareTextImages() {
        let width = CGRectGetWidth(self.view.frame)
        
        setImageAsMain()
        
        textView.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: textView!.attributedText.length), options: [], using: { [width] (object, range, pointer) in
            let textViewAsAny: Any = self.textView!
            if let attachment = object as? NSTextAttachment,
               let img = attachment.image(forBounds: self.textView.bounds, textContainer: textViewAsAny as? NSTextContainer, characterIndex: range.location) {
                if attachment.fileType == "public.png" {
                    let aspect = img.size.width / img.size.height
                    if img.size.width <= width {
                        attachment.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                        return
                    }
                    let height = width / aspect
                    attachment.bounds = CGRect(x: 0, y: 0, width: width, height: height)
                }
            }
        })
    }
    
    private func setImageAsMain() {
        var isFirst = false
        textView.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: textView.attributedText.length)) { object, range, pointer in
            if let atachment = object as? NSTextAttachment, let img = atachment.image(forBounds: self.textView.bounds, textContainer: textView as! Any as? NSTextContainer, characterIndex: range.location), !isFirst {
                viewModel?.mainImage = img.pngData()
                isFirst = true
            }
        }
    }
}
