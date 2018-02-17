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
    /*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var viewControllers: [UIViewController] = []
        
        let musicStatementSelectionViewController = MusicStatementViewController()
        musicStatementSelectionViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.mostRecent, tag: 1)
        viewControllers.append(musicStatementSelectionViewController)
        
        
        let playerViewController = PlayerViewController()
        playerViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.mostViewed, tag: 2)
        viewControllers.append(playerViewController)
        
        let metronomeViewController = MetronomeViewController()
        metronomeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.contacts, tag: 3)
        viewControllers.append(metronomeViewController)
        
        self.setViewControllers(viewControllers, animated: false)
        
        
        // なぜか0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0

    }*/
 
 
    
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
    
 override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    /*
     let controller = segue.destination as! MusicStatementViewController
            controller.title = self.title
    let controller2 = segue.destination as! PlayerViewController
    
    let controller3 = segue.destination as! MetronomeViewController
    // controller.Id = user.Id 
    */
    }
 
}

