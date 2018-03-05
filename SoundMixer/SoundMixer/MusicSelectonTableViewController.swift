//
//  MusicSelectonTableViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/15.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer
class MusicSelectonTableViewController: UITableViewController {
  //var Id:Int!
  var Playlist:MPMediaItemCollection!
  var SongNum:Int!
  var SongNames = [String]()
  var Songs = [MPMediaItem]()
  var SongName: String!
  // var SongHash:Int!
  var Song:MPMediaItem!
  var user:User = User()
  var homeBtn: UIBarButtonItem!
  var testsongUrl:URL!
  var testSong:MPMediaItem!
  var testPlayer:AudioEnginePlayer = AudioEnginePlayer()
  var timer: Timer?
  var testplayFlag : Bool = false
  var testplayLockFlag :Bool = false
  var testplaysong:String!
  // Cell が選択された場合
  
  
  
  override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell",for: indexPath)
    if self.testplayLockFlag {
      //cell.backgroundColor = UIColor.red
      self.title = self.testplaysong + "の準備中お待ちください..."
      
    } else {
      self.title = "選択した曲を再生します"
      cell.backgroundColor = UIColor.blue
      self.tryingMusic(indexPath: indexPath)
    }
    //self.navigationController?.popViewControllerAnimated(true) で前の画面に戻れる？https://qiita.com/moshisora/items/f1b6eeee5305e649d32b
  }
  
  
  func goNextPage(page:String){
    //testPlayer.stop()
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    self.navigationController?.pushViewController(secondViewController!, animated: true)
    
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
    
    return SongNum
  }
  /*
  // UITableViewDelegate  https://ja.stackoverflow.com/questions/34343/cell%E3%82%92%E5%B7%A6%E3%81%AB%E3%82%B9%E3%83%AF%E3%82%A4%E3%83%97%E3%81%95%E3%81%9B-%E5%89%8A%E9%99%A4%E3%83%9C%E3%82%BF%E3%83%B3-%E3%81%A8-%E8%A9%B3%E7%B4%B0%E3%83%9C%E3%82%BF%E3%83%B3-%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%95%E3%81%9B%E3%81%9F%E3%81%84
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let action = UITableViewRowAction(style: .default, title: "お試し再生"){ action, indexPath in
      // Do anything
      self.tryingMusic(indexPath: indexPath)
    }
    action.backgroundColor = UIColor.blue
    return [action]
  }
  */
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell",for: indexPath)
    cell.textLabel?.text = self.SongNames[indexPath.row]
    if self.testplayLockFlag {
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    // cell.backgroundColor = UIColor.lightGray
    //cell.accessoryType = .checkmark
    return cell
  }
  
  func tryingMusic(indexPath:IndexPath){
    if(testSong == nil)
    {
      stopMusics()
      print("新しく曲をセットします")
      self.testSong = self.Songs[indexPath.row]
    }else{
      print("停止して次の曲をセットします")
      testPlayer.stop()
      self.title = "フェードアウト中..."
      self.testplayLockFlag = true
      self.testplayFlag = true
      self.testSong = self.Songs[indexPath.row]
    }
    let url = self.testSong.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
    // DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    testplaysong = self.testSong.value(forProperty: MPMediaItemPropertyTitle) as! String
     self.title = self.testplaysong + "の再生準備中"
    print("セット完了")
    if self.testplayFlag {
      let lesttime:Double = 3/*
      if testPlayer.feedOutLest != nil{
        lesttime = Double(testPlayer.feedOutLest)
        print("残り時間を代入しました")
      }*/
      DispatchQueue.main.asyncAfter(deadline: .now() + (lesttime)) {
        self.testPlayer.SetUp(text_url: url)
        self.testPlayer.play()
        self.title = self.testplaysong + "再生中"
        self.testplayLockFlag = false
        self.testplayFlag = false
      }
    }else {
      print("test play setup")
      
      
      self.testPlayer.SetUp(text_url: url)
      self.testPlayer.play()
    }
    // }
    
  }
  func stopMusics(){
    
    if self.user.Playing_1 != nil {
      player.stop()
    }
    if self.user.Playing_2 != nil {
      player2.stop()
    }
    if self.user.Playing_3 != nil {
      player3.stop()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if(self.timer == nil){
      self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.timerUpdate), userInfo: nil, repeats: true)
      
      print("タイマーを開始しました")
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.receiveData()
    self.setupHomeBtn()
    self.showPlaylist()
  }
  
  func receiveData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.user = appDelegate.user
    self.Playlist = appDelegate.Playlists
    print("Selectionflag musicselection")
    print(self.user.SelectionFlag)
  }
  func showPlaylist(){
    let playlistname = self.Playlist?.value(forProperty: MPMediaPlaylistPropertyName)! as! String
    self.title = playlistname
    //  print("musicsselection music...")
    //  print(music1)
    
    let songs = self.Playlist.items
    self.SongNum = songs.count
    print(self.SongNum)
    for song in songs {
      // self.Song = song
      let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
      print("\t\t", songTitle!)
      self.SongName = songTitle! as! String
      self.SongNames.append(self.SongName)
      self.Songs.append(song)
    }
  }
  func setMusic(){
    if let indexPath = self.tableView.indexPathForSelectedRow {
      switch self.user.SelectionFlag {
      case 1:
        self.user.musicSetFlag = true
        self.user.Playing_1 = self.Songs[indexPath.row]
      case 2:
        self.user.musicSetFlag = true
        self.user.Playing_2 = self.Songs[indexPath.row]
      case 3:
        self.user.musicSetFlag = true
        self.user.Playing_3 = self.Songs[indexPath.row]
      default:
        print("フラグが立っていませんmusicselection")
        print(self.user.SelectionFlag)
      }
      
    }
  }
  func setSendData()
  {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.user = self.user
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.user.BeforeView = "music selection"
    self.setMusic()
    setSendData()
    testPlayer.stop()
    if(self.user.Playing_1 != nil)
    {
      let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("musicsselection music...")
      print(music1)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func setupHomeBtn(){
    //    self.barRightButton = UIBarButtonItem(title: "テンプレート", style: .plain, target: self, action: #selector(self.goLoadSetting))
    self.homeBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(self.goHome))
    self.navigationItem.rightBarButtonItem = self.homeBtn
  }
  @objc func goHome(){
    self.user.homeflag = true
    self.user.playerflag = true
    goNextPage(page: "MainTabBar")
  }
  
  @objc func timerUpdate() {
    if (self.testPlayer.playing == true){
      
      let nodeTime = self.testPlayer.audioPlayerNode.lastRenderTime
      let playerTime = self.testPlayer.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
      let currentTime = (Double(playerTime!.sampleTime) / self.testPlayer.sampleRate) + self.testPlayer.offset // シーク位置以前の時間を追加
      
      // 残り時間取得（sec）
      let length = self.testPlayer.duration - currentTime
      
      if(length < 1.0){
        self.testPlayer.audioPlayerNode.stop()
        self.testPlayer.audioPlayerNode.scheduleSegment(self.testPlayer.audioFile,
                                                        startingFrame: 0,
                                                        frameCount: AVAudioFrameCount(self.testPlayer.audioFile.length),
                                                        at: nil,
                                                        completionHandler: nil)
        self.testPlayer.audioPlayerNode.play()
        self.testPlayer.offset = 0.0
        
        
      }
    }
  }
  
  /*
   override func prepare(for segue: UIStoryboardSegue, sender: Any?){
   if let indexPath = self.tableView.indexPathForSelectedRow {
   let controller = segue.destination as! PlayerViewController
   controller.title = self.SongNames[indexPath.row]
   controller.PlayingSong = self.Songs[indexPath.row]
   }
   }
   */
  // MARK: - Table view data source
  /*
   override func numberOfSections(in tableView: UITableView) -> Int {
   // #warning Incomplete implementation, return the number of sections
   return 0
   }
   */
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
}
