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
    //var player = AudioEnginePlayer()
    //var player2 = AudioEnginePlayer()
    //var player3 = AudioEnginePlayer()
    
    var isPlaying1 = false
    var isPlaying2 = false
    var isPlaying3 = false
    
    var user:User = User()
    
    var player1_name:UILabel!
    var player2_name:UILabel!
    var player3_name:UILabel!
    var Player1Pitch:UILabel!
    var Player2Pitch:UILabel!
    var Player3Pitch:UILabel!
    var Player4Pitch:UILabel!
    var Player1Vol:UILabel!
    var Player2Vol:UILabel!
    var Player3Vol:UILabel!
    var Player4Vol:UILabel!
    var Player1Time:UILabel!
    var Player2Time:UILabel!
    var Player3Time:UILabel!
    
    
    private var StartButton1:UIButton! = UIButton()
    private var StartButton2:UIButton! = UIButton()
    private var StartButton3:UIButton! = UIButton()
    private var StartButton4:UIButton! = UIButton()
    private var StartButton5:UIButton! = UIButton()
    private var StartButton6:UIButton! = UIButton()
    private var StartButton7:UIButton! = UIButton()
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
    
    var initFlag = false
    var timer: Timer?
    
    var loadFlag:Bool = false
    var rowNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(initFlag == false){
            self.StartButton1 = self.DrawStartButton(id:1)
            self.view.addSubview(self.StartButton1)
            
            self.StartButton2 = self.DrawStartButton(id:2)
            self.view.addSubview(self.StartButton2)
            
            self.StartButton3 = self.DrawStartButton(id:3)
            self.view.addSubview(self.StartButton3)
            
            self.StartButton4 = self.DrawStartButton(id:4)
            self.view.addSubview(self.StartButton4)
            
            self.StartButton5 = self.DrawStartButton(id:5)
            self.view.addSubview(self.StartButton5)
            
            self.StartButton6 = self.DrawStartButton(id: 6)
            self.view.addSubview(self.StartButton6)
            
            self.StartButton7 = self.DrawStartButton(id: 7)
            self.view.addSubview(self.StartButton7)
            
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
            
            self.Player1Pitch = self.drawPitchLabel(id:1)
            self.view.addSubview(self.Player1Pitch)
            self.Player2Pitch = self.drawPitchLabel(id:2)
            self.view.addSubview(self.Player2Pitch)
            self.Player3Pitch = self.drawPitchLabel(id:3)
            self.view.addSubview(self.Player3Pitch)
            self.Player4Pitch = self.drawPitchLabel(id:4)
            self.view.addSubview(self.Player4Pitch)
            
            
            self.Player1Vol = self.drawVolLabel(id:1)
            self.view.addSubview(self.Player1Vol)
            self.Player2Vol = self.drawVolLabel(id:2)
            self.view.addSubview(self.Player2Vol)
            self.Player3Vol = self.drawVolLabel(id:3)
            self.view.addSubview(self.Player3Vol)
            self.Player4Vol = self.drawVolLabel(id:4)
            self.view.addSubview(self.Player4Vol)
            
            self.Player1Time = self.drawTimeLabel(id: 1)
            self.view.addSubview(self.Player1Time)
            self.Player2Time = self.drawTimeLabel(id: 2)
            self.view.addSubview(self.Player2Time)
            self.Player3Time = self.drawTimeLabel(id: 3)
            self.view.addSubview(self.Player3Time)
            
            initFlag = true
        }
        if(self.timer == nil){
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.timerUpdate), userInfo: nil, repeats: true)
            
            print("タイマーを開始しました")
        }
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
    
    // 曲名ラベル描画
    func drawLabel(id:Int) -> UILabel{
        var flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
        var title = "選択されていません"
        // 曲名１
        if(id == 1){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 0.7)
            if(self.user.Playing_1 != nil){
                title = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
            // 曲名２
        else if(id == 2){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 2.7)
            if(self.user.Playing_2 != nil){
                title = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
            // 曲名３
        else if(id == 3){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 4.7)
            if(self.user.Playing_3 != nil){
                title = self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
        var MusicTitle:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        MusicTitle = setupText(lineWidth: flame, text:title,size: rect)
        MusicTitle.sizeToFit()
        
        if(self.user.musicEditFlag[id - 1] == true){
            MusicTitle.backgroundColor = UIColor.gray // 白
        }
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return MusicTitle
    }
    
    // ピッチラベル描画
    func drawPitchLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        var flame:CGPoint
        let title = "ピッチ"
        
        flame = CGPoint(x:self.view.bounds.width/14 , y:pos_y[id - 1])
        
        var Pitch:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Pitch = setupText(lineWidth: flame, text:title,size: rect)
        Pitch.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Pitch.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return Pitch
    }
    
    // 音量ラベル描画
    func drawVolLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        var flame:CGPoint
        let title = "音量"
        
        flame = CGPoint(x:self.view.bounds.width*8/14 , y:pos_y[id - 1])
        
        var Vol:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Vol = setupText(lineWidth: flame, text:title,size: rect)
        Vol.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Vol.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return Vol
    }
    
    // 再生時間表示ラベル描画
    func drawTimeLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 2.0 / 8 , height * 4.0 / 8 , height * 6.0 / 8]
        
        var flame:CGPoint
        let min = 0.0
        let sec = 0.0
        let title = String(format:"%02d:%02d",min, sec)
        
        flame = CGPoint(x:self.view.bounds.width*8/14 , y:pos_y[id - 1])
        
        var Time:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Time = setupText(lineWidth: flame, text:title,size: rect)
        Time.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Time.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return Time
    }
    
    // 曲再生ボタン
    func DrawStartButton(id:Int) -> UIButton{
        
        var text: String = ""
        var frame: CGPoint = CGPoint(x: 0,y: 0)
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 2 / 8 , height * 4 / 8 , height * 6 / 8 ,  height * 13 / 14]
        
        let rect = CGRect(x:0,y:0,width:100,height:50)
        if(id != 5 && id != 6 && id != 7) {
            switch id{
            case 1:
                text = "音楽1再生"
            case 2:
                text = "音楽2再生"
            case 3:
                text = "音楽3再生"
            case 4:
                text = "全曲再生"
            default:
                text = "再生"
            }

            
            frame = CGPoint(x:width * 1 / 7,y:pos_y[id - 1])
        }
        else if(id == 5) {
            text = "登録"
            frame = CGPoint(x:width * 5 / 7,y:pos_y[3])
        }
        else if(id == 6) {
            text = "完了"
            frame = CGPoint(x:width * 6 / 7,y:pos_y[3])
        }
        else if(id == 7){
            text = "全曲停止"
            frame = CGPoint(x:width * 2 / 7,y:pos_y[4 - 1])
            
        }
        
        
        
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
            //  btn.addTarget(self, action: #selector(PlayerViewController.StartBtn4Tapped(sender:)), for: .touchUpInside)
            btn.addTarget(self, action: #selector(PlayerViewController.allStartTapped(sender:)), for: .touchUpInside)
        }
        if(id == 5){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn5Tapped(sender:)), for: .touchUpInside)
        }
        if(id == 6){
            btn.addTarget(self, action: #selector(PlayerViewController.StartBtn6Tapped(sender:)), for: .touchUpInside)
        }
        if(id == 7){
            btn.addTarget(self, action: #selector(PlayerViewController.allStopTapped(sender:)), for: .touchUpInside)
        }
        btn.setTitle(text,for:.normal)
        btn.backgroundColor = UIColor.blue
        
        return btn
    }
    @objc func StartBtn1Tapped(sender:UIButton){
        if player.playing == false
        {
            if(self.user.Playing_1 != nil){
                let text = "音楽1停止"
                self.StartButton1.setTitle(text,for:.normal)
                player.play()
            }
            
        }else{
            if(self.user.Playing_1 != nil){
                let text = "音楽1再生"
                self.StartButton1.setTitle(text,for:.normal)
                player.pause()
            }
        }
    }
    @objc func StartBtn2Tapped(sender:UIButton){
        if player2.playing == false
        {
            if(self.user.Playing_2 != nil){
                let text = "音楽2停止"
                self.StartButton2.setTitle(text,for:.normal)
                player2.play()
            }
            
        }else{
            if(self.user.Playing_2 != nil){
                let text = "音楽2再生"
                self.StartButton2.setTitle(text,for:.normal)
                player2.pause()
            }
        }
    }
    @objc func StartBtn3Tapped(sender:UIButton){
        if player3.playing == false
        {
            if(self.user.Playing_3 != nil){
                let text = "音楽3停止"
                self.StartButton3.setTitle(text,for:.normal)
                player3.play()
            }
            
        }else{
            if(self.user.Playing_3 != nil){
                let text = "音楽3再生"
                self.StartButton3.setTitle(text,for:.normal)
                player3.pause()
            }
        }
    }
    @objc func StartBtn4Tapped(sender:UIButton){
        if (player3.playing == false && player2.playing == false && player.playing == false)
        {
            self.allStop()
        }else{
            self.allStart()
        }
    }
    @objc func allStartTapped(sender:UIButton){
        if (player3.playing == false && player2.playing == false && player.playing == false)
        {
            //何もしない
            // self.allStop()
        }else{
            self.allStart()
        }
    }
    @objc func allStopTapped(sender:UIButton){
        if (player3.playing == false && player2.playing == false && player.playing == false)
        {
            self.allStop()
        }else{
            //  self.allStart()
        }
    }
    
    func allStop(){
        let text = "全曲停止"
        if(self.user.Playing_1 != nil){
            self.StartButton1.setTitle(text,for:.normal)
            player.play()
        }
        if(self.user.Playing_2 != nil){
            self.StartButton2.setTitle(text,for:.normal)
            player2.play()
        }
        if(self.user.Playing_3 != nil){
            self.StartButton3.setTitle(text,for:.normal)
            player3.play()
        }
        self.StartButton4.setTitle(text,for:.normal)
    }
    func allStart(){
        let text = "全曲再生"
        if(self.user.Playing_1 != nil){
            self.StartButton1.setTitle(text,for:.normal)
            player.pause()
        }
        if(self.user.Playing_2 != nil){
            self.StartButton2.setTitle(text,for:.normal)
            player2.pause()
        }
        if(self.user.Playing_3 != nil){
            self.StartButton3.setTitle(text,for:.normal)
            player3.pause()
        }
        self.StartButton4.setTitle(text,for:.normal)
        
    }
    @objc func  StartBtn5Tapped(sender:UIButton){
        let alert = UIAlertController(title: "テンプレート名を入力してください", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "入力終了", style: .default) { (action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField
            let template_name = textField.text!
            //self.recUserInfo()
            
            if self.user.Playing_1 != nil && self.user.Playing_2 != nil && self.user.Playing_3 != nil { //3曲全て選曲していないと曲を登録できない
                self.user.setSetting(temp_name: template_name, MPMedia1: self.user.Playing_1, MPMedia2: self.user.Playing_2, MPMedia3: self.user.Playing_3, pitch1: self.player1_pitch_slider.value, pitch2: self.player2_pitch_slider.value, pitch3: self.player3_pitch_slider.value, volume1: player.audioEngine.mainMixerNode.outputVolume, volume2: player2.audioEngine.mainMixerNode.outputVolume, volume3: player3.audioEngine.mainMixerNode.outputVolume, position1: Double(self.player1_pos_slider.value), position2: Double(self.player2_pos_slider.value), position3: Double(self.player3_pos_slider.value))
            }
            
            self.sendUserInfo()
            
            let MPMedia1 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_1_MPMedia) as NSData?
            let MPMedia2 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_2_MPMedia) as NSData?
            let MPMedia3 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_3_MPMedia) as NSData?
            userDefaults.set(["temp_name": self.user.template_name, "MPMedia1": MPMedia1!, "MPMedia2": MPMedia2!, "MPMedia3": MPMedia3!, "pitch1": self.user.Playing_1_pitch, "pitch2": self.user.Playing_2_pitch, "pitch3": self.user.Playing_3_pitch, "volume1": self.user.Playing_1_volume, "volume2": self.user.Playing_2_volume, "volume3": self.user.Playing_3_volume, "position1": self.user.Playing_1_position, "position2": self.user.Playing_2_position, "position3": self.user.Playing_3_position], forKey: String(self.user.Id - 1)+"_"+"Setting")
            print("いけてる，その2")
        }
        let cancelAction = UIAlertAction(title: "取り消し", style: .default) { (action:UIAlertAction!) -> Void in }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    @objc func  StartBtn6Tapped(sender:UIButton){
        self.goHome()
    }
    func goHome(){
        self.user.homeflag = true
        self.goNextPage(page: "MainTabBar")
        if self.user.Playing_1 != nil{
            player.stop()
        }
        if self.user.Playing_2 != nil {
            player2.stop()
        }
        if self.user.Playing_3 != nil {
            player3.stop()
        }
    }
    func goNextPage(page:String){
        let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
        let secondViewController = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    
    func sendUserInfo() {
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
            appDelegate.user = self.user
        }
    }
    
    //スライダーを表示
    
    func drawPitchSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width*1.2/4  , y:pos_y[id - 1])
        
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
        if(user.musicEditFlag[0] == true){
            player.audioUnitTimePitch.pitch = player1_pitch_slider.value
        }
    }
    @objc func changePitch2(_ sender: UISlider) {
        if(user.musicEditFlag[1] == true){
            player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
        }
    }
    @objc func changePitch3(_ sender: UISlider) {
        if(user.musicEditFlag[2] == true){
            player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
        }
    }
    @objc func changePitch4(_ sender: UISlider) {
        player1_pitch_slider.value = player4_pitch_slider.value
        player2_pitch_slider.value = player4_pitch_slider.value
        player3_pitch_slider.value = player4_pitch_slider.value
        
        if(user.musicEditFlag[0] == true){
            
            player.audioUnitTimePitch.pitch = player1_pitch_slider.value
        }
        if(user.musicEditFlag[1] == true){
            
            player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
        }
        if(user.musicEditFlag[2] == true){
            
            player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
        }
    }
    
    // 音量調整用スライダ作成
    func drawVolSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width * 3.2 / 4  , y:pos_y[id - 1])
        
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
        let pos_y = [height * 2.2 / 8 , height * 4.2 / 8 , height * 6.2 / 8 ,  height * 11 / 12]
        
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
        // スライダーの値が変更された時に呼び出されるメソッドを設定
        slider.value = 0.0
        
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
        if(self.user.Playing_1 != nil){
            
            let PlayFlag1 = player.playing
            
            let position = Double(self.player1_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player.sampleRate * length)
            
            player.offset = position // ←シーク位置までの時間を一旦退避
            
            player.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player.audioPlayerNode.scheduleSegment(player.audioFile,
                                                       startingFrame: newsampletime,
                                                       frameCount: framestoplay,
                                                       at: nil,
                                                       completionHandler: nil)
                
            }
            if(PlayFlag1 == true){
                player.audioPlayerNode.play()
            }
        }
    }
    @objc func changePos2(_ sender: UISlider) {
        if(self.user.Playing_2 != nil){
            
            let PlayFlag2 = player2.playing
            
            let position = Double(self.player2_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player2.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player2.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player2.sampleRate * length)
            
            player2.offset = position // ←シーク位置までの時間を一旦退避
            
            player2.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player2.audioPlayerNode.scheduleSegment(player2.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
                print(newsampletime)
            }
            
            if(PlayFlag2 == true){
                player2.audioPlayerNode.play()
            }
        }
    }
    @objc func changePos3(_ sender: UISlider) {
        if(self.user.Playing_3 != nil){
            
            let PlayFlag3 = player3.playing
            
            let position = Double(self.player3_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player3.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player3.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player3.sampleRate * length)
            
            player3.offset = position // ←シーク位置までの時間を一旦退避
            
            player3.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player3.audioPlayerNode.scheduleSegment(player3.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
                
            }
            
            if(PlayFlag3 == true){
                player3.audioPlayerNode.play()
            }
        }
    }
    
    @objc func timerUpdate() {
        
        if player.playing == true{
            
            let position = Double(self.player1_pos_slider.value)
            
            // 残り時間取得（sec）
            let length = player.duration - position
            
            if(length < 1.0){
                player.audioPlayerNode.stop()
                player.audioPlayerNode.scheduleSegment(player.audioFile,
                                                       startingFrame: 0,
                                                       frameCount: AVAudioFrameCount(player.audioFile.length),
                                                       at: nil,
                                                       completionHandler: nil)
                player.audioPlayerNode.play()
                self.player1_pos_slider.value = 0.0
                player.offset = 0.0
                Player1Time.text = String(format:"%02d:%02d",0, 0)
                
            }
            else{
                
                let nodeTime = player.audioPlayerNode.lastRenderTime
                let playerTime = player.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
                let currentTime = (Double(playerTime!.sampleTime) / player.sampleRate) + player.offset // シーク位置以前の時間を追加
                
                self.player1_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                
                
                //print(currentTime)
                //messageLabel.text = String(Int(currentTime + 0.49))
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player1Time.text = String(format:"%02d:%02d",min, sec)
            }
            //print(text)
        }
        
        if player2.playing == true{
            
            let position = Double(self.player2_pos_slider.value)
            
            // 残り時間取得（sec）
            let length = player2.duration - position
            
            if(length < 1.0){
                player2.audioPlayerNode.stop()
                player2.audioPlayerNode.scheduleSegment(player2.audioFile,
                                                        startingFrame: 0,
                                                        frameCount: AVAudioFrameCount(player2.audioFile.length),
                                                        at: nil,
                                                        completionHandler: nil)
                player2.audioPlayerNode.play()
                self.player2_pos_slider.value = 0.0
                player2.offset = 0.0
                Player2Time.text = String(format:"%02d:%02d",0, 0)
                
            }
            else{
                
                let nodeTime = player2.audioPlayerNode.lastRenderTime
                let playerTime = player2.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
                let currentTime = (Double(playerTime!.sampleTime) / player2.sampleRate) + player2.offset // シーク位置以前の時間を追加
                
                self.player2_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                
                
                //print(currentTime)
                //messageLabel.text = String(Int(currentTime + 0.49))
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player2Time.text = String(format:"%02d:%02d",min, sec)
            }
            //print(text)
        }
        
        if player3.playing == true{
            
            let position = Double(self.player3_pos_slider.value)
            
            // 残り時間取得（sec）
            let length = player3.duration - position
            
            if(length < 1.0){
                player3.audioPlayerNode.stop()
                player3.audioPlayerNode.scheduleSegment(player3.audioFile,
                                                        startingFrame: 0,
                                                        frameCount: AVAudioFrameCount(player3.audioFile.length),
                                                        at: nil,
                                                        completionHandler: nil)
                player3.audioPlayerNode.play()
                self.player3_pos_slider.value = 0.0
                player3.offset = 0.0
                Player3Time.text = String(format:"%02d:%02d",0, 0)
                
            }
            else{
                
                let nodeTime = player3.audioPlayerNode.lastRenderTime
                let playerTime = player3.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
                let currentTime = (Double(playerTime!.sampleTime) / player3.sampleRate) + player3.offset // シーク位置以前の時間を追加
                
                self.player3_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                
                
                //print(currentTime)
                //messageLabel.text = String(Int(currentTime + 0.49))
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player3Time.text = String(format:"%02d:%02d",min, sec)
                //print(text)
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.receiveData()
        
        if self.loadFlag == true { //テンプレートを読み込んだとき
            self.user.Playing_1 = self.user.Playing_1_MPMedia[self.rowNum]
            self.user.Playing_2 = self.user.Playing_2_MPMedia[self.rowNum]
            self.user.Playing_3 = self.user.Playing_3_MPMedia[self.rowNum]
            
            player.audioEngine.mainMixerNode.outputVolume = self.user.Playing_1_volume[self.rowNum]
            player1_vol_slider.value = self.user.Playing_1_volume[self.rowNum]
            player2.audioEngine.mainMixerNode.outputVolume = self.user.Playing_2_volume[self.rowNum]
            player2_vol_slider.value = self.user.Playing_2_volume[self.rowNum]
            player3.audioEngine.mainMixerNode.outputVolume = self.user.Playing_3_volume[self.rowNum]
            player3_vol_slider.value = self.user.Playing_3_volume[self.rowNum]
            
            player.audioUnitTimePitch.pitch = self.user.Playing_1_pitch[self.rowNum]
            player1_pitch_slider.value = self.user.Playing_1_pitch[self.rowNum]
            player2.audioUnitTimePitch.pitch = self.user.Playing_2_pitch[self.rowNum]
            player2_pitch_slider.value = self.user.Playing_2_pitch[self.rowNum]
            player3.audioUnitTimePitch.pitch = self.user.Playing_3_pitch[self.rowNum]
            player3_pitch_slider.value = self.user.Playing_3_pitch[self.rowNum]
            
            if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
                appDelegate.loadFlag = false
            }
            //self.loadFlag = false
        }
        
        self.player1_name = self.drawLabel(id:1)
        self.view.addSubview(self.player1_name)
        
        self.player2_name = self.drawLabel(id:2)
        self.view.addSubview(self.player2_name)
        
        self.player3_name = self.drawLabel(id:3)
        self.view.addSubview(self.player3_name)
        
        if(self.loadFlag == false) {
            if(self.user.Playing_1 != nil && user.SelectionFlag == 1){
                player.stop()
                self.StartButton1.setTitle("音楽1再生",for:.normal)
                let url: URL  = self.user.Playing_1!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player.SetUp(text_url : url)
                print("曲１セット完了")
                self.player1_pos_slider.maximumValue = Float(player.duration)
            }
            if(self.user.Playing_2 != nil && user.SelectionFlag == 2){
                player2.stop()
                self.StartButton2.setTitle("音楽2再生",for:.normal)
                let url: URL  = self.user.Playing_2!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player2.SetUp(text_url : url)
                print("曲2セット完了")
                self.player2_pos_slider.maximumValue = Float(player2.duration)
            }
            if(self.user.Playing_3 != nil && user.SelectionFlag == 3){
                player3.stop()
                self.StartButton3.setTitle("音楽3再生",for:.normal)
                let url: URL  = self.user.Playing_3!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player3.SetUp(text_url : url)
                print("曲3セット完了")
                self.player3_pos_slider.maximumValue = Float(player3.duration)
            }
            user.SelectionFlag = 0
        }
        else if(self.loadFlag == true) {
            if(self.user.Playing_1 != nil){
                player.stop()
                let url: URL  = self.user.Playing_1!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player.SetUp(text_url : url)
                print("曲１セット完了")
                self.player1_pos_slider.maximumValue = Float(player.duration)
            }
            if(self.user.Playing_2 != nil){
                player2.stop()
                let url: URL  = self.user.Playing_2!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player2.SetUp(text_url : url)
                print("曲2セット完了")
                self.player2_pos_slider.maximumValue = Float(player2.duration)
            }
            if(self.user.Playing_3 != nil){
                player3.stop()
                let url: URL  = self.user.Playing_3!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                player3.SetUp(text_url : url)
                print("曲3セット完了")
                self.player3_pos_slider.maximumValue = Float(player3.duration)
            }
            self.loadFlag = false
        }
        
        if(player.duration != 0.0){
            self.player1_pos_slider.maximumValue = Float(player.duration)
        }
        if(player2.duration != 0.0){
            self.player2_pos_slider.maximumValue = Float(player2.duration)
        }
        if(player3.duration != 0.0){
            self.player3_pos_slider.maximumValue = Float(player3.duration)
        }
        //user.SelectionFlag = 0
    }
    func receiveData(){
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
            self.user = appDelegate.user
            self.loadFlag = appDelegate.loadFlag
            self.rowNum = appDelegate.rowNum
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

