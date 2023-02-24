//
//  HistoryViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/20/23.
//

import SwiftUI

class HistoryViewController: UIViewController {

    private let myView = UIView(frame: CGRect())
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        title = "Statistics"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        let controller = UIHostingController(rootView: HistoryView())
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
    }

    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }

}
