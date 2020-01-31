//
//  SoundManager.swift
//  WatchOut
//
//  Created by Guest User on 23/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    private var tickSound: AVAudioPlayer?
    private var bombSound: AVAudioPlayer?
    private var timer: Timer = Timer()
    
    var maxUpdateInterval: Double = 2.5
    var minUpdateInterval: Double = 1/10.0
    
    // numberTotalBoundaries = 10 means that the position can be between 1 and 10
    // numberTotalBoundaries+1 means above the boundaries
    // numberTotalBoundaries = 0 means below the boundaries
    private var numberTotalBoundaries : Int = 10
    private var lastPositionInBoundaries: Int
    
    private var canStartNewTimer: Bool = true
    
    private init() {
        
        // initialize with above the boundaries
        lastPositionInBoundaries = -1
        
        let tickPath = Bundle.main.path(forResource: "TickSound.mp3", ofType:nil)!
        let tickUrl = URL(fileURLWithPath: tickPath)
        let bombPath = Bundle.main.path(forResource: "BombSound.wav", ofType:nil)!
        let bombUrl = URL(fileURLWithPath: bombPath)
        
        do {
            tickSound = try AVAudioPlayer(contentsOf: tickUrl)
            tickSound?.volume = 1.0
            bombSound = try AVAudioPlayer(contentsOf: bombUrl)
            bombSound?.volume = 1.0
            
        } catch let error {
            // Could not load mp3/wav-File
            print(error.localizedDescription)
        }
    }
    
    func playTickSound(newUpdateInterval: Double) {
        var updateInterval: Double
        var newPositionInBoundaries : Int
                
        if(newUpdateInterval > maxUpdateInterval) {
            updateInterval = maxUpdateInterval
            newPositionInBoundaries = numberTotalBoundaries+1
        }
        else if (newUpdateInterval < minUpdateInterval) {
            updateInterval = minUpdateInterval
            newPositionInBoundaries = 0
        }
        else {
            let intervalSize = (maxUpdateInterval - minUpdateInterval)/Double(numberTotalBoundaries)
            newPositionInBoundaries = Int(newUpdateInterval/intervalSize)+1
            
            
            updateInterval = Double(newPositionInBoundaries)*intervalSize
        }
        
        // Only update the timer interval if the position in the boundaries changed
        if (newPositionInBoundaries != lastPositionInBoundaries) {
            print("NEW TICK BOUNDARY: \(newPositionInBoundaries)")
            lastPositionInBoundaries = newPositionInBoundaries

            self.tickSound?.stop()
            timer.invalidate()
            timer = Timer(fire: Date(), interval: updateInterval, repeats: true,
                               block: { (timer) in
//                                print("Playing Tick Sound with Interval: \(updateInterval)")
                                self.tickSound?.play()
            })

            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func stopTickSound() {
        tickSound?.stop()
        timer.invalidate()
    }
    
    func playBombSound() {
        bombSound?.play()
    }
    
    func stopBombSound() {
        bombSound?.stop()
    }
}