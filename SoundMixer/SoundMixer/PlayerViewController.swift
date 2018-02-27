//
//  SecondViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//
/*
 import UIKit
 import MediaPlayer
 class PlayerViewController: UIViewController, MPMediaPickerControllerDelegate {
 var audioPlayer:AVAudioPlayer?
 var PlayingSong:MPMediaItem!
 var player = MPMusicPlayerController()
 var user:User = User()
 //作り直したストーリーボードではこのボタン関数消して新しいボタン関数でこの中に書いてる関数動かせば大丈夫
 /*
 @IBAction func Play(_ sender: Any) {
 self.playMusic(whitchmusic: 1)
 }
 */
 //これも．こっちは音楽２上野が音楽1に対応してる
 /*
 @IBAction func Play2(_ sender: Any) {
 self.playMusic(whitchmusic: 2)
 }
 */
 func playMusic(whitchmusic: Int){
 var errorMes:String = "音楽１と音楽2に"
 // 選択した曲情報がPlayingSongに入っているので、これをplayerにセット。
 print("play")
 switch whitchmusic {
 case 1:
 self.PlayingSong = self.user.Playing_1
 errorMes = "音楽1に"
 case 2:
 errorMes = "音楽2に"
 self.PlayingSong = self.user.Playing_2
 case 3:
 errorMes = "音楽3に"
 self.PlayingSong = self.user.Playing_3
 default:
 print("フラグが立っていませんmusicselection")
 print(self.user.SelectionFlag)
 }
 
 if(PlayingSong != nil){
 print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)!)
 let url: URL  = PlayingSong.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
 //  let url: NSURL = PlayingSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL
 //  if  url != nil {
 do {
 // itemのassetURLからプレイヤーを作成する
 audioPlayer = try AVAudioPlayer(contentsOf: url , fileTypeHint: nil)
 } catch  {
 // エラー発生してプレイヤー作成失敗
 // messageLabelに失敗したことを表示
 print( "この音楽は再生できません")
 audioPlayer = nil
 // 戻る
 return
 }
 // 再生開始
 if let player = audioPlayer {
 player.play()
 // メッセージラベルに曲タイトルを表示
 // (MPMediaItemが曲情報を持っているのでそこから取得)
 //   let title = item.title ?? ""
 // messageLabel.text = title
 }
 }else{
 print(errorMes)
 print("音楽が選択されていません")
 }
 self.user.SelectionFlag = 0
 
 }
 override func viewWillAppear(_ animated: Bool) {
 super.viewDidDisappear(animated)
 self.receiveData()
 }
 func receiveData(){
 if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
 self.user = appDelegate.user
 }
 }
 override func viewWillDisappear(_ animated: Bool) {
 super.viewDidDisappear(animated)
 self.user.BeforeView = "player"
 self.setSendData()
 print("player sendData finished")
 }
 func setSendData(){
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 appDelegate.user = self.user
 if(self.user.Playing_1 != nil){
 let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
 print("player music")
 print(music1)
 }
 
 }
 override func viewDidLoad() {
 super.viewDidLoad()
 //  player = MPMusicPlayerController.applicationMusicPlayer()
 // Do any additional setup after loading the view, typically from a nib.
 // player = MPMusicPlayerController.applicationMusicPlayer()
 //player = MPMusicPlayerController.systemMusicPlayer()
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 
 }
 */



import UIKit
import MediaPlayer
import AVFoundation

class PlayerViewController: UIViewController, MPMediaPickerControllerDelegate {
    var audioPlayer:AVAudioPlayer?
    var PlayingSong:MPMediaItem!
    var PlayingSong2:MPMediaItem!
    var PlayingSong3:MPMediaItem!
    // player = AudioEnginePlayer.sharedInstance
    var player = AudioEnginePlayer()
    var player2 = AudioEnginePlayer()
    var player3 = AudioEnginePlayer()
    
