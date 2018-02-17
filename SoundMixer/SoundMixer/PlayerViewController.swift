//
//  SecondViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer
class PlayerViewController: UIViewController, MPMediaPickerControllerDelegate {
    var audioPlayer:AVAudioPlayer?
    var PlayingSong:MPMediaItem!
    
    var player = MPMusicPlayerController()
    var user:User = User()
    
    @IBAction func Play(_ sender: Any) {
        // 選択した曲情報がPlayingSongに入っているので、これをplayerにセット。
        print("play")
        
        self.PlayingSong = self.user.Playing_1
        print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)!)
        if(PlayingSong != nil){
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
                     print("URLがおかしい")
                  }

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.receiveData()
    }
    func receiveData(){
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
        {
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

