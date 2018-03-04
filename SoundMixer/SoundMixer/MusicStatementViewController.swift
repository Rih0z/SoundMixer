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
  
  var musicSwitch = [UISwitch]()

  var musicLabel = [UILabel]()

  var musicButton = [UIButton]()

  let titleText = "音楽選択画面"
  //配列にしたほうが綺麗なので直します
  let musicTitle = ["音楽1","音楽2","音楽3"]

  var musicText = ["音楽1を下のボタンから選択してください", "音楽2を下のボタンから選択してください", "音楽3を下のボタンから選択してください"]

  var infomationText = "プレイリストから音楽を選択してください"
  
  let buttonText = ["音楽1を変更する","音楽2を変更する","音楽3を変更する"]

  let teachingText = "スイッチをオンにしないと，音楽編集画面でのピッチ変更が有効になりません"
  
  
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
    var musicTitleLabel = [UILabel]()
    let rect = CGRect(x:0,y:0,width:self.width/2,height:30)
    let setup = setupParts()
    let musicFontSize:CGFloat = 20
    let dis = self.height/5
    var flame = CGPoint(x:self.width/2 , y:self.height/3)
    var titleFlame = flame
    var switchFlame = flame
    switchFlame.x = width * 8/10
    titleFlame.x = width/10
    titleFlame.y -= musicFontSize + 4
    
    for i in 0...2{
      self.musicSwitch.append( setup.setupSwitch(linewidth: switchFlame, color: UIColor.black,switchco: self.user.musicEditFlag[i]) )
      musicTitleLabel.append(  setup.setupText(lineWidth:titleFlame, text: musicTitle[i] ,size: rect ,fontSize: musicFontSize) )
      musicLabel.append(  setup.setupText(lineWidth:flame, text: musicText[i] ,size: rect ,fontSize: musicFontSize))
      
      self.view.addSubview(musicSwitch[i])
      self.view.addSubview(musicTitleLabel[i])
       self.view.addSubview(musicLabel[i])
      flame.y += dis
      titleFlame.y = flame.y - musicFontSize - 4
      switchFlame.y = flame.y
    }
    
     musicSwitch[0].addTarget(self, action: #selector(self.switch1Tapped(sender:)), for: .touchUpInside)
     musicSwitch[1].addTarget(self, action: #selector(self.switch2Tapped(sender:)), for: .touchUpInside)
     musicSwitch[2].addTarget(self, action: #selector(self.switch3Tapped(sender:)), for: .touchUpInside)
 
  }
  @objc func switch1Tapped(sender:UISwitch ){
    self.user.musicEditFlag[0] = self.musicSwitch[0].isOn
   print("ユーザー1の音楽編集フラグは")
    print(self.user.musicEditFlag[0])
  }
  @objc func switch2Tapped(sender:UISwitch ){
    self.user.musicEditFlag[1] = self.musicSwitch[1].isOn
    print("ユーザー2の音楽編集フラグは")
    print(self.user.musicEditFlag[1])
  }
  @objc func switch3Tapped(sender:UISwitch ){
    self.user.musicEditFlag[2] = self.musicSwitch[2].isOn
    print("ユーザー3の音楽編集フラグは")
    print(self.user.musicEditFlag[2])
  }
  func setupInfomationLabel(){
    let rect = CGRect(x:0,y:0,width:self.width,height:self.height/10)
    let setup = setupParts()
    let musicFontSize:CGFloat = 20
    
    let titleFlame = CGPoint(x: self.width/2 , y:self.height/10 + musicFontSize)
    var flame = titleFlame
   
    flame.y += musicFontSize * 2
    let TitleLabel = setup.setupText(lineWidth:titleFlame, text: titleText ,size: rect ,fontSize: musicFontSize)
    infomationLabel = setup.setupText(lineWidth:flame, text: infomationText ,size: rect ,fontSize: musicFontSize)
    flame.y += musicFontSize * 2
    let teachLabel = setup.setupText(lineWidth:flame, text: self.teachingText ,size: rect ,fontSize: musicFontSize)
    self.view.addSubview(TitleLabel)
    self.view.addSubview(infomationLabel)
    self.view.addSubview(teachLabel)
  }

  func setupButton(){
    let rect = CGRect(x:0,y:0,width: self.width * 3/4 ,height:self.height/20)
    var frame = CGPoint(x:self.width * 1 / 2,y:self.height / 3 + 70)
    let setup = setupParts()
    
    for i in 0...2 {
    self.musicButton.append( setup.setupButton(rect: rect, lineWidth: frame, text: self.buttonText[i], color: UIColor.blue) )
     self.view.addSubview(self.musicButton[i])
      frame.y += self.height / 5
    }
    self.musicButton[0].addTarget(self, action: #selector(self.btn1Tapped(sender:)), for: .touchUpInside)
    self.musicButton[1].addTarget(self, action: #selector(self.btn2Tapped(sender:)), for: .touchUpInside)
    self.musicButton[2].addTarget(self, action: #selector(self.btn3Tapped(sender:)), for: .touchUpInside)

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
    //音楽1の変更の場合1 2なら2 3,なら3
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
      musicLabel[0].text = music1
      // music1Label.text = "aaa"
    }
    if(self.user.Playing_2 != nil){
      let music2 = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("musicstatement music")
      print(music2)
      musicLabel[1].text = music2
    }
    if(self.user.Playing_3 != nil){
      let music3 = self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle)! as! String
      print("musicstatement music")
      print(music3)
      musicLabel[2].text = music3
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
      if self.secret {
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
            
            print(player.audioEngine.mainMixerNode.outputVolume)
            
            print("audio volume : \(volume)")
            // 監視を終了
            audioSession.removeObserver(self, forKeyPath: "outputVolume")
            
          }
        }
      }
    }
  }
}
