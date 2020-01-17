//
//  ViewController.swift
//  background-test
//
//  Created by Rustam  on 1/12/20.
//  Copyright © 2020 Rustam . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("TRY", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = RepeatingTimer(timeInterval: 3600)
        timer.eventHanddler = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = Date()
            let dateStr = dateFormatter.string(from: date)
            
            print("timer")
            
//            Network.shared.sendData(date: dateStr) { (status, code, data) in
//                //handling the request
//            }
        }
        timer.resume()
        
//        Network.shared.beginTask()
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        self.view.addSubview(activityIndicator)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        
        let constraints = [
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
        
        button.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        label.isHidden = true
    }
    
    @objc func sendData() {
        label.isHidden = true
        activityIndicator.startAnimating()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = Date()
        let dateStr = dateFormatter.string(from: date)
        
        Network.shared.sendData(date: dateStr) { (status, code, data) in
            print("status \(status)")
            self.activityIndicator.stopAnimating()
            self.label.isHidden = false
            self.label.text = code
        }
    }
}

