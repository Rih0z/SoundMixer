//
//  PlaylistSelectionViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/14.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistSelectionViewController: UITableViewController, MainTabBarDelegate{
    var PlaylistNum:Int!
    var PlaylistsName = [String]()
    var PlaylistName: String!
    var Playlists = [MPMediaItemCollection]()
    var Id:Int!
    
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.goNextPage(page: "MusicSelection")
        //self.navigationController?.popViewControllerAnimated(true) で前の画面に戻れる？https://qiita.com/moshisora/items/f1b6eeee5305e649d32b
    }
    func goNextPage(page:String){
        let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
        let secondViewController = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return self.PlaylistNum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell",for: indexPath)
        cell.textLabel?.text = self.PlaylistsName[indexPath.row]
        return cell
    }
 
    //画面が呼び出される前に実行
    override func viewDidLoad() {
        super.viewDidLoad()
        let myPlaylistQuery = MPMediaQuery.playlists()
            if let playlists = myPlaylistQuery.collections {
                self.PlaylistNum = playlists.count
                print(self.PlaylistNum)
                for playlist in playlists {
                    
                    self.PlaylistName = playlist.value(forProperty: MPMediaPlaylistPropertyName)! as! String
                    print(self.PlaylistName)
                    self.Playlists.append(playlist)
                    self.PlaylistsName.append(self.PlaylistName)

                }
            
        }
    }

    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let indexPath = self.tableView.indexPathForSelectedRow {
            appDelegate.Playlists = self.Playlists[indexPath.row]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
        {
            self.Id = appDelegate.userID
            self.title = appDelegate.title
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let playlistname = self.PlaylistsName[indexPath.row]
            let controller = segue.destination as! MusicSelectonTableViewController
            controller.title = playlistname
          ///  controller.PlaylistHash = self.PlaylistsHash[indexPath.row]
        }
    }
    
    func didSelectTab(mainTabBarController: MainTabBarController) {
        print("PlaylistControllerView")
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
