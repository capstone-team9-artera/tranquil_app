//
//  JournalViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/20/23.
//

import SwiftUI

class JournalViewController: UIViewController {
    private let myView = UIView(frame: CGRect())
    private let textField = UITextField(frame: CGRect(x: 100, y: 450, width: 200, height: 21))
    private let journalText = UILabel(frame: CGRect(x: 100, y: 400, width: 200, height: 21))

    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .systemCyan
        view = myView
        title = "Journal Entries"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))


        view.backgroundColor = .white
        view.addSubview(journalText)
        journalText.text = "Journal Entry"
        journalText.textColor = .black
        journalText.textAlignment = .center
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "Entry here"
        view.addSubview(textField)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }

}