    var isPlaying1 = false
    var isPlaying2 = false
    var isPlaying3 = false
    
    var user:User = User()
    
    var player1_name:UILabel!
    var player2_name:UILabel!
    var player3_name:UILabel!
    private var StartButton1:UIButton! = UIButton()
    private var StartButton2:UIButton! = UIButton()
    private var StartButton3:UIButton! = UIButton()
    private var StartButton4:UIButton! = UIButton()
    
    var player1_pitch_slider:UISlider!
    var player2_pitch_slider:UISlider!
    var player3_pitch_slider:UISlider!
    var player4_pitch_slider:UISlider!
    
    var player1_vol_slider:UISlider!
    var player2_vol_slider:UISlider!
    var player3_vol_slider:UISlider!
    var player4_vol_slider:UISlider!
    
    var player1_pos_slider:UISlider!
    var player2_pos_slider:UISlider!
    var player3_pos_slider:UISlider!
    var player4_pos_slider:UISlider!
    
    var sampleRate1 = 0.0
    var sampleRate2 = 0.0
    var sampleRate3 = 0.0
    var duration1 = 0.0
    var duration2 = 0.0
    var duration3 = 0.0
    
    var timer: Timer?
    var offset1 = 0.0
    var offset2 = 0.0
    var offset3 = 0.0
    
