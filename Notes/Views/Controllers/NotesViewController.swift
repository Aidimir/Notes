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

class NotesViewController: UIViewController {
    
    private enum Constants {
        static let horizontalPadding = 10
        static let verticalPadding = 20
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = NotesViewModel()
    
    private let tableView = UITableView()
    
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
        
        searchField.delegate = self
        
        tableView.separatorColor = .clear
        
        setBindings()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.horizontalPadding)
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(Constants.horizontalPadding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.left.right.height.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(Constants.verticalPadding)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(Constants.verticalPadding)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setBindings() {
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.notes.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: NotesTableViewCell.self)) { index, element, cell in
//            cell.setup
        }.disposed(by: disposeBag)
        
        searchField.rx.text.orEmpty.throttle(.milliseconds(100), scheduler: MainScheduler()).subscribe { str in
            self.viewModel.fetchNotes(text: str)
        }.disposed(by: disposeBag)
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
        //
    }
}
