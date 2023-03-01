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
        
        // configuring nav bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SECONDARY_TEXT_UICOLOR]
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: SECONDARY_TEXT_UICOLOR]
        appearance.buttonAppearance = buttonAppearance
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        // configuring session biew controllers
        quickSession.name = "Balance"
        quickSession.gifName = "sunsetocean"
        quickSession.loadViewIfNeeded()
        
        homeostasisSession.name = "Relax"
        homeostasisSession.gifName = "waterfall"
        homeostasisSession.loadViewIfNeeded()
        
        decompressionSession.name = "Tranquil"
        decompressionSession.gifName = "nightsky"
        decompressionSession.loadViewIfNeeded()
        
        customSession.name = "Focus"
        customSession.gifName = "sand"
        customSession.loadViewIfNeeded()
        
        let pageView = PageView(pages: [quickSession, homeostasisSession, decompressionSession, customSession])
        
        let controller = UIHostingController(rootView: pageView)
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        view.addSubview(controller.view)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}
