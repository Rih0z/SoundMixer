//
//  AudioEnginePlayer.swift
//  SoundMixer
//
//  Created by Nariaki Sugamoto on 2018/02/25.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import AVFoundation

class AudioEnginePlayer: NSObject {
  
  //static let sharedInstance = AudioEnginePlayer()
  
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  var audioPlayerNode: AVAudioPlayerNode!
  var audioUnitTimePitch: AVAudioUnitTimePitch!
  var audioUnitEQ = AVAudioUnitEQ(numberOfBands: 10)
  
  let FREQUENCY: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
  let BANDS: [Float] = [0 , 0 , 0 , 0 , 0 , 0 , 0 , -15.0 , -30.0 , -50.0]
  
  var playing: Bool {
    get {
      return audioPlayerNode != nil && audioPlayerNode.isPlaying
    }
  }
  
  override init() {
    super.init()
    
    do {
      audioEngine = AVAudioEngine()
      
      // Prepare AVAudioPlayerNode
      audioPlayerNode = AVAudioPlayerNode()
      audioEngine.attach(audioPlayerNode)
      
      // Prepare AVAudioUnitTimePitch
      audioUnitTimePitch = AVAudioUnitTimePitch()
      audioEngine.attach(audioUnitTimePitch)
      audioUnitTimePitch.bypass = false
      
      //
      audioUnitEQ = AVAudioUnitEQ(numberOfBands : 10)
      self.audioEngine.attach(self.audioUnitEQ)
      for i in 0...9 {
        self.audioUnitEQ.bands[i].filterType = .parametric
        self.audioUnitEQ.bands[i].frequency = FREQUENCY[i]
        self.audioUnitEQ.bands[i].bandwidth = 0.5 // half an octave
        //let eq = self.value(forKey: String(format: "eq%d", i)) as! UISlider
        //self.audioUnitEQ.bands[i].gain = eq.value
        self.audioUnitEQ.bands[i].gain = BANDS[i]
        self.audioUnitEQ.bands[i].bypass = false
      }
      self.audioUnitEQ.bypass = true
    }
  }
  
  func play() {
    try! audioEngine.start()
    audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: {
      self.play()
    });
    audioPlayerNode.play()
  }
  
  func pause() {
    audioEngine.pause()
    audioPlayerNode.pause()
  }
}
