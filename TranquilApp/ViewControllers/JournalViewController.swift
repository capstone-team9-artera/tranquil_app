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
        myView.backgroundColor = BACKGROUND_UICOLOR
        view = myView
        title = "Journal"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        
        // configuring nav bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = BACKGROUND_UICOLOR
        appearance.shadowColor = BACKGROUND_UICOLOR
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SECONDARY_TEXT_UICOLOR]
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: SECONDARY_TEXT_UICOLOR]
        appearance.buttonAppearance = buttonAppearance
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        self.edgesForExtendedLayout = UIRectEdge()
        
        let controller = UIHostingController(rootView: ContentView())
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }

}
