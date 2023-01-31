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

    private let breathingButton = UIButton()
    private let journalButton = UIButton()
    private let historyButton = UIButton()
    private let aiChatbotButton = UIButton()
    private let notifButton = UIButton()
    private let name = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        self.title = "Home Page"
        
        name.textAlignment = .center
        name.text = "TRANQUIL"
        name.textColor = .systemTeal
        name.frame = CGRect(x: 25, y: 200, width: 350, height: 52)
        name.font = .systemFont(ofSize: 55, weight: UIFont.Weight(rawValue: 10))
        view.addSubview(name)
       
        addBreathingButton()
        addJournalButton()
        addHistoryButton()
        addAiChatbotButton()
    }
    
    @objc private func addBreathingButton() {
        breathingButton.setTitle("Breathing Exercises", for: .normal)
        view.addSubview(breathingButton)
        breathingButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        breathingButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        breathingButton.titleLabel?.textAlignment = .center
        breathingButton.backgroundColor = .systemTeal
        breathingButton.titleLabel?.textColor = .white
        breathingButton.layer.cornerRadius = 8
        breathingButton.frame = CGRect(x: 25, y:300, width: 165, height: 165)
        breathingButton.addTarget(self, action: #selector(didTapBreathingButton), for: .touchUpInside)

    }

    @objc private func addJournalButton() {
        journalButton.setTitle("Journal", for: .normal)
        view.addSubview(journalButton)
        journalButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        journalButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        journalButton.titleLabel?.textAlignment = .center
        journalButton.titleLabel?.textColor = .white
        journalButton.backgroundColor = .systemGray2
        journalButton.layer.cornerRadius = 8
        journalButton.frame = CGRect(x: 200, y:300, width: 165, height: 165)
        journalButton.addTarget(self, action: #selector(didTapJournalButton), for: .touchUpInside)
    }
    
    @objc private func addHistoryButton() {
        historyButton.setTitle("History", for: .normal)
        view.addSubview(historyButton)
        historyButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        historyButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        historyButton.titleLabel?.textAlignment = .center
        historyButton.backgroundColor = .systemGray2
        historyButton.titleLabel?.textColor = .white
        historyButton.layer.cornerRadius = 8
        historyButton.frame = CGRect(x: 25, y: 500, width: 165, height: 165)
        historyButton.addTarget(self, action: #selector(didTapHistoryButton), for: .touchUpInside)
    }
    
    @objc private func addAiChatbotButton() {
        aiChatbotButton.setTitle("AI Chatbot", for: .normal)
        view.addSubview(aiChatbotButton)
        aiChatbotButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        aiChatbotButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        aiChatbotButton.titleLabel?.textAlignment = .center
        aiChatbotButton.backgroundColor = .systemTeal
        aiChatbotButton.titleLabel?.textColor = .white
        aiChatbotButton.layer.cornerRadius = 8
        aiChatbotButton.frame = CGRect(x: 200, y: 500, width: 165, height: 165)
        aiChatbotButton.addTarget(self, action: #selector(didTapAIChatbotButton), for: .touchUpInside)
    }
    
    @objc private func addNotifButton() {
        notifButton.setTitle("Go to Notification Controller", for: .normal)
        view.addSubview(notifButton)
        notifButton.backgroundColor = .systemGray2
        notifButton.setTitleColor(.white, for: .normal)
        notifButton.frame = CGRect(x: 50, y: 750, width: 300, height: 52)
        notifButton.addTarget(self, action: #selector(didTapNotifButton), for: .touchUpInside)
    }
    
    @objc private func didTapBreathingButton() {
        let rootVC = BreathingViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false)
    }
    
    @objc private func didTapJournalButton() {
        let parent = UIViewController()
        let controller = UIHostingController(rootView: ContentView())
        parent.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        
//        let rootVC = JournalViewController()
//        let navVC = UINavigationController(rootViewController: rootVC)
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: false)
    }

    @objc private func didTapHistoryButton() {
        let rootVC = HistoryViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false)
    }

    @objc private func didTapAIChatbotButton() {
        let rootVC = AIChatbotViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false)
    }

    
    @objc private func didTapNotifButton() {
        let rootVC = NotificationViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(navVC, animated: true)
        present(navVC, animated: false)
    }

}

