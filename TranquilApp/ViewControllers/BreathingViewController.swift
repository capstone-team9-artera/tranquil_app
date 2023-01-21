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
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .systemCyan
        view = myView
        title = "Breathing Exercises"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .done, target: self, action: #selector(dismissSelf))
        button.setTitle("Empty Button", for: .normal)
        button.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        view.addSubview(button)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 35, y:160, width: 330, height: 600)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
//        let vc = NotificationViewController()
//        vc.modalPresentationStyle  = .popover
//        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.popViewController(animated: true)
//        present(vc, animated: true)
        let parent = UIViewController()
        let controller = UIHostingController(rootView: BreathingView())
//        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)

    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
//        self.navigationItem.setHidesBackButton(true, animated:true)
    }
}

