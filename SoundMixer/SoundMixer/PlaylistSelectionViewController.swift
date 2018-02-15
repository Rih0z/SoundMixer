//
//  PlaylistSelectionViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/14.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistSelectionViewController: UITableViewController{
    var PlaylistNum:Int!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return self.PlaylistNum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell",for: indexPath)
        
       // cell.textLabel?.text = self.users[indexPath.row].Name
        return cell
    }
 
    //画面が呼び出される前に実行
    override func viewDidLoad() {
        super.viewDidLoad()
//https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
    
        let myPlaylistQuery = MPMediaQuery.playlists()
        if let playlists = myPlaylistQuery.collections {
           self.PlaylistNum = playlists.count
            print(self.PlaylistNum)
            for playlist in playlists {
                print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
                
                let songs = playlist.items
                for song in songs {
                    let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
                    print("\t\t", songTitle!)
                }
            }
        }
 
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
