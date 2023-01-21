//
//  NotificationViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/18/23.
//
import SwiftUI

class NotificationViewController: UIViewController {
    private let button = UIButton()
    private let myView = UIView(frame: CGRect())
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .systemRed
        view.self = myView
        title = "Notification from HRV Spike"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))
        button.setTitle("Press to go from notification to Breathing View", for: .normal)
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
        let vc = BreathingViewController()
        vc.modalPresentationStyle  = .popover
        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.popViewController(animated: true)
//        present(vc, animated: true)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
