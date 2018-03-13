//
//  UserViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

class UserViewController: UITableViewController {
  var userNum: Int = 0
  var userNumber:Int = 1
  var allUserNum:Int = 0
  var users = [User]()
  var user:User?
  var setupFlag :Bool = true
  // ボタンを用意
  var addBtn: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Loadaaaaaaaaaaaaaaaaasssssssssssssssssss")
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    self.tableView.delegate   = self
    self.tableView.dataSource = self
    // タイトルを付けておきましょう
    self.title = "ユーザー選択"
    if(setupFlag){
      self.setupNavigationBar()
    }
    self.setupNavigationLeftBar()
    self.tableView.allowsSelectionDuringEditing = true
  }
  
  func setupNavigationBar(){
    // NavigationBarの表示する.
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    // addBtnを設置
    addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onClick))
    self.navigationItem.rightBarButtonItem = addBtn
  }
  func setupNavigationLeftBar(){
    // NavigationBarの表示する.
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    self.navigationItem.leftBarButtonItem?.title = "編集"
  }
  override func setEditing(_ editing: Bool, animated: Bool) { //Edit, doneが押されたとき
    super.setEditing(editing, animated: animated)
    if tableView.isEditing == true {
      self.navigationItem.leftBarButtonItem?.title = "編集終了"
    }
    else if tableView.isEditing == false {
      self.navigationItem.leftBarButtonItem?.title = "編集"
    }
  }
  
  @objc func onClick()
  {
    print("onClick clicked!!!")
    Clicked()
  }
  func Clicked(){
    self.user = User()//Userクラスのインスタンス作成
    //self.user?.Id = self.userNumber
    self.user?.Id = self.users.count + 1
    
    let alert = UIAlertController(title: "あなたの名前を入力してください", message: "", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "入力終了", style: .default) { (action:UIAlertAction!) -> Void in
      let textField = alert.textFields![0] as UITextField
      if (textField.text!.isEmpty) {
        self.user?.Name = "ユーザ" + String(self.allUserNum)
      }
      else {
        self.user?.Name = textField.text!
      }
      self.users.append(self.user!)
      self.userNumber = self.users.count + 1
      self.allUserNum = self.allUserNum + 1
      self.userNum = self.users.count
      self.tableView.reloadData()
      
      /* ID ごとにユーザを辞書形式で登録しユーザ数も保存（クラスでの保存ができない） */
      userDefaults.set(["ID": self.user!.Id, "Name": self.user!.Name], forKey: String(self.user!.Id - 1))
      userDefaults.set(self.users.count, forKey: "userNumber")
      
      /* ユーザを追加するたびにappDelegateと共有*/
      self.sendUserInfo()
    }
    let cancelAction = UIAlertAction(title: "取り消し", style: .default) { (action:UIAlertAction!) -> Void in }
    
    // UIAlertControllerにtextFieldを追加
    alert.addTextField { (textField:UITextField!) -> Void in }
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  func sendUserInfo() {
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
      appDelegate.users = self.users
      appDelegate.userNum = self.users.count
      appDelegate.allUserNum = self.allUserNum
    }
  }
  // Cell が選択された場合
  override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing == true { //編集中
      self.user = User()
      let alert = UIAlertController(title: "[" + self.users[indexPath.row].Name + "]のユーザ名変更", message: "新しい名前を入力してください", preferredStyle: .alert)
      let saveAction = UIAlertAction(title: "入力終了", style: .default) { (action:UIAlertAction!) -> Void in
        let textField = alert.textFields![0] as UITextField
        if (textField.text!.isEmpty) {
          self.user?.Name = "ユーザ" + String(self.allUserNum)
        }
        else {
          self.user?.Name = textField.text!
        }
        self.user?.Id = indexPath.row + 1
        self.users[indexPath.row] = self.user!
        self.tableView.reloadData()
        
        /* ID ごとにユーザを辞書形式で登録しユーザ数も保存（クラスでの保存ができない） */
        userDefaults.set(["ID": indexPath.row, "Name": self.user!.Name], forKey: String(indexPath.row))
        
        /* ユーザを追加するたびにappDelegateと共有*/
        self.sendUserInfo()
      }
      let cancelAction = UIAlertAction(title: "取り消し", style: .default) { (action:UIAlertAction!) -> Void in
        self.tableView.reloadData()
      }
      
      // UIAlertControllerにtextFieldを追加
      alert.addTextField { (textField:UITextField!) -> Void in }
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
    }
    else if tableView.isEditing == false { //編集中でない
      
      self.goNextPage(page: "MainTabBar")
    }
  }
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //全てのセルを編集可能にする
    return true
  }
  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "削除"
  }
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { //削除が押されたとき
    /*if indexPath.row == self.users.count - 1 { //削除されたユーザが最後の行のユーザの場合
      print("last")
      self.users.remove(at: indexPath.row)
      if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
        appDelegate.users = self.users
      }
      userDefaults.set(self.users.count, forKey: "userNumber")
      userDefaults.removeObject(forKey: String(indexPath.row))
      userDefaults.removeObject(forKey: String(indexPath.row) + "_" + "Setting")
      self.tableView.reloadData()
    }
    else {
      print("not last")
      for i in indexPath.row..<self.users.count {
        if i == self.users.count - 1 {
          userDefaults.removeObject(forKey: String(i))
          userDefaults.removeObject(forKey: String(i) + "_" + "Setting")
          break
        }
        else {
          var basic_setting = userDefaults.dictionary(forKey: String(i + 1))
          userDefaults.set(["ID": i + 1, "Name": basic_setting!["Name"] as! String], forKey: String(i))
          if userDefaults.object(forKey: String(i + 1)+"_"+"Setting") != nil {
            var music_setting = userDefaults.dictionary(forKey: String(i + 1)+"_"+"Setting")
            userDefaults.set(["temp_name": music_setting!["temp_name"], "MPMedia1": music_setting!["MPMedia1"], "MPMedia2": music_setting!["MPMedia2"], "MPMedia3": music_setting!["MPMedia3"], "pitch1": music_setting!["pitch1"], "pitch2": music_setting!["pitch2"], "pitch3": music_setting!["pitch3"], "volume1": music_setting!["volume1"], "volume2": music_setting!["volume2"], "volume3": music_setting!["volume3"], "position1": music_setting!["position1"], "position2": music_setting!["position2"], "position3": music_setting!["position3"], "date": music_setting!["date"], "setNum": music_setting!["setNum"]], forKey: String(i)+"_"+"Setting")
          }
          else {
            userDefaults.removeObject(forKey: String(i) + "_" + "Setting")
          }
        }
      }
      self.users.remove(at: indexPath.row)
      userDefaults.set(self.users.count, forKey: "userNumber")
      if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
        appDelegate.users = self.users
      }
      self.tableView.reloadData()
    }*/
  }
  
  func recUserInfo(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      self.users = appDelegate.users
      self.userNum = self.users.count  //appDelegate.userNum
      //ここ怪しいと思う
      self.userNumber = self.users.count + 1
      self.allUserNum = appDelegate.allUserNum
    }
  }
  
  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    self.navigationController?.pushViewController(secondViewController!, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
    return self.users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
    cell.textLabel?.text = self.users[indexPath.row].Name
    return cell
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
        print()
        for i in 0...(appDelegate.users.count - 1) {
            print("セットデータ前のユーザ名[" , i , "]：　" , appDelegate.users[i].Name)
        }
        
    }
    self.setSendData()
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
        print()
        for i in 0...(appDelegate.users.count - 1) {
            print("セットデータ後のユーザ名[" , i , "]：　" , appDelegate.users[i].Name)
        }
        
    }
    self.setupFlag = false
  }
  func setSendData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if let indexPath = self.tableView.indexPathForSelectedRow {
      let user = users[indexPath.row]
      print("選択された場所は　" , indexPath.row)
      appDelegate.user.BeforeView = "user view"
      appDelegate.user.Id = user.Id
      appDelegate.user.Name = user.Name
      if userDefaults.object(forKey: String(user.Id-1)+"_"+"Setting") != nil {
        var dic = userDefaults.dictionary(forKey: String(user.Id-1)+"_"+"Setting")
        appDelegate.user.template_name = dic!["temp_name"] as! [String]
        appDelegate.user.saved_date = dic!["date"] as! [String]
        appDelegate.user.setNum = dic!["setNum"] as! Int
        appDelegate.user.Playing_1_MPMedia = NSKeyedUnarchiver.unarchiveObject(with: dic!["MPMedia1"] as! Data) as! [MPMediaItem?]
        appDelegate.user.Playing_2_MPMedia = NSKeyedUnarchiver.unarchiveObject(with: dic!["MPMedia2"] as! Data) as! [MPMediaItem?]
        appDelegate.user.Playing_3_MPMedia = NSKeyedUnarchiver.unarchiveObject(with: dic!["MPMedia3"] as! Data) as! [MPMediaItem?]
        appDelegate.user.Playing_1_pitch = dic!["pitch1"] as! [Float]
        appDelegate.user.Playing_2_pitch = dic!["pitch2"] as! [Float]
        appDelegate.user.Playing_3_pitch = dic!["pitch3"] as! [Float]
        appDelegate.user.Playing_1_volume = dic!["volume1"] as! [Float]
        appDelegate.user.Playing_2_volume = dic!["volume2"] as! [Float]
        appDelegate.user.Playing_3_volume = dic!["volume3"] as! [Float]
        appDelegate.user.Playing_1_position = dic!["position1"] as! [Double]
        appDelegate.user.Playing_2_position = dic!["position2"] as! [Double]
        appDelegate.user.Playing_3_position = dic!["position3"] as! [Double]
        appDelegate.user.Playing_1 = nil
        appDelegate.user.Playing_2 = nil
        appDelegate.user.Playing_3 = nil
        //print("テスト  \(appDelegate.user.Playing_1_MPMedia[0]!.value(forProperty: MPMediaItemPropertyTitle)! as! String) ")
      }
      else {
        //print("選択された場所は　" , indexPath.row)
        //appDelegate.user = user
        //print("\n\n辞書の読み込みはしていません\n\n")
        appDelegate.user.template_name = [String]()
        appDelegate.user.saved_date = [String]()
        appDelegate.user.setNum = 0
        appDelegate.user.Playing_1_MPMedia = [MPMediaItem?]()
        appDelegate.user.Playing_2_MPMedia = [MPMediaItem?]()
        appDelegate.user.Playing_3_MPMedia = [MPMediaItem?]()
        appDelegate.user.Playing_1_pitch = [Float]()
        appDelegate.user.Playing_2_pitch = [Float]()
        appDelegate.user.Playing_3_pitch = [Float]()
        appDelegate.user.Playing_1_volume = [Float]()
        appDelegate.user.Playing_2_volume = [Float]()
        appDelegate.user.Playing_3_volume = [Float]()
        appDelegate.user.Playing_1_position = [Double]()
        appDelegate.user.Playing_2_position = [Double]()
        appDelegate.user.Playing_3_position = [Double]()
        appDelegate.user.Playing_1 = nil
        appDelegate.user.Playing_2 = nil
        appDelegate.user.Playing_3 = nil
      }
      appDelegate.showFlag = false
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    print("ユーザの読み込みをしています")
    self.recUserInfo()
    self.tableView.reloadData()
    if self.users.count != 0 {
    for i in 0...(self.users.count - 1) {
      print(self.users[i].Name)
    }
    }
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
 //self.tableView.reloadData()
    
  }
  
  /*
   override func prepare(for segue: UIStoryboardSegue, sender: Any?){
   if let indexPath = self.tableView.indexPathForSelectedRow {
   let user = users[indexPath.row]
   let controller = segue.destination as! MainTabBarController
   controller.title = user.Name
   controller.Id = user.Id
   }
   }
   */
}

