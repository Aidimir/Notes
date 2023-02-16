//
//  NotesViewController.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol NotesViewProtocol {
    var viewModel: ContentViewModelProtocol? { get }
}

class NotesViewController: UIViewController, NotesViewProtocol {
    
    private let imageManager: ImageManagerProtocol
    
    private enum Constants {
        static let horizontalPadding = 10
        static let verticalPadding = 20
    }
    
    private let disposeBag = DisposeBag()
    
    public var viewModel: ContentViewModelProtocol?
    
    private let tableView = UITableView()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = .titleFont
        return label
    }()
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search"
        field.layer.cornerRadius = 9
        field.backgroundColor = .secondarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.sizeToFit()
        view.backgroundColor = .white
        
        searchField.delegate = self
        
        addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        
        layloutSubviews()
        
        setBindings()
    }
    
    required init(imageManager: ImageManagerProtocol) {
        self.imageManager = imageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBindings() {
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: NotesTableViewCell.self)) { index, element, cell in
            cell.setup(model: element)
        }.disposed(by: disposeBag)
        
        searchField.rx.text.orEmpty.subscribe { str in
            if str.isEmpty {
                self.viewModel?.fetchItems()
            } else {
                self.viewModel?.fetchDataByName(name: str)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe { index in
            self.viewModel?.removeElement(indexPath: index)
        }.disposed(by: disposeBag)
    }
    
    private func layloutSubviews() {
        tableView.separatorColor = .clear
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(view.readableContentGuide.snp.left)
            make.width.equalTo(view.readableContentGuide.snp.width).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalTo(view.readableContentGuide.snp.right).offset(-Constants.horizontalPadding)
            make.top.bottom.equalTo(label)
        }
        
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.left.right.equalTo(view.readableContentGuide)
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(Constants.verticalPadding)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(Constants.verticalPadding)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchItems()
    }
    
    @objc private func didTapOnAddButton() {
        viewModel?.didTapOnAddButton()
    }
}

extension NotesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didTapOnRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 10
    }
}
