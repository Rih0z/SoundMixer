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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.selectedIndex = 1
        //self.selectedIndex = 0

    }
 
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.receiveData()
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.user.SelectionFlag != 0)
        {
            self.user.SelectionFlag = 0
            self.selectedIndex = 1
            
        }
    }
 override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
    }
 
}

