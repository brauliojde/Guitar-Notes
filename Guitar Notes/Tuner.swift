//
//  Tuner.swift
//  Guitar Notes
//
//  Created by Braulio De La Torre on 5/23/18.
//  Copyright © 2018 Braulio. All rights reserved.
//
import Foundation
import AudioKit

protocol TunerDelegate {
    /**
     * The tuner calls this delegate function when it detects a new pitch. The
     * Pitch object is the nearest note (A-G) in the nearest octave. The
     * distance is between the actual tracked frequency and the nearest note.
     * Finally, the amplitude is the volume (note: of all frequencies).
     */
    //    func tunerDidMeasure(pitch: Pitch, distance: Double, amplitude: Double)
}

class Tuner: NSObject {
    //    var delegate: TunerDelegate?
    
    /* Private instance variables. */
    fileprivate var timer:      Timer?
    fileprivate let microphone: AKMicrophone
    fileprivate let analyzer:   AKAudioAnalyzer
    
    override init() {
        /* Start application-wide microphone recording. */
        AKManager.shared().enableAudioInput()
        
        /* Add the built-in microphone. */
        microphone = AKMicrophone()
        AKOrchestra.add(microphone)
        
        /* Add an analyzer and store it in an instance variable. */
        analyzer = AKAudioAnalyzer(input: microphone.output)
        AKOrchestra.add(analyzer)
    }
    
    func startMonitoring() {
        /* Start the microphone and analyzer. */
        analyzer.play()
        microphone.play()
        
        /* Initialize and schedule a new run loop timer. */
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(Tuner.getFreq),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopMonitoring() {
        analyzer.stop()
        microphone.stop()
        timer?.invalidate()
    }
    
    func getFreq() -> Double {
        /* Read frequency and amplitude from the analyzer. */
        let frequency = Double(analyzer.trackedFrequency.floatValue)
        return frequency

    }
    
    func getWaveL() -> Double{
        
        let amplitude = Double(analyzer.trackedAmplitude.floatValue)
        let f = analyzer.trackedFrequency
        return amplitude
    }
    
}
