//
//  MainTabBarController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/14.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    var Id:Int!
    var PlayingSong:MPMediaItem!
    var user:User = User()
    var musiclabel1 :String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.selectedIndex = 1
        //self.selectedIndex = 0

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
      
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
        if (self.user.SelectionFlag != 0)
        {
           // self.user.SelectionFlag = 0
            self.selectedIndex = 1
        }
        if(self.user.Playing_1 != nil){
            let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            print("maintabber willappear music")
            print(music1)
        }
    }
 override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
    }
 
}

