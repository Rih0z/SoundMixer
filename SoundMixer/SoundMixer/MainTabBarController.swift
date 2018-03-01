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
    
    self.navigationItem.hidesBackButton = true
    if self.user.musicSetFlag {
      // self.user.SelectionFlag = 0
      self.user.musicSetFlag = false
      self.selectedIndex = 1
      self.initFlag = false
    }
    if(self.user.Playing_1 != nil){
      let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("maintabber willappear music")
      print(music1)
    }
    if self.user.homeflag  {
      self.user.homeflag = false
      self.selectedIndex = 2
      self.initFlag = false
    }
    else if self.user.editflag {
      self.user.editflag = false
      self.selectedIndex = 1
      self.initFlag = false
    }
    
    if self.initFlag {
      self.selectedIndex = 2
      self.initFlag = false
    }
    
    self.title = self.user.Name
    
    self.showBarButton()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
  }
  func selectTabName(){
    switch self.selectedIndex {
    case 0:
      self.title = self.user.Name
    case 1:
      self.title = "再生"
    case 2:
      self.title = "メトロノーム"
    default:
      self.title = self.user.Name
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
}

