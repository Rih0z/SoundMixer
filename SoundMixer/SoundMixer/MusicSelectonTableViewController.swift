//
//  MusicSelectonTableViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/15.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import UIKit
import MediaPlayer
class MusicSelectonTableViewController: UITableViewController {
  //var Id:Int!
  var Playlist:MPMediaItemCollection!
  var SongNum:Int!
  var SongNames = [String]()
  var Songs = [MPMediaItem]()
  var SongName: String!
  // var SongHash:Int!
  var Song:MPMediaItem!
  var user:User = User()
  // Cell が選択された場合
  override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
    self.goNextPage(page: "MainTabBar")
    //self.navigationController?.popViewControllerAnimated(true) で前の画面に戻れる？https://qiita.com/moshisora/items/f1b6eeee5305e649d32b
  }


  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    self.navigationController?.pushViewController(secondViewController!, animated: true)
  }


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
    return SongNum
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell",for: indexPath)
    cell.textLabel?.text = self.SongNames[indexPath.row]
    return cell
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist



  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewDidDisappear(animated)
    self.receiveData()
    let songs = self.Playlist.items
    self.SongNum = songs.count
    print(self.SongNum)
    for song in songs {
      // self.Song = song
      let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
      print("\t\t", songTitle!)
      self.SongName = songTitle! as! String
      self.SongNames.append(self.SongName)
      self.Songs.append(song)

    }

  }
    func receiveData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.user = appDelegate.user
        self.Playlist = appDelegate.Playlists
        print("Selectionflag musicselection")
        print(self.user.SelectionFlag)
        
    }
    
    func setSendData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let indexPath = self.tableView.indexPathForSelectedRow {
            switch self.user.SelectionFlag {
            case 1:
                self.user.Playing_1 = self.Songs[indexPath.row]
            case 2:
                self.user.Playing_2 = self.Songs[indexPath.row]
            default:
                print("フラグが立っていませんmusicselection")
                print(self.user.SelectionFlag)
            }
            appDelegate.user = self.user
        }
        
    }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
     self.user.BeforeView = "music selection"
    setSendData()
    if(self.user.Playing_1 != nil)
    {
        let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
        print("musicsselection music...")
        print(music1)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  /*
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
  if let indexPath = self.tableView.indexPathForSelectedRow {
  let controller = segue.destination as! PlayerViewController
  controller.title = self.SongNames[indexPath.row]
  controller.PlayingSong = self.Songs[indexPath.row]            
  }
  }
  */
  // MARK: - Table view data source
  /*
  override func numberOfSections(in tableView: UITableView) -> Int {
  // #warning Incomplete implementation, return the number of sections
  return 0
  }
  */
  /*
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

  // Configure the cell...

  return cell
  }
  */

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
  // Delete the row from the data source
  tableView.deleteRows(at: [indexPath], with: .fade)
} else if editingStyle == .insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
