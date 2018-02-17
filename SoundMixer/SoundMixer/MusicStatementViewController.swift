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

  var user:User = User()
  @IBOutlet weak var infomationLabel: UILabel!

  @IBAction func pickPlaylist1(_ sender: Any) {
    //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
    self.user.SelectionFlag = 1
    self.CheckPlaylist()

  }

    @IBAction func pickPlaylist2(_ sender: Any) {
        self.user.SelectionFlag = 2
        self.CheckPlaylist()
        
    }
    
    func CheckPlaylist(){
        
        let myPlaylistQuery = MPMediaQuery.playlists()
        if let playlists = myPlaylistQuery.collections {
            
            print(playlists.count)
            self.sendDataSet()
            self.goNextPage(page: "PlaylistSelection")
            
        }else{
            infomationLabel.text = "選択可能なプレイリストがありません"
            
        }
        
    }
    
    func sendDataSet(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = self.user
        print("Selectingflag musicstatement")
        print(appDelegate.user.SelectionFlag)
    }
  func goNextPage(page:String){
    let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
    let secondViewController = storyboard.instantiateInitialViewController()
    self.navigationController?.pushViewController(secondViewController!, animated: true)
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
      self.user = appDelegate.user
      self.title = appDelegate.user.Name
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
