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
    private let quickSession = SessionViewController()
    private let homeostasisSession = SessionViewController()
    private let decompressionSession = SessionViewController()
    private let customSession = SessionViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        title = "Breathing Exercises"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        
        
        quickSession.name = "QuickSession"
        quickSession.gifName = "sunsetocean"
        quickSession.loadViewIfNeeded()
        
        homeostasisSession.name = "Homeostasis"
        homeostasisSession.gifName = "waterfall"
        homeostasisSession.loadViewIfNeeded()
        
        decompressionSession.name = "Decompression"
        decompressionSession.gifName = "nightsky"
        decompressionSession.loadViewIfNeeded()
        
        customSession.name = "Custom"
        customSession.gifName = "sand"
        customSession.loadViewIfNeeded()
        
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
