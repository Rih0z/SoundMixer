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
  
  var width:CGFloat!
  var height:CGFloat!
  
  var infomationLabel: UILabel!
  
  var music1Switch:UISwitch!
  var music2Switch:UISwitch!
  var music3Switch:UISwitch!
  
  var music1Label: UILabel!
  var music3Label: UILabel!
  var music2Label: UILabel!
  
  
  var music1Button:UIButton!
  var music2Button:UIButton!
  var music3Button:UIButton!
  
  let titleText = "音楽選択画面"
  //配列にしたほうが綺麗なので直します
  let music1Title = "音楽1"
  let music2Title = "音楽2"
  let music3Title = "音楽3"
  
  var music1Text = "音楽1を下のボタンから選択してください"
  var music2Text = "音楽2を下のボタンから選択してください"
  var music3Text = "音楽3を下のボタンから選択してください"
  var infomationText = "プレイリストから音楽を選択してください"
  
  let button1Text = "音楽1を変更する"
  let button2Text = "音楽2を変更する"
  let button3Text = "音楽3を変更する"
  
  
  
  /*
   @IBAction func pickPlaylist1(_ sender: Any) {
   //https://developer.apple.com/documentation/mediaplayer/mpmediaplaylist
   self.CheckPlaylist(whitchplaylist:  1)
   }
   
   @IBAction func pickPlaylist2(_ sender: Any) {
   self.CheckPlaylist(whitchplaylist: 2)
   }
   
   @IBAction func pickPlaylist3(_ sender: Any) {
   self.CheckPlaylist(whitchplaylist: 3)
   }*/
  /***********: set up ****************/
  func setupAll(){
    self.width = self.view.bounds.width
    self.height = self.view.bounds.height
    self.setupLabels()
    self.setupButton()
    
  }
  
  func setupLabels(){
    setupMusicLabel()
    setupInfomationLabel()
  }
    //switch の描画もここでやってます
  func setupMusicLabel(){
    let rect = CGRect(x:0,y:0,width:self.width/2,height:30)
    let setup = setupParts()
    let musicFontSize:CGFloat = 20
    let dis = musicFontSize * 2 + 8
    var flame = CGPoint(x:self.width/2 , y:self.height/3)
    var titleFlame = flame
    var switchFlame = flame
    switchFlame.x = width * 8/10
    titleFlame.x = width/10
    titleFlame.y -= musicFontSize + 4

    
    self.music1Switch = setup.setupSwitch(linewidth: switchFlame, color: UIColor.black)
    let music1TitleLabel = setup.setupText(lineWidth:titleFlame, text: music1Title ,size: rect ,fontSize: musicFontSize)
    music1Label = setup.setupText(lineWidth:flame, text: music1Text ,size: rect ,fontSize: musicFontSize)
    
    flame.y += dis
    titleFlame.y = flame.y - musicFontSize - 4
    switchFlame.y = flame.y
    
     self.music2Switch = setup.setupSwitch(linewidth: switchFlame, color: UIColor.black)
    let music2TitleLabel = setup.setupText(lineWidth:titleFlame, text: music2Title ,size: rect ,fontSize: musicFontSize)
    music2Label = setup.setupText(lineWidth:flame, text: music2Text ,size: rect , fontSize: musicFontSize)
    
    flame.y += dis
    titleFlame.y = flame.y - musicFontSize - 4
    switchFlame.y = flame.y
     self.music3Switch = setup.setupSwitch(linewidth: switchFlame, color: UIColor.black)
    let music3TitleLabel = setup.setupText(lineWidth:titleFlame, text: music3Title ,size: rect ,fontSize: musicFontSize)
    music3Label = setup.setupText(lineWidth:flame, text: music3Text ,size: rect, fontSize: musicFontSize)
    
     music1Switch.addTarget(self, action: #selector(self.switch1Tapped(sender:)), for: .touchUpInside)
     music2Switch.addTarget(self, action: #selector(self.switch2Tapped(sender:)), for: .touchUpInside)
     music3Switch.addTarget(self, action: #selector(self.switch3Tapped(sender:)), for: .touchUpInside)
    
    self.view.addSubview(music1Switch)
    self.view.addSubview(music2Switch)
    self.view.addSubview(music3Switch)
   
    
    self.view.addSubview(music1TitleLabel)
    self.view.addSubview(music2TitleLabel)
    self.view.addSubview(music3TitleLabel)
    self.view.addSubview(music1Label)
    self.view.addSubview(self.music2Label)
    self.view.addSubview(self.music3Label)
  }
  @objc func switch1Tapped(sender:UISwitch ){
    self.user.musicEditFlag_1 = self.music1Switch.isOn
   print("ユーザー1の音楽編集フラグは")
    print(self.user.musicEditFlag_1)
  }
  @objc func switch2Tapped(sender:UISwitch ){
    self.user.musicEditFlag_2 = self.music2Switch.isOn
    print("ユーザー2の音楽編集フラグは")
    print(self.user.musicEditFlag_2)
  }
  @objc func switch3Tapped(sender:UISwitch ){
    self.user.musicEditFlag_3 = self.music3Switch.isOn
    print("ユーザー3の音楽編集フラグは")
    print(self.user.musicEditFlag_3)
  }
  func setupInfomationLabel(){
    let rect = CGRect(x:0,y:0,width:self.width,height:self.height/10)
    let setup = setupParts()
    let musicFontSize:CGFloat = 20
    
    let titleFlame = CGPoint(x: self.width/2 , y:self.height/10 + musicFontSize)
    var flame = titleFlame
    flame.x = self.width/2
    flame.y += musicFontSize * 2
    let TitleLabel = setup.setupText(lineWidth:titleFlame, text: titleText ,size: rect ,fontSize: musicFontSize)
    infomationLabel = setup.setupText(lineWidth:flame, text: infomationText ,size: rect ,fontSize: musicFontSize)
    
    self.view.addSubview(TitleLabel)
    self.view.addSubview(infomationLabel)
  }

  func setupButton(){
    let rect = CGRect(x:0,y:0,width: self.width * 3/4 ,height:self.height/20)
    var frame = CGPoint(x:self.width * 1 / 2,y:self.height * 7 / 10)
    let setup = setupParts()
    
    
    self.music1Button = setup.setupButton(rect: rect, lineWidth: frame, text: self.button1Text, color: UIColor.blue)
    self.music1Button.addTarget(self, action: #selector(self.btn1Tapped(sender:)), for: .touchUpInside)
    
    frame.y += rect.height * 2
    self.music2Button = setup.setupButton(rect: rect, lineWidth: frame, text: self.button2Text, color: UIColor.blue)
    self.music2Button.addTarget(self, action: #selector(self.btn2Tapped(sender:)), for: .touchUpInside)
    
    frame.y += rect.height * 2
    self.music3Button = setup.setupButton(rect: rect, lineWidth: frame, text: self.button3Text, color: UIColor.blue)
    self.music3Button.addTarget(self, action: #selector(self.btn3Tapped(sender:)), for: .touchUpInside)
    
    self.view.addSubview(self.music1Button)
    self.view.addSubview(self.music2Button)
    self.view.addSubview(self.music3Button)
  }
  
  /****************button funcs **********************/
  @objc func btn1Tapped( sender:UIButton ){
    print("Button1")
    self.CheckPlaylist(whitchplaylist: 1)
  }
  
  @objc func btn2Tapped( sender:UIButton ){
    print("Button2")
    self.CheckPlaylist(whitchplaylist: 2)
  }
  
  @objc func btn3Tapped( sender:UIButton ){
    print("Button3")
    self.CheckPlaylist(whitchplaylist: 3)
  }
  
  func CheckPlaylist(whitchplaylist:Int){
    
    self.user.SelectionFlag = whitchplaylist
    
    let myPlaylistQuery = MPMediaQuery.playlists()
    if let playlists = myPlaylistQuery.collections {
      print(playlists.count)
      self.user.BeforeView = "music statement"
      self.sendDataSet()
      self.goNextPage(page: "PlaylistSelection")
    }else{
      infomationLabel.text = "選択可能なプレイリストがありません"
      infomationLabel.sizeToFit()
      
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
    let volumeView = MPVolumeView(frame: CGRect(origin:CGPoint(x:/*-3000*/ 0, y:0), size:CGSize.zero))
    self.view.addSubview(volumeView)
    NotificationCenter.default.addObserver(self, selector: #selector(self.volumeChanged(notification:)), name:
      NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    
    //ViewTitle.text = self.title
    // Do any additional setup after loading the view.
    //navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻ります", style: .plain, target: nil, action: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  /***************** Appear ***************************/
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.receiveData()
    
    print("musicstatement recieve data finished")
    self.setupAll()
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
      // music1Label.text = "aaa"
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
