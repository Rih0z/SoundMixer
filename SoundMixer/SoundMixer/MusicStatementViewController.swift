//
//  MusicStatementViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/16.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer
class MusicStatementViewController: UIViewController {


    var Id:Int!
    @IBOutlet weak var infomationLabel: UILabel!
    
    @IBAction func backUser(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        present(nextView!, animated: true, completion: nil)
        
    }
    @IBAction func pickPlaylist1(_ sender: Any) {
        //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
        
        let myPlaylistQuery = MPMediaQuery.playlists()
        
        if let playlists = myPlaylistQuery.collections {
              print(playlists.count)

            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.userID = self.Id
            appDelegate.title = self.title

            
            let storyboard: UIStoryboard = UIStoryboard(name: "PlaylistSelection", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
        }else{
            infomationLabel.text = "選択可能なプレイリストがありません"
          
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        //ViewTitle.text = self.title

        // Do any additional setup after loading the view.
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻ります", style: .plain, target: nil, action: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
        {
            self.Id = appDelegate.userID
            self.title = appDelegate.title
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
