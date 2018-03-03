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
    
    var sampleRate:Double = 0.0
    var duration:Double = 0.0
    var offset:Double = 0.0
    
    var pitch:Float = 0.0
    var vol:Float = 0.5
    var pos:Float = 0.0
    
    let FREQUENCY: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    let BANDS: [Float] = [0 , 0 , 0 , 0 , 0 , 0 , 0 , -15.0 , -30.0 , -50.0]
    var feedOutVolume:Float!
    let feedInVolume:Float = 0.5
    var playingFlag:Bool = false
    var pouseFlag:Bool = false
    var firstPlayFlag:Bool = true
    var feedInFlag = false
    var feedOutFlag = false
    let feedInOutTime:Double = 3
    var feedOutCount:Float = 0
    var feedOutLest:Float!
    
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
    
    func SetUp(text_url:URL){
        if(player.playingFlag || player2.playingFlag || player3.playingFlag ){
            DispatchQueue.main.asyncAfter(deadline: .now() + self.feedInOutTime){
                self.setupAll(text_url: text_url)
            }
        }else{
            self.setupAll(text_url: text_url)
            
        }
    }
    func setupAll(text_url:URL){
        do {
            print("nset url")
            self.audioFile = try AVAudioFile(forReading: text_url)
            self.sampleRate = self.audioFile.fileFormat.sampleRate
            self.duration = Double(self.audioFile.length) / self.sampleRate
            self.offset = 0.0
        }
        catch {
            print("OWAOWARI")
            return
        }
        
        // Playerの再生場所（先頭）を指定（途中再生の場合、再生する Frame Positionを Starting Frameに設定する）
        
        /*
         
         let position = 0.0
         
         // シーク位置（AVAudioFramePosition）取得
         let newsampletime = AVAudioFramePosition(self.sampleRate * position)
         
         // 残り時間取得（sec）
         let length = self.duration - position
         
         // 残りフレーム数（AVAudioFrameCount）取得
         let framestoplay = AVAudioFrameCount(self.sampleRate * length)
         
         self.offset = position // ←シーク位置までの時間を一旦退避
         
         
         if framestoplay > 100 {
         // 指定の位置から再生するようスケジューリング
         self.audioPlayerNode.scheduleSegment(self.audioFile,
         startingFrame: newsampletime,
         frameCount: framestoplay,
         at: nil,
         completionHandler: nil)
         
         }
         
         */
        
        //self.audioPlayerNode.scheduleFile(self.audioFile, at:nil, completionHandler:nil)
        
        print("111111111111111111\n")
        
        self.audioEngine.connect(self.audioPlayerNode, to: self.audioUnitTimePitch, format: self.audioFile.processingFormat)
        print("22222222222222222222\n")
        
        self.audioEngine.connect(self.audioUnitTimePitch, to: self.audioUnitEQ, fromBus: 0, toBus: 0, format: self.audioFile.processingFormat)
        print("33333333333333333333\n")
        self.audioEngine.connect(self.audioUnitEQ, to: self.audioEngine.mainMixerNode, fromBus: 0, toBus: 0, format: self.audioFile.processingFormat)
        print("4444444444444444444444\n")
        
        
        self.audioPlayerNode.scheduleSegment(self.audioFile,
                                             startingFrame: 0,
                                             frameCount: AVAudioFrameCount(self.audioFile.length),
                                             at: nil,
                                             completionHandler: nil)
        
        
    }
    
    func play() {
        if( (self.feedInFlag || self.feedOutFlag) )
        {
            
        }else{
            if(self.playingFlag && self.pouseFlag == false){
                
            }else{
                if self.firstPlayFlag || self.pouseFlag  {
                    self.playStart()
                } else {
                    print("waiting for stop music .....")
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.feedInOutTime) {
                        print("3 seconds passed ! PlayStart")
                        self.playStart()
                    }
                }
            }
        }
    }
    func playStart(){
        self.audioEngine.mainMixerNode.outputVolume = 0
        let timer = Timer.scheduledTimer(timeInterval: 0.1 , target: self, selector: #selector(self.feedIn), userInfo: nil, repeats: true)
        
        print("FIRST PLAY")
        try! self.audioEngine.start()
        print("PLAY START ")
        self.audioPlayerNode.play()
        self.firstPlayFlag = false
        self.playingFlag = true
        self.pouseFlag = false
        print("PLAY()")
        self.audioEngine.mainMixerNode.outputVolume = 0//.1
        timer.fire()
        self.feedInFlag = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.feedInOutTime){
            print("AFTER 5 SECONDS")
            timer.invalidate()
            self.feedInFlag = false
            print("TIMER IVALIDATE")
            
        }
    }
    
    func pause() {
        if(self.feedOutFlag){
        }else{
            print(self.audioEngine.mainMixerNode.outputVolume)
            if self.playingFlag {
                // 3秒後に実行したい処理 http://swift.tecc0.com/?p=669
                self.feedOutVolume = self.audioEngine.mainMixerNode.outputVolume
                let timer = Timer.scheduledTimer(timeInterval: 0.1 , target: self, selector: #selector(self.feedOut), userInfo: nil, repeats: true)
                timer.fire()
                self.feedOutFlag = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.feedInOutTime ) {
                    self.pouseFlag = true
                    self.audioEngine.pause()
                    self.audioPlayerNode.pause()
                    timer.invalidate()
                    self.feedOutFlag = false
                }
            }
        }
    }
    
    func stop(){
        if(self.feedOutFlag){
        }else{
            if self.playingFlag {
                self.feedOutVolume = self.audioEngine.mainMixerNode.outputVolume
                let timer = Timer.scheduledTimer(timeInterval: 0.1 , target: self, selector: #selector(self.feedOut), userInfo: nil, repeats: true)
                timer.fire()
                self.feedOutFlag = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.feedInOutTime ) {
                    self.audioEngine.stop()
                    self.audioPlayerNode.stop()
                    self.playingFlag = false
                    self.pouseFlag = false
                    timer.invalidate()
                    self.feedOutFlag = false
                    print("STOP COMPLETE")
                }
            } else {
            }
            
        }
    }
    @objc func feedOut(){
        //  if self.feedOutFlag {
        //必要ないかも，連打した場合メッセージで待ってくださいとか出した方がいいかも　あるいは連打した場合の処理を考えるか
        //    if self.feedInFlag {
        //       self.feedOutFlag = false
        //    } else {
        print("feed out")
        self.audioEngine.mainMixerNode.outputVolume -= self.feedOutVolume/30
        if self.feedOutLest != nil {
            self.feedOutLest = nil
        }
        self.feedOutCount = self.feedOutCount + 1
        //   }
        //  }
    }
    @objc func feedIn(){
        // if self.feedInFlag {
        //再生停止を連打した場合　，フィードインとフィードアウトが混じるので，フィードいんを止めてフィードアウトさせる
        if self.feedOutFlag {
            print("feedout 中に　feedinしました")
            self.feedInFlag = false
            // feedOutLest = 1
            self.feedOutLest = Float(self.feedInOutTime) - ((self.feedOutCount  / Float(30))
                * Float(self.feedInOutTime))
            self.feedOutCount = 0
            //うまく実装できてないスムーズにフィードイン機能
        } else {
            print("feed in")
            self.audioEngine.mainMixerNode.outputVolume += self.feedInVolume/30
            
        }
    }
    // }
}
