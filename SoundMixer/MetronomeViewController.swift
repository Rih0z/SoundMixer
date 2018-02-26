//
//  ThirdViewController.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//
//  The base of this program is http://uruly.xyz/%E3%80%90swift-3%E3%80%91calayer%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6%E5%9B%B3%E5%BD%A2%E3%82%92%E7%A7%BB%E5%8B%95%E3%83%BB%E6%8B%A1%E5%A4%A7%E7%B8%AE%E5%B0%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/
//  by Reo
import UIKit
import AudioToolbox
import MediaPlayer

class MetronomeViewController: UIViewController  , UIGestureRecognizerDelegate{

  var user:User = User()
  var timer: Timer!
  var leftoval: CALayer!
  var rightoval: CALayer!
  var flag:Bool = true
  var setupflag:Bool = true
  var bpmModeFlag:Bool = true
  var tmpspeed:Float = 3.0
  var tmpmax:Float = 5.05
  var tmpmin:Float = 0.15
  var bpmmax:Float = 250
  var bpmmin:Float = 1
  var bpm:Float = 60
  
  
  var speedLabel:UILabel!
  var slider:UISlider!
  
  private var hiddenFlag :Bool = false
  
  
  private var selectLayer:CALayer!
  private var touchLastPoint:CGPoint!
  
  private var beginGestureScale:CGFloat!
  private var effectiveScale:CGFloat!
  
