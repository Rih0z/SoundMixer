//
//  UserViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController{
    var userNumber:Int = 1
    var users = [User]()
    var user:User?
    @IBAction func AddUser(_ sender: Any) {
       self.user = User()//Userクラスのインスタンス作成
        self.user?.Id = self.userNumber
        self.user?.Name = "User ID : "+(self.user!.Id).description//ここを任意に入力させて任意の名前をつけさせればいい
        //https://joyplot.com/documents/2016/09/04/swift_textfield_uialertcontroller/ これ見たらできそう
        self.users.append(self.user!)
        self.userNumber += 1;
        self.tableView.reloadData()
        
    }
    

    
    // ボタンを用意
    var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loadaaaaaaaaaaaaaaaaasssssssssssssssssss")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate   = self
        self.tableView.dataSource = self        // タイトルを付けておきましょう
        self.title = "ユーザー選択"
        
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
        self.user?.Name = "User ID : "+(self.user!.Id).description//ここを任意に入力させて任意の名前をつけさせればいい
        //https://joyplot.com/documents/2016/09/04/swift_textfield_uialertcontroller/ これ見たらできそう
        self.users.append(self.user!)
        self.userNumber += 1;

        self.tableView.reloadData()
   

    }
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.goNextPage(page: "MainTabBar")
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let user = users[indexPath.row]
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
