//
//  Session2.swift
//  TranquilApp
//
//  Created by Heather Dinh on 1/18/23.
//
import SwiftUI

class SessionViewController: UIViewController {
    var name: String = "Default"
//    let description: String = "Default description"
    var gifName: String = "sunsetocean2"
    
    private let label = UILabel()
    private let myView = UIView(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        view = myView
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        label.textAlignment = .center
        label.text = name
        label.textColor = .white
        label.frame = CGRect(x: 25, y: 200, width: 350, height: 52)
        label.font = .systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 5))

        let myGif = UIImage.gifImageWithName(gifName)
        let imageView = UIImageView(image: myGif)
        imageView.frame = CGRect(x: 20, y: 20, width: 350, height: 700)
        imageView.layer.cornerRadius = 10
        view.addSubview(imageView)
        view.addSubview(label)
        view.layer.cornerRadius = 10
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}
