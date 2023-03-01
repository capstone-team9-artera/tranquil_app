//
//  ViewController.swift
//  TranquilApp
//
// https://www.youtube.com/watch?v=Ime8NK5NLgc
//  Created by Heather Dinh on 1/18/23.
//

import UIKit
import SwiftUI
import CoreData
import AVFoundation

class ViewController: UIViewController {

    private let universalSize = UIScreen.main.bounds
    @State var isAnimated = false
    private var timer: Timer?
    private var timer1: Timer?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items:[HeartRate]?
    private var lastHeartRate = 0
    private var variability = 0
    private let notify = NotificationHandler()
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    private var audioPlayer = AVAudioPlayer()

    private let breathingButton = UIButton()
    private let journalButton = UIButton()
    private let statisticsButton = UIButton()
    private let aiChatbotButton = UIButton()
    private let notifButton = UIButton()
    private let name = UILabel()
    private let heartRateLabel = UILabel()
    private let heartRateImage = UIImage(systemName: "heart.fill")
    private let heartRateView = UIImageView()
    private let background = UIHostingController(rootView: BackgroundWavesView())
    
    private func welcomeAnimation() {
        UIView.animate(withDuration: 1, delay: 0.8, animations: {
            self.name.frame = CGRect(x: 25, y: 200, width: 350, height: 52)
            self.breathingButton.layer.opacity = 0.75
            self.journalButton.layer.opacity = 0.75
            self.historyButton.layer.opacity = 0.75
            self.aiChatbotButton.layer.opacity = 0.75
            self.heartRateView.layer.opacity = 1
            self.heartRateLabel.layer.opacity = 1
        })
    }
    
