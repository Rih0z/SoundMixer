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
  private var selectLayer:CALayer!
  private var touchLastPoint:CGPoint!
  //デバック用の条件　ここをfalseにしたらめんどくさいことしなくてもUser画面に戻れる
  var debug:Bool = true
  var secret:Bool = false //ここがtrueの時上半分押すとユーザー選択に戻れる　音量0でtrueになる
  var secretButten: CALayer!
  
  @IBOutlet weak var infomationLabel: UILabel!

  @IBOutlet weak var music3Label: UILabel!
  @IBOutlet weak var music2Label: UILabel!
  @IBOutlet weak var music1Label: UILabel!

  @IBAction func pickPlaylist1(_ sender: Any) {
    //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
    self.user.SelectionFlag = 1
    self.CheckPlaylist()
  }

  @IBAction func pickPlaylist2(_ sender: Any) {
    self.user.SelectionFlag = 2
    self.CheckPlaylist()
  }

  @IBAction func pickPlaylist3(_ sender: Any) {
    self.user.SelectionFlag = 3
    self.CheckPlaylist()
  }
  
  func CheckPlaylist(){

    let myPlaylistQuery = MPMediaQuery.playlists()
    if let playlists = myPlaylistQuery.collections {
      print(playlists.count)
      self.user.BeforeView = "music statement"
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
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:0,y:self.view.bounds.height *  5/7,width:self.view.bounds.width/3,height:self.view.bounds.height / 8)
    rect.clearAll(lineWidth:1)
    self.view.layer.addSublayer(rect)
    self.secretButten = rect
    NotificationCenter.default.addObserver(self, selector: #selector(self.volumeChanged(notification:)), name:
      NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    /*
    if (self.user.Playing_1 != nil) {
    let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
    print(music1)
    music1Label.text = music1
    }
    if (self.user.Playing_2 != nil) {
    let music2 = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
    print(music2)
    music2Label.text = music2
    }
    */
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
    self.receiveData()
    
    print("musicstatement recieve data finished")
    self.changeMusicLabels()
    }
    
    func changeMusicLabels(){
        print("musicstatement before view is...")
        //print(self.user.BeforeView)
        if(self.user.Playing_1 != nil){
            let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            print("musicstatement music")
            print(music1)
            music1Label.text = music1
        }
        if(self.user.Playing_2 != nil){
            let music2 = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            print("musicstatement music")
            print(music2)
            music2Label.text = music2
        }
      if(self.user.Playing_3 != nil){
        let music3 = self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle)! as! String
        print("musicstatement music")
        print(music3)
        music3Label.text = music3
      }
    }
  func receiveData(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      self.user = appDelegate.user
     // self.title = appDelegate.user.Name
    }
    //これいらないのでは
    if(self.user.Playing_1 != nil){
      let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("musicstatement player music")
      print(music1)
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
  /************** Touch Action ****************/
  func hitLayer(touch:UITouch) -> CALayer{
    var touchPoint:CGPoint = touch.location(in:self.view)
    touchPoint = self.view.layer.convert(touchPoint, to: self.view.layer.superlayer)
    return self.view.layer.hitTest(touchPoint)!
  }
  func selectLayerFunc(layer:CALayer?) {
    if((layer == self.view.layer) || (layer == nil)){
      selectLayer = nil
      return
    }
    selectLayer = layer
  }
  
  
  //タッチをした時
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //すでに選択されているレイヤーがあるかもしれないのでnilにしておく
    selectLayer = nil
    //タッチを取得
    let touch:UITouch = touches.first!
    //タッチした場所にあるレイヤーを取得
    let layer:CALayer = hitLayer(touch: touch)
    //タッチされた座標を取得
    let touchPoint:CGPoint = touch.location(in: self.view)
    //最後にタッチされた場所に座標を入れて置く
    touchLastPoint = touchPoint
    //選択されたレイヤーをselectLayerにいれる
    self.selectLayerFunc(layer:layer)
    if(selectLayer == self.secretButten ){
      if(self.secret)
      {
        self.navigationController?.popToRootViewController(animated:true)
      }
    }
  }

    //タッチが動いた時
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch:UITouch = touches.first!
    let touchPoint:CGPoint = touch.location(in:self.view)
    //直前の座標との差を取得
    // let touchOffsetPoint:CGPoint = CGPoint(x:touchPoint.x - touchLastPoint.x,
    //                                          y:touchPoint.y - touchLastPoint.y)
    touchLastPoint = touchPoint
    
    if (selectLayer == self.secretButten ){
      //hitしたレイヤーがあった場合
      //  let px:CGFloat = selectLayer.position.x
      //  let py:CGFloat = selectLayer.position.y
      //レイヤーを移動させる
      //  CATransaction.begin()
      CATransaction.setDisableActions(true)
      // selectLayer.position = CGPoint(x:px + touchOffsetPoint.x,y:py + touchOffsetPoint.y)
      selectLayer.borderWidth = 3.0
      selectLayer.borderColor = UIColor.red.cgColor
      //   CATransaction.commit()
    }
  }
  
  //タッチを終えた時
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if(selectLayer != nil){
      selectLayer.borderWidth = 0
    }
  }
  
  //タッチがキャンセルされた時
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if(selectLayer != nil){
      selectLayer.borderWidth = 0
    }
  }
  //*************物理キー********************
  @objc func volumeChanged(notification: NSNotification) {
    //ボリュームキーに変更があると実行される
    if let userInfo = notification.userInfo {
      if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
        if volumeChangeType == "ExplicitVolumeChange" {
          if(debug){
          print("changed! \(userInfo)")
            // 取得
            let audioSession = AVAudioSession.sharedInstance()
            // 監視を有効にする
            try! audioSession.setActive(true)
            let volume = audioSession.outputVolume
            if( volume == 0 ){
              self.secret = true
            }
            // 監視を開始
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: [ .new ], context: nil)
            print("audio volume : \(volume)")
            // 監視を終了
            audioSession.removeObserver(self, forKeyPath: "outputVolume")
            
          }
        }
      }
    }
  }
}