    func Play(id:Int) {
        // 選択した曲情報がPlayingSongに入っているので、これをplayerにセット。
        print("play")
        
        if(id == 1 || id == 4){
            if(self.user.Playing_1 != nil){
                let url: URL  = self.user.Playing_1!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                
                do {
                    player.audioFile = try AVAudioFile(forReading: url)
                    sampleRate1 = self.player.audioFile.fileFormat.sampleRate
                    duration1 = Double(self.player.audioFile.length) / sampleRate1
                    self.player1_pos_slider.maximumValue = Float(duration1)
                }
                catch {
                    print("OWAOWARI")
                    return
                }
                player.audioEngine.connect(player.audioPlayerNode, to: player.audioUnitTimePitch, format: player.audioFile.processingFormat)
                player.audioEngine.connect(player.audioUnitTimePitch, to: player.audioUnitEQ, fromBus: 0, toBus: 0, format: player.audioFile.processingFormat)
                player.audioEngine.connect(player.audioUnitEQ, to: player.audioEngine.mainMixerNode, fromBus: 0, toBus: 0, format: player.audioFile.processingFormat)
                
                player.audioEngine.prepare()
                
                if player.playing {
                    player.pause()
                } else {
                    //player.audioEngine.mainMixerNode.outputVolume = 1.0
                    player.play()
                }
            }
            
        }
        if(id == 2 || id == 4){
            if(self.user.Playing_2 != nil){
                let url2: URL  = self.user.Playing_2!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                
                do {
                    player2.audioFile = try AVAudioFile(forReading: url2)
                    sampleRate2 = self.player2.audioFile.fileFormat.sampleRate
                    duration2 = Double(self.player2.audioFile.length) / sampleRate2
                    self.player2_pos_slider.maximumValue = Float(duration2)
                }
                catch {
                    print("OWAOWARI")
                    return
                }
                player2.audioEngine.connect(player2.audioPlayerNode, to: player2.audioUnitTimePitch, format: player2.audioFile.processingFormat)
                player2.audioEngine.connect(player2.audioUnitTimePitch, to: player2.audioUnitEQ, fromBus: 0, toBus: 0, format: player2.audioFile.processingFormat)
                player2.audioEngine.connect(player2.audioUnitEQ, to: player2.audioEngine.mainMixerNode, fromBus: 0, toBus: 1, format: player2.audioFile.processingFormat)
                
                player2.audioEngine.prepare()
                
                if player2.playing {
                    player2.pause()
                } else {
                    //player2.audioEngine.mainMixerNode.outputVolume = 1.0
                    player2.play()
                }
            }
        }
        if(id == 3 || id == 4){
            if(self.user.Playing_3 != nil){
                let url3: URL  = self.user.Playing_3!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                
                do {
                    player3.audioFile = try AVAudioFile(forReading: url3)
                    sampleRate3 = self.player3.audioFile.fileFormat.sampleRate
                    duration3 = Double(self.player3.audioFile.length) / sampleRate3
                    self.player3_pos_slider.maximumValue = Float(duration3)
                }
                catch {
                    print("OWAOWARI")
                    return
                }
                player3.audioEngine.connect(player3.audioPlayerNode, to: player3.audioUnitTimePitch, format: player3.audioFile.processingFormat)
                player3.audioEngine.connect(player3.audioUnitTimePitch, to: player3.audioUnitEQ, fromBus: 0, toBus: 0, format: player3.audioFile.processingFormat)
                player3.audioEngine.connect(player3.audioUnitEQ, to: player3.audioEngine.mainMixerNode, fromBus: 0, toBus: 1, format: player3.audioFile.processingFormat)
                
                player3.audioEngine.prepare()
                
                if player3.playing {
                    player3.pause()
                } else {
                    //player3.audioEngine.mainMixerNode.outputVolume = 1.0
                    player3.play()
                }
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.StartButton1 = self.DrawStartButton(id:1)
        self.view.addSubview(self.StartButton1)
        
        self.StartButton2 = self.DrawStartButton(id:2)
        self.view.addSubview(self.StartButton2)
        
        self.StartButton3 = self.DrawStartButton(id:3)
        self.view.addSubview(self.StartButton3)
        
        self.StartButton4 = self.DrawStartButton(id:4)
        self.view.addSubview(self.StartButton4)
        
        self.player1_pitch_slider = self.drawPitchSlider(id:1)
        self.view.addSubview(self.player1_pitch_slider)
        
        self.player2_pitch_slider = self.drawPitchSlider(id:2)
        self.view.addSubview(self.player2_pitch_slider)
        
        self.player3_pitch_slider = self.drawPitchSlider(id:3)
        self.view.addSubview(self.player3_pitch_slider)
        
        self.player4_pitch_slider = self.drawPitchSlider(id:4)
        self.view.addSubview(self.player4_pitch_slider)
        
        self.player1_vol_slider = self.drawVolSlider(id:1)
        self.view.addSubview(self.player1_vol_slider)
        
        self.player2_vol_slider = self.drawVolSlider(id:2)
        self.view.addSubview(self.player2_vol_slider)
        
        self.player3_vol_slider = self.drawVolSlider(id:3)
        self.view.addSubview(self.player3_vol_slider)
        
        self.player4_vol_slider = self.drawVolSlider(id:4)
        self.view.addSubview(self.player4_vol_slider)
        
        self.player1_pos_slider = self.drawPosSlider(id:1)
        self.view.addSubview(self.player1_pos_slider)
        
        self.player2_pos_slider = self.drawPosSlider(id:2)
        self.view.addSubview(self.player2_pos_slider)
        
        self.player3_pos_slider = self.drawPosSlider(id:3)
        self.view.addSubview(self.player3_pos_slider)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.timerUpdate), userInfo: nil, repeats: true)
        //  player = MPMusicPlayerController.applicationMusicPlayer()
        // Do any additional setup after loading the view, typically from a nib.
        // player = MPMusicPlayerController.applicationMusicPlayer()
        //player = MPMusicPlayerController.systemMusicPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //テキストボックスを表示
    @objc func setupText(lineWidth:CGPoint, text:String,size:CGRect) -> UILabel {
        let label = UILabel(frame: size)
        label.text = text
        label.font = UIFont(name: "HiraMinProN-W3", size: 20)
        label.sizeToFit()
        label.center = lineWidth
        return label
    }
    
    func drawLabel(id:Int) -> UILabel{
        var flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
        var title = "選択されていません"
        
        if(id == 1){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 0.7)
            if(self.user.Playing_1 != nil){
                title = String(describing: self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)!)
            }
        }
        else if(id == 2){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 2.7)
            if(self.user.Playing_2 != nil){
                title = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
        else if(id == 3){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 4.7)
            if(self.user.Playing_3 != nil){
                title = String(describing: self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle)!)
            }
        }
        var MusicTitle:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        MusicTitle = setupText(lineWidth: flame, text:title,size: rect)
        MusicTitle.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return MusicTitle
    }
    
    // 曲再生ボタン
    func DrawStartButton(id:Int) -> UIButton{
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 2 / 8 , height * 4 / 8 , height * 6 / 8 ,  height * 13 / 14]
        
        let rect = CGRect(x:0,y:0,width:50,height:50)
        let frame = CGPoint(x:width * 1 / 5,y:pos_y[id - 1])
        let text = "再生"
        
        
        let btn = UIButton(frame: rect)
        btn.center = frame
        if(id == 1){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn1Tapped(sender:)), for: .touchUpInside)
        }
        if(id == 2){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn2Tapped(sender:)), for: .touchUpInside)
        }
        if(id == 3){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn3Tapped(sender:)), for: .touchUpInside)
        }
        if(id == 4){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn4Tapped(sender:)), for: .touchUpInside)
        }
        btn.setTitle(text,for:.normal)
        btn.backgroundColor = UIColor.blue
        
        return btn
        
        
    }
    @objc func StartBtn1Tapped(sender:UIButton){
        //アニメ非表示ボタンが押されたら
        self.Play(id:1)
        if player.playing
        {
            let text = "停止"
            self.StartButton1.setTitle(text,for:.normal)
        }else{
            let text = "再生"
            self.StartButton1.setTitle(text,for:.normal)
            
        }
    }
    @objc func StartBtn2Tapped(sender:UIButton){
        //アニメ非表示ボタンが押されたら
        self.Play(id:2)
        if player2.playing
        {
            let text = "停止"
            self.StartButton2.setTitle(text,for:.normal)
        }else{
            let text = "再生"
            self.StartButton2.setTitle(text,for:.normal)
            
        }
    }
    @objc func StartBtn3Tapped(sender:UIButton){
        //アニメ非表示ボタンが押されたら
        self.Play(id:3)
        if player3.playing
        {
            let text = "停止"
            self.StartButton3.setTitle(text,for:.normal)
        }else{
            let text = "再生"
            self.StartButton3.setTitle(text,for:.normal)
            
        }
    }
    @objc func StartBtn4Tapped(sender:UIButton){
        //アニメ非表示ボタンが押されたら
        self.Play(id:4)
        if (player3.playing == true || player2.playing == true || player.playing == true)
        {
            let text = "停止"
            self.StartButton1.setTitle(text,for:.normal)
            self.StartButton2.setTitle(text,for:.normal)
            self.StartButton3.setTitle(text,for:.normal)
            self.StartButton4.setTitle(text,for:.normal)
        }else{
            let text = "再生"
            self.StartButton1.setTitle(text,for:.normal)
            self.StartButton2.setTitle(text,for:.normal)
            self.StartButton3.setTitle(text,for:.normal)
            self.StartButton4.setTitle(text,for:.normal)
        }
    }
    
    //スライダーを表示
    
    func drawPitchSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width/4  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 3
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = -1000
        // 最大値を tmpmax に変更する
        slider.maximumValue = 1000
        
        slider.value = 0   // スライダーの値が変更された時に呼び出されるメソッドを設定
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changePitch1), for: .valueChanged)
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changePitch2), for: .valueChanged)
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changePitch3), for: .valueChanged)
        }
        if(id == 4){
            slider.addTarget(self, action: #selector(self.changePitch4), for: .valueChanged)
        }
        
        return slider
        
    }
    

    @objc func changePitch1(_ sender: UISlider) {
        player.audioUnitTimePitch.pitch = player1_pitch_slider.value
    }
    @objc func changePitch2(_ sender: UISlider) {
        player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
    }
    @objc func changePitch3(_ sender: UISlider) {
        player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
    }
    @objc func changePitch4(_ sender: UISlider) {
        player1_pitch_slider.value = player4_pitch_slider.value
        player2_pitch_slider.value = player4_pitch_slider.value
        player3_pitch_slider.value = player4_pitch_slider.value
        player.audioUnitTimePitch.pitch = player1_pitch_slider.value
        player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
        player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
    }
    
    // 音量調整用スライダ作成
    func drawVolSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width * 3 / 4  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 3
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = 0.0
        // 最大値を tmpmax に変更する
        slider.maximumValue = 1.0
        
        slider.value = 0.5   // スライダーの値が変更された時に呼び出されるメソッドを設定
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changeVol1), for: .valueChanged)
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changeVol2), for: .valueChanged)
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changeVol3), for: .valueChanged)
        }
        if(id == 4){
            slider.addTarget(self, action: #selector(self.changeVol4), for: .valueChanged)
        }
        
        return slider
        
    }
    
    @objc func changeVol1(_ sender: UISlider) {
        player.audioEngine.mainMixerNode.outputVolume = player1_vol_slider.value
    }
    @objc func changeVol2(_ sender: UISlider) {
        player2.audioEngine.mainMixerNode.outputVolume = player2_vol_slider.value
    }
    @objc func changeVol3(_ sender: UISlider) {
        player3.audioEngine.mainMixerNode.outputVolume = player3_vol_slider.value
    }
    @objc func changeVol4(_ sender: UISlider) {
        player1_vol_slider.value = player4_vol_slider.value
        player2_vol_slider.value = player4_vol_slider.value
        player3_vol_slider.value = player4_vol_slider.value
        player.audioEngine.mainMixerNode.outputVolume = player1_vol_slider.value
        player2.audioEngine.mainMixerNode.outputVolume = player2_vol_slider.value
        player3.audioEngine.mainMixerNode.outputVolume = player3_vol_slider.value
    }
    
    // 再生位置スライダ作成
    func drawPosSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 2.0 / 8 , height * 4.0 / 8 , height * 6.0 / 8 ,  height * 11 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width * 1.8 / 3  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 2
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = 0.0
        // 最大値を tmpmax に変更する
        slider.maximumValue = 10.0
        
        slider.value = 0.0   // スライダーの値が変更された時に呼び出されるメソッドを設定
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changePos1), for: .touchUpInside)
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changePos2), for: .touchUpInside)
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changePos3), for: .touchUpInside)
        }
        
        return slider
        
    }
    
    @objc func changePos1(_ sender: UISlider) {
        let position = Double(self.player1_pos_slider.value)
        
        // シーク位置（AVAudioFramePosition）取得
        let newsampletime = AVAudioFramePosition(sampleRate1 * position)
        
        // 残り時間取得（sec）
        let length = self.duration1 - position
        
        // 残りフレーム数（AVAudioFrameCount）取得
        let framestoplay = AVAudioFrameCount(sampleRate1 * length)
        
        self.offset1 = position // ←シーク位置までの時間を一旦退避
        
        self.player.audioPlayerNode.stop()
        
        if framestoplay > 100 {
            // 指定の位置から再生するようスケジューリング
            self.player.audioPlayerNode.scheduleSegment(self.player.audioFile,
                                                 startingFrame: newsampletime,
                                                 frameCount: framestoplay,
                                                 at: nil,
                                                 completionHandler: nil)
            
        }
        
        self.player.audioPlayerNode.play()
    }
    @objc func changePos2(_ sender: UISlider) {
        let position = Double(self.player2_pos_slider.value)
        
        // シーク位置（AVAudioFramePosition）取得
        let newsampletime = AVAudioFramePosition(sampleRate2 * position)
        
        // 残り時間取得（sec）
        let length = self.duration2 - position
        
        // 残りフレーム数（AVAudioFrameCount）取得
        let framestoplay = AVAudioFrameCount(sampleRate2 * length)
        
        self.offset2 = position // ←シーク位置までの時間を一旦退避
        
        self.player2.audioPlayerNode.stop()
        
        if framestoplay > 100 {
            // 指定の位置から再生するようスケジューリング
            self.player2.audioPlayerNode.scheduleSegment(self.player2.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
            print(newsampletime)
        }

        self.player2.audioPlayerNode.play()
    }
    @objc func changePos3(_ sender: UISlider) {
        let position = Double(self.player3_pos_slider.value)
        
        // シーク位置（AVAudioFramePosition）取得
        let newsampletime = AVAudioFramePosition(sampleRate3 * position)
        
        // 残り時間取得（sec）
        let length = self.duration3 - position
        
        // 残りフレーム数（AVAudioFrameCount）取得
        let framestoplay = AVAudioFrameCount(sampleRate3 * length)
        
        self.offset3 = position // ←シーク位置までの時間を一旦退避
        
        self.player3.audioPlayerNode.stop()
        
        if framestoplay > 100 {
            // 指定の位置から再生するようスケジューリング
            self.player3.audioPlayerNode.scheduleSegment(self.player3.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
            
        }
        
        self.player3.audioPlayerNode.play()
    }
    
    @objc func timerUpdate() {
        
        if player.playing == true{
            
            let nodeTime = player.audioPlayerNode.lastRenderTime
            let playerTime = player.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / sampleRate1) + self.offset1 // シーク位置以前の時間を追加
            
            self.player1_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
            
            
            //print(currentTime)
            //messageLabel.text = String(Int(currentTime + 0.49))
            
            let min = Int((currentTime + 0.49) / 60.0)
            let sec = Int(Int(currentTime + 0.49) % 60)
            var text = String(format:"%02d:%02d",min, sec)
            print(text)
        }
        
        if player2.playing == true{
            
            let nodeTime = player2.audioPlayerNode.lastRenderTime
            let playerTime = player2.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / sampleRate2) + self.offset2 // シーク位置以前の時間を追加
            
            self.player2_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
            
            
            //print(currentTime)
            //messageLabel.text = String(Int(currentTime + 0.49))
            
            let min = Int((currentTime + 0.49) / 60.0)
            let sec = Int(Int(currentTime + 0.49) % 60)
            var text = String(format:"%02d:%02d",min, sec)
            print(text)
        }
        
        if player3.playing == true{
            
            let nodeTime = player3.audioPlayerNode.lastRenderTime
            let playerTime = player3.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / sampleRate3) + self.offset3 // シーク位置以前の時間を追加
            
            self.player3_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
            
            
            //print(currentTime)
            //messageLabel.text = String(Int(currentTime + 0.49))
            
            let min = Int((currentTime + 0.49) / 60.0)
            let sec = Int(Int(currentTime + 0.49) % 60)
            var text = String(format:"%02d:%02d",min, sec)
            print(text)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.receiveData()
        
        
        self.player1_name = self.drawLabel(id:1)
        self.view.addSubview(self.player1_name)
        
        self.player2_name = self.drawLabel(id:2)
        self.view.addSubview(self.player2_name)
        
        self.player3_name = self.drawLabel(id:3)
        self.view.addSubview(self.player3_name)
        

        
    }
    func receiveData(){
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
            self.user = appDelegate.user
            //print("get data")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.user.BeforeView = "player"
        self.setSendData()
        print("player sendData finished")
    }
    func setSendData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = self.user
        if(self.user.Playing_1 != nil){
            let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            print("player music")
            print(music1)
        }
        
    }
}

