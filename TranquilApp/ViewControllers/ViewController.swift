//
//  ViewController.swift
//  TranquilApp
//
// https://www.youtube.com/watch?v=Ime8NK5NLgc
//  Created by Heather Dinh on 1/18/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    let breathingButton = UIButton()
    let notifButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        let parent = UIViewController()
//        child.view.translatesAutoresizingMaskIntoConstraints = false
//        child.view.frame = parent.view.bounds
//        // First, add the view of the child to the view of the parent
//        parent.view.addSubview(child.view)
//        // Then, add the child to the parent
//        parent.addChild(child)

        view.backgroundColor = .systemBlue
        self.title = "Home Page"
        breathingButton.setTitle("Go to Breathing Controller", for: .normal)
        view.addSubview(breathingButton)
        breathingButton.backgroundColor = .white
        breathingButton.setTitleColor(.black, for: .normal)
        breathingButton.frame = CGRect(x: 50, y:200, width: 300, height: 52)
        breathingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        notifButton.setTitle("Go to Notification Controller", for: .normal)
        view.addSubview(notifButton)
        notifButton.backgroundColor = .white
        notifButton.setTitleColor(.black, for: .normal)
        notifButton.frame = CGRect(x: 50, y:500, width: 300, height: 52)
        notifButton.addTarget(self, action: #selector(didTapNotifButton), for: .touchUpInside)
//
//        // Do any additional setup after loading the view.
    }

    @objc private func didTapButton() {
        let rootVC = BreathingViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(navVC, animated: true)
        present(navVC, animated: false)
//        navigationController?.pushViewController(parent, animated: true)


    }
    
    @objc private func didTapNotifButton() {
        let rootVC = NotificationViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(navVC, animated: true)
        present(navVC, animated: false)
    }

}

//class SecondViewController: UIViewController {
//    private let button = UIButton()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemRed
//        title = "Welcome"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissSelf))
//        button.setTitle("Push another View Controller", for: .normal)
//        view.addSubview(button)
//        button.backgroundColor = .white
//        button.setTitleColor(.black, for: .normal)
//        button.frame = CGRect(x: 100, y:100, width: 200, height: 52)
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//    }
//
//    @objc private func didTapButton() {
//        let vc = ThirdViewController()
//        vc.modalPresentationStyle  = .popover
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc private func dismissSelf() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
