//
//  ViewController.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let notesController = NotesViewController()
        addChild(notesController)
        notesController.view.frame = view.safeAreaLayoutGuide.layoutFrame
        view.addSubview(notesController.view)
        notesController.didMove(toParent: self)
    }


}

