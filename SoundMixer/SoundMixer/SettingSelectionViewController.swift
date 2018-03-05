//
//  SettingSelection.swift
//  SoundMixer
//
//  Created by Nariaki Sugamoto on 2018/02/26.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit

class SettingSelectionViewController: UITableViewController {
  var user: User = User()
//var rightBarButtonItem: UIBarButtonItem!
  
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
    self.sendInfo(rowNum: indexPath.row)
    player.stop()
    player2.stop()
    player3.stop()
    self.goNextPage(page: "MainTabBar")
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { //deleteが押されたとき
    self.user.removeSetAtIndex(indexPath.row)
  
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
  
  override func setEditing(_ editing: Bool, animated: Bool) { //Edit, doneが押されたとき
    super.setEditing(editing, animated: animated)
    if tableView.isEditing == true {
      self.navigationItem.rightBarButtonItem?.title = "削除終了"
    }
    else if tableView.isEditing == false {
      self.navigationItem.rightBarButtonItem?.title = "削除"
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "削除"
  }
  
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
  
  func recUserInfo(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      self.user = appDelegate.user
    }
  }
  
  func sendUserInfo(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      appDelegate.user = self.user
    }
  }
  
  func sendInfo(rowNum: Int) {
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
      appDelegate.user = self.user
      appDelegate.rowNum = rowNum
      appDelegate.loadFlag = true
    }
  }
  
  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    
    self.navigationController?.pushViewController(secondViewController!, animated: true)
  }
}
