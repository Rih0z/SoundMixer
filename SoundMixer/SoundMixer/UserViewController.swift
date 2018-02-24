//
//  UserViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
  var userNum: Int = 0
  var userNumber:Int = 1
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
    self.tableView.dataSource = self        // タイトルを付けておきましょう
    self.title = "ユーザー選択"
    self.recUserInfo()
    self.tableView.reloadData()
    if(setupFlag){
    self.setupNavigationBar()
    }
  }
    
  func setupNavigationBar(){
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // addBtnを設置
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onClick))
        self.navigationItem.rightBarButtonItem = addBtn
  }
    
  @objc func onClick()
  {
    print("onClick clicked!!!")
    Clicked()
  }
  func Clicked(){
    self.user = User()//Userクラスのインスタンス作成
    self.user?.Id = self.userNumber
    
    let alert = UIAlertController(title: "あなたの名前を入力してください", message: "", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "入力終了", style: .default) { (action:UIAlertAction!) -> Void in
        let textField = alert.textFields![0] as UITextField
        self.user?.Name = textField.text!
        self.users.append(self.user!)
        self.userNumber += 1;
        self.tableView.reloadData()
        
        /* ID ごとにユーザを辞書形式で登録しユーザ数も保存（クラスでの保存ができない） */
        userDefaults.set(["ID": self.user!.Id, "Name": self.user!.Name], forKey: String(self.user!.Id - 1))
        userDefaults.set(self.userNumber - 1, forKey: "userNumber")
    }
    let cancelAction = UIAlertAction(title: "取り消し", style: .default) { (action:UIAlertAction!) -> Void in }
    
    // UIAlertControllerにtextFieldを追加
    alert.addTextField { (textField:UITextField!) -> Void in }
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  // Cell が選択された場合
  override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
    self.goNextPage(page: "MainTabBar")
  }

  func recUserInfo(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
      {
        self.users = appDelegate.init_users
        self.userNum = appDelegate.userNum
        self.userNumber = self.userNum + 1
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
    self.setSendData()
    self.setupFlag = false
  }
  func setSendData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if let indexPath = self.tableView.indexPathForSelectedRow {
      let user = users[indexPath.row]
      user.BeforeView = "user view"
      appDelegate.user.Id = user.Id
      appDelegate.user.Name = user.Name
    }
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
