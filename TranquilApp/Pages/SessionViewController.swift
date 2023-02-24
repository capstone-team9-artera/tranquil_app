//
//  Session2.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/18/23.
//
import SwiftUI
import CoreData

class SessionViewController: UIViewController {
    var name: String = "Default"
    var prompt: String = "Default description"
    var gifName: String = "sunsetocean"
    
    private let label = UILabel()
    private let promptLabel = UILabel()
    private let myView = UIView(frame: CGRect())
    private let animation = AnimationView()
    
    private let context = PersistenceController.preview.container.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        
        view = myView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        view.addSubview(animation)
        
        label.textAlignment = .center
        label.text = name
        label.textColor = .white
        label.frame = CGRect(x: 25, y: 200, width: 350, height: 52)
        label.font = .systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 5))
        
        promptLabel.textAlignment = .center
        promptLabel.text = prompt
        promptLabel.textColor = .white
        promptLabel.frame = CGRect(x: 25, y: 300, width: 350, height: 52)
        promptLabel.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 3))

        let myGif = UIImage.gifImageWithName(gifName)
        let imageView = UIImageView(image: myGif)
//        let imageView = UIImageView()
        imageView.frame = CGRect(x: 25, y: 20, width: 350, height: 700)
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8).cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOffset = CGSizeMake(5, 5)
        imageView.layer.cornerRadius = 10
        imageView.inputViewController?.modalPresentationStyle = .fullScreen
        
        let controller = UIHostingController(rootView: getSinWave(interval: UIScreen.main.bounds.width, amplitude: 110, baseline: -105 + UIScreen.main.bounds.height/2)
            .foregroundColor(Color.init(red: 0.2, green: 0.4, blue: 0.7).opacity(0.4)))

        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        controller.didMove(toParent: self)
        controller.modalPresentationStyle = .fullScreen
                                    
        view.addSubview(controller.view)

        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(promptLabel)
        view.layer.cornerRadius = 10
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.goToView(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func goToView(_ sender:UITapGestureRecognizer) {
//        print(name)
//        let rootVC = HistoryViewController()
//        let navVC = UINavigationController(rootViewController: HistoryView())
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: false)
        let controller = UIHostingController(rootView: AnimationView(name: name))
//        parent.view.addSubview(controller.view)
        controller.didMove(toParent: self)
//        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
        

        let newCount = BreathingCount(context: context)
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
