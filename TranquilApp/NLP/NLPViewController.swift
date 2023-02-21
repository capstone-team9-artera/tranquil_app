//
//  NLPViewController.swift
//  TranquilApp
//
//  Created by Heather Dinh on 2/20/23.
//

import UIKit
import CoreML
import NaturalLanguage

class NLPViewController: UIViewController {
    var text = UITextView(frame: CGRect(x: 150, y: 250, width: 200, height: 200))
    var currentQ = UITextView(frame: CGRect(x: 150, y: 200, width: 200, height: 250))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        text.text = "emotion classifier"
        text.font = UIFont(name: "Arial", size: 25)
        currentQ.text = "journal entry"
        currentQ.font = UIFont(name: "Arial", size: 20)
        view.addSubview(currentQ)
        view.addSubview(text)
        setupTabBar()
    }
    
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "NLP based on Twitter Dataset (Kaggle)"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(evalNLP(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Home", style: .plain, target: self, action: #selector(dismissSelf))

    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
    
    
    @objc func evalNLP(_ sender: UIBarButtonItem) {
        
//        let model = IMDBReviewClassifier()
        let model = EmotionSentimentClassifier()
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Anxiety Text"
        }
        let confirmAction = UIAlertAction(title: "Analyze for Sentiment", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if let text = textField.text {
                do {
                    let prediction = try model.prediction(text: text)
//                    if prediction.label == "sadness" {
//                        let cell = Model(text: text, color: UIColor.blue, sentiment: "sadness")
//                        self.cells.append(cell)
//                        self.newCollection.reloadData()
//                    } else if prediction.label == "joy" {
//                        let cell = Model(text: text, color: UIColor.yellow, sentiment: "joy")
//                        self.cells.append(cell)
//                        self.newCollection.reloadData()
//                    } else if prediction.label == "love" {
//                        let cell = Model(text: text, color: UIColor.purple, sentiment: "love")
//                        self.cells.append(cell)
//                        self.newCollection.reloadData()
//                    } else if prediction.label == "anger" {
//                        let cell = Model(text: text, color: UIColor.red, sentiment: "anger")
//                        self.cells.append(cell)
//                        self.newCollection.reloadData()
//                    } else {
//                        let cell = Model(text: text, color: UIColor.black, sentiment: "fear")
//                        self.cells.append(cell)
//                        self.newCollection.reloadData()
//                    }
                    
                    switch (prediction.label) {
                        case "0":
                            self.text.text = "sadness"
                        case "1":
                            self.text.text = "joy"
                        case "2":
                            self.text.text = "love"
                        case "3":
                            self.text.text = "anger"
                        default:
                            self.text.text = "fear"
                    }
                    self.currentQ.text = textField.text
                    
                } catch {
                    print(error)
                }
            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

