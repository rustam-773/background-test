//
//  File.swift
//  background-test
//
//  Created by Rustam  on 1/12/20.
//  Copyright © 2020 Rustam . All rights reserved.
//

import UIKit

class Network {
    
    static let shared = Network()
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid    
    
    func beginTask() {
        Network.shared.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        })
        
        let timer = RepeatingTimer(timeInterval: 3)
        timer.eventHanddler = {
            print("timer")
        }
        timer.resume()
        
    }
    
    func sendData(date: String, completion: @escaping(Bool, String, Data?) -> Void) {
        print("sendingData")
        let url = URL(string: "https://api.sandbox.opsgenie.com/v2/alerts/alias/close?identifierType=alias")
        var request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.rustam.background")
        let session = URLSession(configuration: config)
        
        request.httpMethod = "POST"
        request.setValue("GenieKey 7334d1dd-0f53-4202-a3e1-e66e238a51d0", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "date": date
        ]
        print(body)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            let task = session.uploadTask(with: request, from: data) { (data, response, error) in
                if let error = error {
                    print("error \(String(describing: error))")
                    DispatchQueue.main.async {
                        completion(false, error.localizedDescription, nil)
                    }
                }
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(json)
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("status \(statusCode)")
                    if statusCode > 299 {
                        DispatchQueue.main.async {
                            completion(false, String(statusCode), nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(true, String(statusCode), data!)
                        }
                    }
                }
            }
            
            task.resume()
        } catch {
            print("jsonError \(error.localizedDescription)")
        }
    }
}
