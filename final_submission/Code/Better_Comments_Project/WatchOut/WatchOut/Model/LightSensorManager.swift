//
//  LightSensorManager.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

class LightSensorManager : NSObject, ARSessionDelegate {
    
    // singleton
    static let shared = LightSensorManager()
    
    private let session = ARSession()
    var isRunning: Bool
    
    // value will be 1000.0 for a normal lighten room
    var ambientIntensity: Observable<Double>
    
    var intensityArray: [Double] = Array(repeating: 0.0, count: 10)
    var intervalCounter: Int = 0
    
    private let faceConfig = ARFaceTrackingConfiguration()
    
    private override init() {
        isRunning = false
        ambientIntensity = Observable(value: 0.0)
        
        // supportedVideoFormats-Array contains videoformats sorted from best first to worst last
        faceConfig.videoFormat = ARFaceTrackingConfiguration.supportedVideoFormats.last!
        faceConfig.isLightEstimationEnabled = true
    }
    
    func startLightSensor() -> Bool {
        // dont start new session, if the sensor is already running
        if (!isRunning && ARFaceTrackingConfiguration.isSupported) {
            session.delegate = self
            session.run(faceConfig)
            isRunning = true
            
            return true
        }
        return false
    }
    
    func stopLightSensor() -> Bool {
        if(isRunning) {
            session.pause()
            isRunning = false
            
            return true
        }
        return false
    }
    
    // the ar session does not need an ARView to receive updates from the camera
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        // Average over last 15 Light Values wwith help of an intervalCounter
        intensityArray[intervalCounter] = Double(frame.lightEstimate!.ambientIntensity)
        if(intervalCounter >= intensityArray.count-1) {
            // array is full, calculate average
            intervalCounter = 0
            
            var intensitySum: Double = 0.0
            for intensity in intensityArray {
                intensitySum += intensity
            }
            let averageIntensity = intensitySum/10
            
            ambientIntensity.value = averageIntensity
        }
        else {
            intervalCounter += 1
        }
    }
}

// observer for AmbientIntensity
class AmbientIntensityObserver : ObserverProtocol {
    var id: Int = 2
    
    func onValueChanged(_ value: Any?) {
        print("OnValueChanged \(value)" )
    }
}
