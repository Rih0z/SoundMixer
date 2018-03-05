//
//  MainTabBarController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/14.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

protocol TabBarDelegate {
  func didSelectTab(MainTabBarController: UITabBarController)
}
class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
  var Id:Int!
  var PlayingSong:MPMediaItem!
  var user:User = User()
  var musiclabel1 :String?
  var initFlag = true
  private var loadFlag:Bool = false
  private var rowNum :Int = 0
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.user.homeflag = true
    // self.selectedIndex = 2
    //self.selectedIndex = 0
    
  }
  
  override var selectedIndex: Int{
    // タブ切り替え時に処理を行うため
    didSet {
      self.delegate?.tabBarController?(self, didSelect: self.viewControllers![selectedIndex])
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  //仮　データの受け渡し研究中
  func mainTabBarController(mainTabBarController: UITabBarController, didSelectViewController viewController: UITableViewController) {
    if viewController is MainTabBarDelegate {
      let v = viewController as! MainTabBarDelegate
      v.didSelectTab(mainTabBarController:  self)
    }
  }
  func receiveData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.user = appDelegate.user
     self.rowNum = appDelegate.rowNum
    print("maintabbar now! beforedata is ...")
    if self.user.BeforeView != nil{
      print(self.user.BeforeView!)
    }
    if(self.user.Playing_1 != nil){
      let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("maintabber music")
      print(music1)
      self.musiclabel1? = music1
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.user.BeforeView = "maintabber"
    self.setSendData()
  }
  func setSendData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.user = self.user
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.receiveData()
    self.navigationBarSetup()
    self.tabBarSetup()
    self.loadAll()
  }
  func loadAll(){
    self.loadTemplete()
    self.loadMusic()
  }
  func tabBarSetup(){
    if self.user.musicSetFlag {
      // self.user.SelectionFlag = 0
      self.user.musicSetFlag = false
      self.selectedIndex = 1
      self.initFlag = false
    }
    if self.user.homeflag  {
      self.user.homeflag = false
      self.selectedIndex = 2
      self.initFlag = false
      
    }
    else if self.user.editflag {
      self.user.editflag = false
      if self.user.beforeTmp == nil {
        print("before tmp is nil")
      }else{
      self.selectedIndex = self.user.beforeTmp!
      }
      self.initFlag = false
    }
    
    if self.initFlag {
      self.selectedIndex = 2
      self.initFlag = false
    }
    /*
     if self.user.loadMusicFlag {
      self.selectedIndex = self.user.beforeTmp
      print("load music flag")
      self.user.beforeTmp = nil
    }
 */
  }
  func navigationBarSetup(){
    
    self.navigationItem.hidesBackButton = true
    
    self.title = self.user.Name
    self.showBarButton()
  }
  
  func barButton(){
    switch self.selectedIndex {
    case 0:
      print("selelct")
    case 1:
      print("edit")
      self.showBarButton()
    case 2:
      print("met")
    default:
      self.showBarButton()
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
  }
  func selectTabName(){
    switch self.selectedIndex {
    case 0:
      print("0")
    //self.title = self.user.Name
    case 1:
      print("!")
    //self.title = "再生"
    case 2:
      print("2")
     // self.allPause()
    //self.title = "メトロノーム"
    default:
      //self.title = self.user.Name
      print("どのタブが開いているかあ")
      print(self.selectedIndex)
    }
  }
  
  var barRightButton: UIBarButtonItem!
  
  func showBarButton() {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.barRightButton = UIBarButtonItem(title: "テンプレート", style: .plain, target: self, action: #selector(self.goLoadSetting))
    //self.barRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.goLoadSetting))
    self.navigationItem.rightBarButtonItem = self.barRightButton
  }
  
  @objc func goLoadSetting() {
    self.goNextPage(page: "SettingSelection")
  }
  
  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    
    self.navigationController?.pushViewController(secondViewController!, animated: true)
  }
  func allPause(){
    /// var text = "音楽1再生"
    if(self.user.Playing_1 != nil){
      //     text = "音楽1再生"
      player.pause()
    }
    if(self.user.Playing_2 != nil){
      //    text = "音楽2再生"
      
      player2.pause()
    }
    if(self.user.Playing_3 != nil){
      //   text = "音楽3再生"
      player3.pause()
    }
    // text = "全曲再生"
    //    self.StartButton4.setTitle(text,for:.normal)
    
  }
  /****************テンプレート読込み**************/
  func loadTemplete(){
    
    if self.loadFlag == true { //テンプレートを読み込んだとき
      self.user.Playing_1 = self.user.Playing_1_MPMedia[self.rowNum]
      self.user.Playing_2 = self.user.Playing_2_MPMedia[self.rowNum]
      self.user.Playing_3 = self.user.Playing_3_MPMedia[self.rowNum]
      
      player.audioEngine.mainMixerNode.outputVolume = self.user.Playing_1_volume[self.rowNum]
      player2.audioEngine.mainMixerNode.outputVolume = self.user.Playing_2_volume[self.rowNum]
      player3.audioEngine.mainMixerNode.outputVolume = self.user.Playing_3_volume[self.rowNum]
      
      player.audioUnitTimePitch.pitch = self.user.Playing_1_pitch[self.rowNum]
   //   player1_pitch_slider.value = self.user.Playing_1_pitch[self.rowNum]
      player2.audioUnitTimePitch.pitch = self.user.Playing_2_pitch[self.rowNum]
   //   player2_pitch_slider.value = self.user.Playing_2_pitch[self.rowNum]
      player3.audioUnitTimePitch.pitch = self.user.Playing_3_pitch[self.rowNum]
   //   player3_pitch_slider.value = self.user.Playing_3_pitch[self.rowNum]
      /*
      if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
        appDelegate.loadFlag = false
      }*/
      //self.loadFlag = false
    }

    //user.SelectionFlag = 0
  }
  /******************* 音楽読み込み ***********************/
  func loadMusic(){
    if self.user.loadMusicFlag {
      if(self.loadFlag == true) {
        if(self.user.Playing_1 != nil){
          player.audioPlayerNode.stop()
          let url: URL  = self.user.Playing_1!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
          player.SetUp(text_url : url)
          print("曲１セット完了")
          //     self.player1_pos_slider.maximumValue = Float(player.duration)
        }
        if(self.user.Playing_2 != nil){
          player2.audioPlayerNode.stop()
          let url: URL  = self.user.Playing_2!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
          player2.SetUp(text_url : url)
          print("曲2セット完了")
          //    self.player2_pos_slider.maximumValue = Float(player2.duration)
        }
        if(self.user.Playing_3 != nil){
          player3.audioPlayerNode.stop()
          let url: URL  = self.user.Playing_3!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
          player3.SetUp(text_url : url)
          print("曲3セット完了")
          //    self.player3_pos_slider.maximumValue = Float(player3.duration)
        }
        self.loadFlag = false
      }
      self.user.loadMusicFlag = false
    }
  }
  
  
}

