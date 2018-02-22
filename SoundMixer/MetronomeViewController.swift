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

class MetronomeViewController: UIViewController  , UIGestureRecognizerDelegate{

  var timer: Timer!
  var leftoval: CALayer!
  var rightoval: CALayer!
  var flag:Bool = true
  var setupflag:Bool = true
  var tmpspeed:Float = 3.0
  var tmpmax:Float = 5.05
  var tmpmin:Float = 0.15
  var speedLabel:UILabel!
  var slider:UISlider!
  
  private var selectLayer:CALayer!
  private var touchLastPoint:CGPoint!
  
  private var beginGestureScale:CGFloat!
  private var effectiveScale:CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.drawSetUp()
    // 一定間隔で実行
    self.timer = Timer.scheduledTimer(timeInterval: Double(self.tmpspeed), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    self.timer.fire()
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  //**************:update*******************
  @objc func update(tm: Timer) {
    // do something
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
  @objc func onChange(_ sender: UISlider) {
    // スライダーの値が変更された時の処理
    self.tmpspeed = self.map(x: sender.value, in_min: sender.maximumValue,in_max: sender.minimumValue , out_min: self.tmpmax , out_max: self.tmpmin )
    self.timerReset()
  }
  @objc func updateSliderValue(){
    self.slider.value = self.map(x: self.tmpspeed, in_min: self.tmpmin, in_max: self.tmpmax, out_min: slider.minimumValue, out_max: slider.maximumValue)
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
    if(self.tmpspeed > self.tmpmin){
      self.tmpspeed -= 0.1
      self.timerReset()
      self.updateSliderValue()
    }
  }
  @objc func rectBtnTapped(sender:UIButton){
    //四角を描く 遅くするボタンをタップされたら
    if(self.tmpspeed <= self.tmpmax){
      self.tmpspeed += 0.1
      if(self.tmpspeed > 5.00){
        self.tmpspeed = 5.00
      }
      self.timerReset()
      self.updateSliderValue()
    }
  }
  //************ setup UI PARTS *****************
  //スライダーを表示
  @objc func setupSlider(linewidth: CGPoint) -> UISlider{
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
    slider.value = self.map(x: self.tmpspeed, in_min: self.tmpmin, in_max: self.tmpmax , out_min: slider.minimumValue, out_max: slider.maximumValue)    // スライダーの値が変更された時に呼び出されるメソッドを設定
    slider.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
    return slider
    // スライダーを画面に追加
  }
  //テキストボックスを表示
  @objc func setupText(lineWidth:CGPoint, text:String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont(name: "HiraMinProN-W3", size: 20)
    label.sizeToFit()
    label.center = lineWidth
    return label
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
    let ovalBtn = UIButton()
    ovalBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    ovalBtn.center = CGPoint(x:width / 5,y:height - 100)
    ovalBtn.addTarget(self, action: #selector(MetronomeViewController.ovalBtnTapped(sender:)), for: .touchUpInside)
    ovalBtn.setTitle("速くする",for:.normal)
    ovalBtn.backgroundColor = UIColor.green
    self.view.addSubview(ovalBtn)
    
    //四角を生成するボタン
    let rectBtn = UIButton()
    rectBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    rectBtn.center = CGPoint(x:width * 4 / 5,y:height - 100)
    rectBtn.addTarget(self, action: #selector(MetronomeViewController.rectBtnTapped(sender:)), for: .touchUpInside)
    rectBtn.setTitle("遅くする",for:.normal)
    rectBtn.backgroundColor = UIColor.red
    self.view.addSubview(rectBtn)
    
    drawRects()
    //ピンチ
    let pinch = UIPinchGestureRecognizer()
    pinch.addTarget(self,action:#selector(MetronomeViewController.pinchGesture(sender:)))
    pinch.delegate = self
    self.view.addGestureRecognizer(pinch)
    
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
    self.slider = setupSlider(linewidth: sliderFlame)
    self.view.addSubview(self.slider)
  }
  
  func drawLabel() {
    let flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
    let speedtext = setupText(lineWidth: flame, text:String( floor(self.tmpspeed*10)/10 ) + "秒毎に□が移動します")
    self.speedLabel = speedtext
    self.view.addSubview(self.speedLabel)
  }

  //**********clear***************
  func reset(){
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:self.view.bounds.height)
    rect.clearAll(lineWidth:1)
    self.view.layer.addSublayer(rect)
  }
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
  func timerReset(){
    self.flagReset()
    // self.reset()
    // self.drawSetUp()
    self.clearBorders()
    self.timer.invalidate()
    self.timer = Timer.scheduledTimer(timeInterval: Double(self.tmpspeed), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    self.timer.fire()
    //self.drawSpeed()
    self.speedLabel.text = String( floor(self.tmpspeed*10)/10 ) + "秒毎に□が移動します"
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
    if(selectLayer != nil){
      selectLayer.borderWidth = 3.0
      selectLayer.borderColor = UIColor.green.cgColor
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
    
    if (selectLayer != nil){
      //hitしたレイヤーがあった場合
      //  let px:CGFloat = selectLayer.position.x
      //  let py:CGFloat = selectLayer.position.y
      //レイヤーを移動させる
      //  CATransaction.begin()
      CATransaction.setDisableActions(true)
      // selectLayer.position = CGPoint(x:px + touchOffsetPoint.x,y:py + touchOffsetPoint.y)
      selectLayer.borderWidth = 3.0
      selectLayer.borderColor = UIColor.green.cgColor
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
  func map(x:Float , in_min:Float , in_max:Float,out_min:Float,out_max:Float )-> Float{
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
  }
  
}

