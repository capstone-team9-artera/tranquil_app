//
//  JournalViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/20/23.
//

import SwiftUI

class JournalViewController: UIViewController {
    private let myView = UIView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        title = "Journal"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        let controller = UIHostingController(rootView: HomeView())
        controller.view.frame = CGRect(x: 0, y: 100, width: 400, height: 700)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }

}
