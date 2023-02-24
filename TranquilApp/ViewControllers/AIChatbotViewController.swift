//
//  AIChatbotViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/20/23.
//

import SwiftUI
import CoreData

class AIChatbotViewController: UIViewController {
    private let myView = UIView(frame: CGRect())
    
    private let context = PersistenceController.preview.container.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        title = "AI Chatbot"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        let controller = UIHostingController(rootView: AIChatbotView())
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
        
        let newCount = AICount(context: context)
        newCount.timestamp = Date()
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }

    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }

}
