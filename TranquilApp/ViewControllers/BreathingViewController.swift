//
//  BreathingViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/18/23.
//
import SwiftUI

class BreathingViewController: UIViewController {
    private let button = UIButton()
    private let myView = UIView(frame: CGRect())
    private let label = UILabel()

//    private let pageView = PageView(pages: [Session(title: "QuickSession", description: "a quick session", color: Color.blue), Session(title: "Homeostasis", description: "a homeostasis session", color: Color.green), Session(title: "Decompression", description: "decompress", color: Color.purple), Session(title: "Custom", description: "a custom setting", color: Color.pink)])

    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        title = "Breathing Exercises"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        
        let quickSession = SessionViewController()
        quickSession.name = "QuickSession"
        let homeostasisSession = SessionViewController()
        homeostasisSession.name = "Homeostasis"
        let decompressionSession = SessionViewController()
        decompressionSession.name = "Decompression"
        let customSession = SessionViewController()
        customSession.name = "Custom"
        
        let pageView = PageView(pages: [quickSession, homeostasisSession, decompressionSession, customSession])
        
        let controller = UIHostingController(rootView: pageView)
        controller.view.frame = CGRect(x: 0, y:100, width: 400, height: 700)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}
