//
//  SettingSelection.swift
//  SoundMixer
//
//  Created by Nariaki Sugamoto on 2018/02/26.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

class SettingSelectionViewController: UITableViewController {
  var user: User = User()
  var rowNum: Int = 0
  var showFlag: Bool = false
  
/*****************: テーブル系 ********************/
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
    return self.user.Playing_1_MPMedia.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
    cell.textLabel?.text = self.user.template_name[indexPath.row]
    return cell
  }
  
  override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
    self.user.editflag = true
    //self.sendInfo(rowNum: indexPath.row)
    self.allStop()
    self.goNextPage(page: "MainTabBar")
  }
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { //deleteが押されたとき
    self.user.removeSetAtIndex(indexPath.row)
    if self.rowNum == indexPath.row { //削除されたセルと選択されていたセルが同じだった場合
      self.showFlag = false
    }
    else if self.rowNum > indexPath.row { //選択されているセルより前の行のセルが削除された場合
      self.rowNum = self.rowNum - 1
    }
    
    self.sendUserInfo()
    let MPMedia1 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_1_MPMedia) as NSData?
    let MPMedia2 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_2_MPMedia) as NSData?
    let MPMedia3 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_3_MPMedia) as NSData?
    userDefaults.set(["temp_name": self.user.template_name, "MPMedia1": MPMedia1!, "MPMedia2": MPMedia2!, "MPMedia3": MPMedia3!, "pitch1": self.user.Playing_1_pitch, "pitch2": self.user.Playing_2_pitch, "pitch3": self.user.Playing_3_pitch, "volume1": self.user.Playing_1_volume, "volume2": self.user.Playing_2_volume, "volume3": self.user.Playing_3_volume, "position1": self.user.Playing_1_position, "position2": self.user.Playing_2_position, "position3": self.user.Playing_3_position], forKey: String(self.user.Id - 1)+"_"+"Setting")
    
    self.tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //全てのセルを編集可能にする
    return true
  }
  
  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "削除"
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if self.showFlag == true {
      if self.rowNum == indexPath.row {
        cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
      }
      else {
        cell.backgroundColor = UIColor.clear
      }
    }
    else {
      cell.backgroundColor = UIColor.clear
    }
  }
/******************userdefault系*******************/
  
  //http://xyk.hatenablog.com/entry/2016/11/16/173208
  func showAllUserDefaultData(){
    print("ALL DARA YHEEEEEEEEEEEEEEEEEEEEEEEEEEEE!!!")

        /*
        //print("\(UserDefaults.standard.string(forKey: String(self.user.Id - 1)+"_"+"Setting"))  )  " )
        print("音楽1に関する情報")
        let music1:MPMediaItem = value as! MPMediaItem
        let title = music1.value(forProperty: MPMediaItemPropertyTitle)! as! String
        print(title)
 */
 
      for i in 0...(self.user.Playing_1_MPMedia.count - 1) {
        print(self.user.template_name[i])
         let music1:MPMediaItem = self.user.Playing_1_MPMedia as! MPMediaItem
       // print(self.user.m)
      }
      
    print("ALL DATA WERE SHOWN")
    
  
  }
  
  /****************** ライフサイクル系 *******************/

  

  override func viewDidLoad() {
    super.viewDidLoad()
    // 編集ボタンを左上に配置
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    self.navigationItem.rightBarButtonItem?.title = "削除"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.recUserInfo()
    self.tableView.reloadData()
  }
  // 3/6 Tuesday 20:00 追記しました 画面全体のレイアウトが終わってからこの関数が呼ばれます
  //ここにsubtitleの内容を編集する処理を書けば大丈夫だと思います
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //self.showAllUserDefaultData()
  }
  //ダメならここ　ここは全体の描画が終わって召喚される直前
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  //追加しました　利穂　音楽を代入するタイミングが違うとバグが起こったので
  //　musicselection で音楽を代入するタイミングに合わせました
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let indexPath = self.tableView.indexPathForSelectedRow {
      self.sendInfo(rowNum: indexPath.row )
    }
    
  }
  
  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    
    self.navigationController?.pushViewController(secondViewController!, animated: true)
  }
/***********データ共有系 **************/
  override func setEditing(_ editing: Bool, animated: Bool) { //Edit, doneが押されたとき
    super.setEditing(editing, animated: animated)
    if tableView.isEditing == true {
      self.navigationItem.rightBarButtonItem?.title = "削除終了"
    }
    else if tableView.isEditing == false {
      self.navigationItem.rightBarButtonItem?.title = "削除"
    }
  }
  



  func recUserInfo(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      self.user = appDelegate.user
      self.user.loadMusicFlag = true
      self.rowNum = appDelegate.rowNum
      self.showFlag = appDelegate.showFlag
    }
  }
  
  func sendUserInfo(){ //セルが削除されたときに実行するメソッド
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      appDelegate.user = self.user
      appDelegate.showFlag = self.showFlag
      appDelegate.rowNum = self.rowNum
    }
  }
  
  func sendInfo(rowNum: Int) { //セルが押下されたときに実行するメソッド
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
      appDelegate.user = self.user
      appDelegate.rowNum = rowNum
      appDelegate.loadFlag = true
      appDelegate.showFlag = true
    }
  }
  /************** player系 ******************/
  func allStop(){
    if self.user.Playing_1 != nil {
      //player.audioEngine.stop()
      player.stop()
    }
    if self.user.Playing_2 != nil {
      // player2.audioEngine.stop()
      player2.stop()
    }
    if self.user.Playing_3 != nil {
      // player3.audioEngine.stop()
      player3.stop()
    }
    
  }

}
