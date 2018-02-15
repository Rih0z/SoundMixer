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
 
}

