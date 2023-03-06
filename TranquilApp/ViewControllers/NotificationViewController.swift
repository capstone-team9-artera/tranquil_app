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
    private let background = UIHostingController(rootView: BackgroundWavesView())
    private let breathingButton = UIButton()
    private let journalButton = UIButton()
    private let historyButton = UIButton()
    private let aiChatbotButton = UIButton()
    private let name = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = UIColor(SECONDARY_TEXT_COLOR)
        view.self = myView
        title = ""
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

        name.textAlignment = .center
        name.text = "What Exercise Will Soothe Your Anxiety Right Now?"
        name.textColor = UIColor(SECONDARY_TEXT_COLOR)
        name.frame = CGRect(x: 25, y: 100, width: 350, height: 70)
        name.font = .systemFont(ofSize: 25, weight: UIFont.Weight(rawValue: 10))
        name.backgroundColor = UIColor(BACKGROUND_COLOR)
        name.isUserInteractionEnabled = false
        view.addSubview(name)
        
        
        addWaves()
        addBreathingButton()
        addJournalButton()
        addAiChatbotButton()
        
    }
    
    @objc private func addWaves(){
        background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.didMove(toParent: self)
        background.modalPresentationStyle = .fullScreen
        view.insertSubview(background.view, at: 0)
    }
    
    @objc private func addBreathingButton() {
        breathingButton.setTitle("Press to go to Breathing Exercises", for: .normal)
        breathingButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        breathingButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        breathingButton.titleLabel?.textAlignment = .center
        breathingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        view.addSubview(breathingButton)
        breathingButton.backgroundColor = UIColor(SECONDARY_TEXT_COLOR)
        breathingButton.setTitleColor(.white, for: .normal)
        breathingButton.frame = CGRect(x: 35, y:200, width: 330, height: 150)
        breathingButton.layer.cornerRadius = 10
        breathingButton.addTarget(self, action: #selector(didTapBreathingButton), for: .touchUpInside)
    }

    @objc private func addJournalButton() {
        journalButton.setTitle("Press to go to Journal", for: .normal)
        journalButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        journalButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        journalButton.titleLabel?.textAlignment = .center
        journalButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        view.addSubview(journalButton)
        journalButton.backgroundColor = .lightGray
        journalButton.setTitleColor(.white, for: .normal)
        journalButton.frame = CGRect(x: 35, y:375, width: 330, height: 150)
        journalButton.layer.cornerRadius = 10
        journalButton.addTarget(self, action: #selector(didTapJournalButton), for: .touchUpInside)
    }
    
    @objc private func addAiChatbotButton() {
        aiChatbotButton.setTitle("Press to go to ChatBot", for: .normal)
        aiChatbotButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        aiChatbotButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        aiChatbotButton.titleLabel?.textAlignment = .center
        aiChatbotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        view.addSubview(aiChatbotButton)
        aiChatbotButton.backgroundColor = UIColor(SECONDARY_TEXT_COLOR)
        aiChatbotButton.setTitleColor(.white, for: .normal)
        aiChatbotButton.frame = CGRect(x: 35, y:550, width: 330, height: 150)
        aiChatbotButton.layer.cornerRadius = 10
        aiChatbotButton.addTarget(self, action: #selector(didTapAIChatbotButton), for: .touchUpInside)
    }
    @objc private func didTapBreathingButton() {
        let vc = BreathingViewController()
        vc.modalPresentationStyle  = .popover
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapJournalButton() {
        let vc = JournalViewController()
        vc.modalPresentationStyle  = .popover
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapAIChatbotButton() {
        let vc = AIChatbotViewController()
        vc.modalPresentationStyle  = .popover
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
    
}