  private var hiddenButton:UIButton!
  private var bpmButton:UIButton!
  private var leftButton:UIButton!
  private var rightButton:UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupAll()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.receiveData()
    if self.user.Playing_1 != nil {
      self.bpm = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyBeatsPerMinute) as! Float
      self.timerReset()
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.setSendData()
  }
  
  //**************:update*******************
  @objc func update(tm: Timer) {
    // do something
    if(self.hiddenFlag){
      
    }else{
      if self.flag {
       self.blueBorder(layer: self.leftoval)
       self.whiteBorder(layer: self.rightoval)
       self.drawRight()
       self.flag = false
      }else {
       self.blueBorder(layer: self.rightoval)
       self.whiteBorder(layer: self.leftoval)
       self.drawLeft()
       self.flag = true
     }
    }
  }

  /************* pinch ***************/
  @objc func pinchGesture(sender:UIPinchGestureRecognizer){
    effectiveScale = beginGestureScale * sender.scale
    //選択されてるやつだけ
    if (selectLayer != nil){
      selectLayer.setAffineTransform(CGAffineTransform(scaleX: effectiveScale,y:effectiveScale))
    }
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if(gestureRecognizer.isKind(of:UIPinchGestureRecognizer.self)){
      beginGestureScale = effectiveScale
    }
    return true
  }
  
  /************** Button Tapped ***********/
  @objc func ovalBtnTapped(sender:UIButton){
    if(self.bpmModeFlag)
    {
      if(self.bpm < self.bpmmax - 1){
        self.bpm += 0.1
        self.timerReset()
        self.updateSliderValue()
      }

    }else{
    if(self.tmpspeed > self.tmpmin ){
      self.tmpspeed -= 0.1
      self.timerReset()
      self.updateSliderValue()
    }
    }
  }
  @objc func rectBtnTapped(sender:UIButton){
    //四角を描く 遅くするボタンをタップされたら
    if(self.bpmModeFlag)
    {
      if(self.bpm > self.bpmmin + 1){
        self.bpm -= 0.1
        self.timerReset()
        self.updateSliderValue()
      }
    }else{
    if(self.tmpspeed <= self.tmpmax){
      self.tmpspeed += 0.1
      if(self.tmpspeed > 5.00){
        self.tmpspeed = 5.00
      }
      self.timerReset()
      self.updateSliderValue()
    }
    }
  }
  @objc func hiddenBtnTapped(sender:UIButton){
    //アニメ非表示ボタンが押されたら
    self.hiddenFlag = !self.hiddenFlag
    if self.hiddenFlag
    {
      self.reset()
      self.drawHiddenButton()
      let text = "アニメ表示"
      self.hiddenButton.setTitle(text,for:.normal)
    }else{
      self.setupAll()
      let text = "アニメ非表示"
      self.hiddenButton.setTitle(text,for:.normal)
      
    }
  }
  @objc func bpmBtnTapped(sender:UIButton){
    //表示切り替えボタンが押されたら
    self.bpmModeFlag = !self.bpmModeFlag
    if bpmModeFlag {
      let text = "秒表記に"
      self.bpmButton.setTitle(text,for:.normal)
      self.bpm = 60 / self.tmpspeed
    }else{
      let text = "BPM表記に"
      self.tmpspeed = 1 / (self.bpm/60)
      self.bpmButton.setTitle(text,for:.normal)
    }
    self.changeLRButten()
    self.timerReset()
    self.updateSliderValue()
    
  }
  @objc func onChange(_ sender: UISlider) {
    // スライダーの値が変更された時の処理
    if self.bpmModeFlag {
      self.bpm = self.map(x: sender.value, in_min: sender.maximumValue,in_max: sender.minimumValue , out_min: self.bpmmax , out_max: self.bpmmin )
    } else {
      self.tmpspeed = self.map(x: sender.value, in_min: sender.maximumValue,in_max: sender.minimumValue , out_min: self.tmpmax , out_max: self.tmpmin )
    }
    self.timerReset()
  }
  @objc func updateSliderValue(){
    if self.bpmModeFlag {
      self.slider.value = self.map(x: self.bpm, in_min: self.bpmmin, in_max: self.bpmmax, out_min: slider.minimumValue, out_max: slider.maximumValue)
    }else{
      self.slider.value = self.map(x: self.tmpspeed, in_min: self.tmpmin, in_max: self.tmpmax, out_min: slider.minimumValue, out_max: slider.maximumValue)
    }
  }
  //***********set up *************
  func setupAll(){
    self.drawSetUp()
    self.setupTimer()
  }
  func setupTimer(){
    // 一定間隔で実行
    if self.bpmModeFlag
    {
      self.timer = Timer.scheduledTimer(timeInterval: Double(1 / (self.bpm/60) ), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
      
    } else{
    self.timer = Timer.scheduledTimer(timeInterval: Double(self.tmpspeed), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    self.timer.fire()
  }
  //************ setup UI PARTS *****************
  //スライダーを表示
  @objc func setupSlider(linewidth: CGPoint, target_value: Float , target_min :Float , target_max : Float  ) -> UISlider{
    // スライダーの作成
    let slider = UISlider()
    // 幅を いい感じ に変更する
    slider.frame.size.width = self.view.bounds.width - (self.view.bounds.width/3)
    slider.sizeToFit()
    slider.center = linewidth
    
    // 最小値を tmpmin に変更する
    slider.minimumValue = 0
    // 最大値を tmpmax に変更する
    slider.maximumValue = 100
    
    slider.value = self.map(x: target_value, in_min: target_min, in_max: target_max , out_min: slider.minimumValue,out_max: slider.maximumValue)    // スライダーの値が変更された時に呼び出されるメソッドを設定
    slider.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
    return slider
    // スライダーを画面に追加
  }
  //テキストボックスを表示
  @objc func setupText(lineWidth:CGPoint, text:String,size:CGRect) -> UILabel {
    let label = UILabel(frame: size)
    label.text = text
    label.font = UIFont(name: "HiraMinProN-W3", size: 30)
    label.sizeToFit()
    label.center = lineWidth
    return label
  }
  @objc func setupButton(rect: CGRect,lineWidth:CGPoint , text:String , color:UIColor) -> UIButton {
    //非表示ボタン
    let Btn = UIButton()
    Btn.frame = rect
    Btn.center = lineWidth

    Btn.setTitle(text,for:.normal)
    Btn.backgroundColor = color
    return Btn
  }
  //**********draw***************
  
  func drawSetUp(){
    if(self.setupflag){
      self.flag = true
      self.setupflag = false
    }
    effectiveScale = 1.0
    self.drawSlider()
    self.drawLabel()
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    
    //丸を生成するボタン
    self.leftButton = UIButton()
    self.leftButton.frame = CGRect(x:0,y:0,width:100,height:50)
    self.leftButton.center = CGPoint(x:width / 5,y:height - 100)
    
    //四角を生成するボタン
    self.rightButton = UIButton()
    self.rightButton.frame = CGRect(x:0,y:0,width:100,height:50)
    self.rightButton.center = CGPoint(x:width * 4 / 5,y:height - 100)
    
    
    changeLRButten()
 self.view.addSubview(self.leftButton)
    self.view.addSubview(self.rightButton)
    

    
    drawRects()
    self.drawBpmButton()
    self.drawHiddenButton()
    //ピンチ
    let pinch = UIPinchGestureRecognizer()
    pinch.addTarget(self,action:#selector(MetronomeViewController.pinchGesture(sender:)))
    pinch.delegate = self
    self.view.addGestureRecognizer(pinch)
    
  }
  func changeLRButten(){
    if self.bpmModeFlag {
      self.leftButton = self.speedDownButton(Btn: self.leftButton)
      self.rightButton  = self.speedUpButton(Btn: self.rightButton)
    } else {
      self.rightButton = self.speedDownButton(Btn: self.rightButton)
       self.leftButton = self.speedUpButton(Btn: self.leftButton)
    }
    
  }
  func speedUpButton(Btn:UIButton) ->UIButton{
    Btn.addTarget(self, action: #selector(MetronomeViewController.ovalBtnTapped(sender:)), for: .touchUpInside)
    Btn.setTitle("速くする",for:.normal)
    Btn.backgroundColor = UIColor.green
    return Btn
  }
  func speedDownButton(Btn: UIButton) -> UIButton{
    Btn.addTarget(self, action: #selector(MetronomeViewController.rectBtnTapped(sender:)), for: .touchUpInside)
    Btn.setTitle("遅くする",for:.normal)
    Btn.backgroundColor = UIColor.red
    return Btn
  }
  func drawBpmButton(){
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    let rect = CGRect(x:0,y:0,width:150,height:50)
    let frame = CGPoint(x:width * 1 / 5,y:height / 6)
    let text = "秒表記に"
    self.bpmButton = setupButton(rect: rect, lineWidth: frame, text: text, color: UIColor.blue)
    self.bpmButton.addTarget(self, action: #selector(MetronomeViewController.bpmBtnTapped(sender:)), for: .touchUpInside)
    self.view.addSubview(self.bpmButton)
  }
  func drawHiddenButton(){
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    let rect = CGRect(x:0,y:0,width:150,height:50)
    let frame = CGPoint(x:width * 4 / 5,y:height / 6)
    let text = "アニメ非表示"
    self.hiddenButton = setupButton(rect: rect, lineWidth: frame, text: text, color: UIColor.blue)
    self.hiddenButton.addTarget(self, action: #selector(MetronomeViewController.hiddenBtnTapped(sender:)), for: .touchUpInside)
    self.view.addSubview(self.hiddenButton)
    
  }

  @objc func drawRects(){
    drawRight()
    drawLeft()
  }
  @objc func drawLeft(){
   // let width = self.view.bounds.width
    let height = self.view.bounds.height
    //初期の左側ボタン
    let oval = MyShapeLayer()
    oval.frame = CGRect(x:30,y:height/2,width:80,height:80)
    oval.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval)
    self.leftoval = oval
  }
  @objc func drawRight(){
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    //初期の右側ボタン
    let oval2 = MyShapeLayer()
    oval2.frame = CGRect(x:width - 30 - 80,y:height/2,width:80,height:80)
    oval2.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval2)
    self.rightoval = oval2
  }
  @objc func blueBorder(layer : CALayer?) {
    if((layer == self.view.layer) || (layer == nil)){
      return
    }
    layer?.borderWidth = 4.0
    layer?.borderColor = UIColor.blue.cgColor
  }
  @objc func whiteBorder(layer : CALayer?) {
    if((layer == self.view.layer) || (layer == nil)){
      return
    }
    layer?.borderWidth = 4.0
    layer?.borderColor = UIColor.white.cgColor
  }
  func drawSlider(){
    let sliderFlame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height - (self.view.bounds.height/5))
    if bpmModeFlag{
      self.slider = setupSlider(linewidth: sliderFlame, target_value: self.bpm, target_min: self.bpmmin, target_max: self.bpmmax)
    }else{
       self.slider = setupSlider(linewidth: sliderFlame, target_value: self.tmpspeed, target_min: self.tmpmin, target_max: self.tmpmax)
    }
    self.view.addSubview(self.slider)
  }
  
  func drawLabel() {
    let flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
    var speedtext:UILabel!
    let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
    if bpmModeFlag
    {
      speedtext = setupText(lineWidth: flame, text:String(floor(self.bpm*10)/10) + " BPM",size: rect)
    }else
    {
      speedtext = setupText(lineWidth: flame, text:String( floor(self.tmpspeed*10)/10 ) + "秒毎",size: rect)
    }
    self.speedLabel = speedtext
    self.speedLabel.sizeToFit()
    self.view.addSubview(self.speedLabel)
  }

  //**********clear***************

  func clearRects(){
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:0,y:self.view.bounds.height/2 ,width:self.view.bounds.width,height:100)
    rect.clearAll(lineWidth:1)
    self.view.layer.addSublayer(rect)
    /*
     oval.frame = CGRect(x:30,y:height/2,width:80,height:80)
     oval.drawOval(lineWidth:1)
     self.view.layer.addSublayer(oval)
     self.leftoval = oval
     //初期の右側ボタン
     let oval2 = MyShapeLayer()
     oval2.frame = CGRect(x:width - 30 - 80,y:height/2,width:80,height:80)
     */
  }
  @objc func clearBorders(){
    self.whiteBorder(layer: self.rightoval)
    self.whiteBorder(layer: self.leftoval)
  }
  //*****************Reset**********************
  func reset(){
    self.timer.invalidate()
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:self.view.bounds.height)
    rect.clearAll(lineWidth:1)
    self.view.layer.addSublayer(rect)
  }
  func timerReset(){
    self.flagReset()
    // self.reset()
    // self.drawSetUp()
    self.clearBorders()
    self.timer.invalidate()
    self.setupTimer()
    //self.drawSpeed()
    if bpmModeFlag
    {
      self.speedLabel.text = String(floor(self.bpm*10)/10 ) + " BPM"
    }else
    {
      self.speedLabel.text = String( floor(self.tmpspeed*10)/10 ) + "秒毎"
    }
    self.speedLabel.sizeToFit()
  }
  func flagReset(){
    self.setupflag = true
    self.flag = true
  }
  
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
    if(selectLayer != nil && selectLayer != self.view.layer){
      if self.hiddenFlag {
      }else{
        selectLayer.borderWidth = 3.0
        selectLayer.borderColor = UIColor.green.cgColor
        self.shortVibrate()
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
    
    if (selectLayer != nil && selectLayer != self.view.layer){
      //hitしたレイヤーがあった場合
      //  let px:CGFloat = selectLayer.position.x
      //  let py:CGFloat = selectLayer.position.y
      //レイヤーを移動させる
      //  CATransaction.begin()
      CATransaction.setDisableActions(true)
      if self.hiddenFlag {
        
      }else{
      // selectLayer.position = CGPoint(x:px + touchOffsetPoint.x,y:py + touchOffsetPoint.y)
      selectLayer.borderWidth = 3.0
      selectLayer.borderColor = UIColor.green.cgColor
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
  func map(x:Float , in_min:Float , in_max:Float,out_min:Float,out_max:Float )-> Float{
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
  }

 // ************ vibrate ********************
  func shortVibrate() {
    AudioServicesPlaySystemSound(1003);
    AudioServicesDisposeSystemSoundID(1003);
  }
  //********* Data*****
  func receiveData(){
    if let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    {
      self.user = appDelegate.user
    }

  }
  func setSendData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.user = self.user
  }
}

