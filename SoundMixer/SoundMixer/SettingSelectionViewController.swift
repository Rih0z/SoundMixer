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
