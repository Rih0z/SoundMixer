//
//  UserViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
//クラスの中に入れたいけど受け渡しができるのかわからないのでグローバル変数にしています　利穂
var userNumber:Int = 1
var users = [User]()
var user:User?
class UserViewController: UITableViewController{

    @IBAction func AddUser(_ sender: Any) {
       user = User()//Userクラスのインスタンス作成
        user?.Id = userNumber
        user?.Name = "User ID : "+(user!.Id).description//ここを任意に入力させて任意の名前をつけさせればいい
        //https://joyplot.com/documents/2016/09/04/swift_textfield_uialertcontroller/ これ見たらできそう
        users.append(user!)
        userNumber += 1;
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)

        cell.textLabel?.text = users[indexPath.row].Name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let user = users[indexPath.row]
            let controller = segue.destination as! MainTabBarController
            controller.title = user.Name
            controller.Id = user.Id
            
        }
    }
    
}
