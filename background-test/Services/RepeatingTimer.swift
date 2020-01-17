//
//  RepeatingTimer.swift
//  background-test
//
//  Created by Rustam  on 1/15/20.
//  Copyright © 2020 Rustam . All rights reserved.
//

import Foundation

class RepeatingTimer {
    
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    let queue = DispatchQueue(label: "com.rustam.background-test", attributes: .concurrent)
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: self.queue)
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler {
            self.eventHanddler?()
        }
        return t
    }()
    
    var eventHanddler: (() -> Void)?
    
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler(handler: {})
        timer.cancel()
        
        resume()
        eventHanddler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