    // animation when opening the app
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {self.welcomeAnimation()})

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // comment this out so it doesn't keep crashing !!!
        timer = Timer.scheduledTimer(timeInterval: 5.0, target:self, selector: #selector(getHeartRate), userInfo: nil, repeats: true)
        notify.askPermission()
        
        //play music
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ocean", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            print("music ready")
            } catch {
                   print("music error ", error)
            }
        audioPlayer.play()

       
        view.backgroundColor = .white
        self.title = "Home Page"
        
        addBreathingButton()
        addJournalButton()
        addStatisticsButton()
        addAiChatbotButton()
        addHeartRateView()
        
        name.textAlignment = .center
        name.text = "TRANQUIL"
        name.textColor = UIColor(SECONDARY_TEXT_COLOR)
        name.frame = CGRect(x: 25, y: 350, width: 350, height: 52)
        name.font = .systemFont(ofSize: 65, weight: UIFont.Weight(rawValue: 10))
        view.addSubview(name)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .purple
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        timer1 = Timer.scheduledTimer(timeInterval: 117, target:self, selector: #selector(playMusic), userInfo: nil, repeats: true)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        addBackgroundWaves()
    }
    
    @objc private func playMusic(){
        audioPlayer.play()
    }
    
    @objc private func getHeartRate(){
        
        let fetchRequest = NSFetchRequest<HeartRate>(entityName: "HeartRate")
        let sort = NSSortDescriptor(key: #keyPath(HeartRate.timestamp), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            items = try context.fetch(HeartRate.fetchRequest())
        } catch {
            print("Cannot fetch Expenses")
        }
        let length = items!.count
        if lastHeartRate != 0{
            //algorithm
            let currentHeartRate = Int(items![(length - 1)].value)
            print("length ", length)
            print("Heart ", currentHeartRate)
            variability = Int(items![(length - 1)].value) - lastHeartRate
            if(variability > 7 && currentHeartRate > 85){
                print(true)
                notify.sendNotification()
                connectivityManager.send(String("notify"))
                //increase anxiety count
                let newAnxiety = AnxietyCount(context: context)
                newAnxiety.timestamp = items![(length - 1)].timestamp
                newAnxiety.value = items![(length - 1)].value

                do {
                    try context.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                didTapNotifButton()
            }
            lastHeartRate = currentHeartRate
            
        }
        else{
            print("length ", length)
            lastHeartRate = Int(items![(length - 1)].value)
            print("lastHeartRate value ", lastHeartRate)
        }
   }
    
    @objc private func addHeartRateView() {
        heartRateLabel.text = String("\(lastHeartRate)")
        heartRateLabel.textColor = SECONDARY_TEXT_UICOLOR
        heartRateLabel.frame = CGRect(x: 350, y: 75, width: 25, height: 25)
        heartRateLabel.layer.opacity = 0
        heartRateView.image = heartRateImage
        heartRateView.frame = CGRect(x: 320, y: 79, width: 25, height: 20)
        heartRateView.layer.opacity = 0
        heartRateView.tintColor = SECONDARY_TEXT_UICOLOR
        
        view.addSubview(heartRateLabel)
        view.addSubview(heartRateView)
    }
    
    @objc private func addBackgroundWaves() {
        background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.didMove(toParent: self)
        background.modalPresentationStyle = .fullScreen
        view.insertSubview(background.view, at: 0)
    }
    
    @objc private func addBreathingButton() {
        breathingButton.setTitle("Breathing Exercises", for: .normal)
        view.addSubview(breathingButton)
        breathingButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        breathingButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        breathingButton.titleLabel?.textAlignment = .center
        breathingButton.backgroundColor = SECONDARY_TEXT_UICOLOR
        breathingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        breathingButton.titleLabel?.textColor = .white
        breathingButton.layer.opacity = 0.0
        breathingButton.layer.cornerRadius = 8
        breathingButton.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8).cgColor
        breathingButton.layer.shadowOpacity = 0.8
        breathingButton.layer.shadowRadius = 4
        breathingButton.layer.shadowOffset = CGSizeMake(1, 1)
        breathingButton.frame = CGRect(x: 20, y:300, width: 170, height: 170)
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
        journalButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        journalButton.layer.opacity = 0.0
        journalButton.layer.cornerRadius = 8
        journalButton.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8).cgColor
        journalButton.layer.shadowOpacity = 0.8
        journalButton.layer.shadowRadius = 4
        journalButton.layer.shadowOffset = CGSizeMake(1, 1)
        journalButton.frame = CGRect(x: 205, y:300, width: 170, height: 170)
        journalButton.addTarget(self, action: #selector(didTapJournalButton), for: .touchUpInside)
    }
    
    @objc private func addStatisticsButton() {
        statisticsButton.setTitle("Statistics", for: .normal)
        view.addSubview(statisticsButton)
        statisticsButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        statisticsButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        statisticsButton.titleLabel?.textAlignment = .center
        statisticsButton.backgroundColor = .systemGray2
        statisticsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        statisticsButton.titleLabel?.textColor = .white
        statisticsButton.layer.opacity = 0.0
        statisticsButton.layer.cornerRadius = 8
        statisticsButton.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8).cgColor
        statisticsButton.layer.shadowOpacity = 0.8
        statisticsButton.layer.shadowRadius = 4
        statisticsButton.layer.shadowOffset = CGSizeMake(1, 1)
        statisticsButton.frame = CGRect(x: 20, y: 500, width: 170, height: 170)
        statisticsButton.addTarget(self, action: #selector(didTapStatisticsButton), for: .touchUpInside)
    }
    
    @objc private func addAiChatbotButton() {
        aiChatbotButton.setTitle("AI Chatbot", for: .normal)
        view.addSubview(aiChatbotButton)
        aiChatbotButton.titleLabel?.numberOfLines = 0 // 0 indicates dynamic
        aiChatbotButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        aiChatbotButton.titleLabel?.textAlignment = .center
        aiChatbotButton.backgroundColor = SECONDARY_TEXT_UICOLOR
        aiChatbotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        aiChatbotButton.titleLabel?.textColor = .white
        aiChatbotButton.layer.opacity = 0.0
        aiChatbotButton.layer.cornerRadius = 8
        aiChatbotButton.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8).cgColor
        aiChatbotButton.layer.shadowOpacity = 0.8
        aiChatbotButton.layer.shadowRadius = 4
        aiChatbotButton.layer.shadowOffset = CGSizeMake(1, 1)
        aiChatbotButton.frame = CGRect(x: 205, y: 500, width: 170, height: 170)
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
        navVC.view.inputViewController?.loadView()
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false)
    }
    
    @objc private func didTapJournalButton() {
        let rootVC = JournalViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false)
    }

    @objc private func didTapStatisticsButton() {
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
        present(navVC, animated: false)
    }
}

