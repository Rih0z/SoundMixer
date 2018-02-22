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


  private var selectLayer:CALayer!
  private var touchLastPoint:CGPoint!
  
  private var beginGestureScale:CGFloat!
  private var effectiveScale:CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
    self.drawSetUp()
    
    
    // 一定間隔で実行
   // Timer.scheduledTimer(timeInterval: 1.0, target: self, selecter: #selector(self.updateDateLabel), userInfo: nil, repeats: true)
    self.timer = Timer.scheduledTimer(timeInterval: Double(self.tmpspeed), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    self.timer.fire()
    
  }
  func drawSetUp(){
    if(self.setupflag){
      self.flag = true
      self.setupflag = false
    }
    effectiveScale = 1.0
    self.drawTimer()
    
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    
    //丸を生成するボタン
    let ovalBtn = UIButton()
    ovalBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    ovalBtn.center = CGPoint(x:width / 3,y:height - 100)
    ovalBtn.addTarget(self, action: #selector(MetronomeViewController.ovalBtnTapped(sender:)), for: .touchUpInside)
    ovalBtn.setTitle("速くする",for:.normal)
    ovalBtn.backgroundColor = UIColor.green
    self.view.addSubview(ovalBtn)
    
    //四角を生成するボタン
    let rectBtn = UIButton()
    rectBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    rectBtn.center = CGPoint(x:width * 2 / 3,y:height - 100)
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
  func timerReset(){
    self.setupflag = true
   // self.reset()
   // self.drawSetUp()
    self.borderClear()
    self.timer.invalidate()
    self.timer = Timer.scheduledTimer(timeInterval: Double(self.tmpspeed), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    self.timer.fire()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @objc func update(tm: Timer) {
    // do something
    //self.clearRects()
    //self.drawRects()
    //self.drawSetUp()
    if self.flag {
    self.blueBorder(layer: self.leftoval)
      self.whiteBorder(layer: self.rightoval)
      self.flag = false
    }else {
      self.blueBorder(layer: self.rightoval)
      self.whiteBorder(layer: self.leftoval)
      self.flag = true
    }
  }
  @objc func borderClear(){
    self.whiteBorder(layer: self.rightoval)
    self.whiteBorder(layer: self.leftoval)
  }
  @objc func drawRects(){
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    //初期の左側ボタン
    let oval = MyShapeLayer()
    oval.frame = CGRect(x:30,y:height/2,width:80,height:80)
    oval.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval)
    self.leftoval = oval
    //初期の右側ボタン
    let oval2 = MyShapeLayer()
    oval2.frame = CGRect(x:width - 30 - 80,y:height/2,width:80,height:80)
    oval2.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval2)
    self.rightoval = oval2
    
  }
  @objc func onChange(_ sender: UISlider) {
    // スライダーの値が変更された時の処理
//    print(sender.value)
 //   slider.value = self.map(x: self.tmpspeed, in_min: self.tmpmin, in_max: self.tmpmax , out_min: slider.minimumValue, out_max: slider.maximumValue)    // スライダーの値が変更された時に呼び出されるメソッドを設定
    self.tmpspeed = self.map(x: sender.value, in_min: sender.maximumValue,in_max: sender.minimumValue , out_min: self.tmpmax , out_max: self.tmpmin )
    self.timerReset()
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
    //丸を描く  速くするボタンをタップされたら
    /*let oval = MyShapeLayer()
    oval.frame = CGRect(x:30,y:30,width:80,height:80)
    oval.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval)
     */
    if(self.tmpspeed > self.tmpmin){
      self.tmpspeed -= 0.1

      self.timerReset()
    }
  }
  @objc func rectBtnTapped(sender:UIButton){
    //四角を描く 遅くするボタンをタップされたら
    /*
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:40,y:40,width:50,height:50)
    rect.drawRect(lineWidth:1)
    self.view.layer.addSublayer(rect)
    */
    if(self.tmpspeed <= self.tmpmax){
      self.tmpspeed += 0.1
      self.timerReset()
      
    }
    
  }
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
  func drawTimer(){
    let flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
    var speed = self.map(x:self.tmpspeed,in_min:self.tmpmax,in_max:self.tmpmin,out_min:self.tmpmin,out_max:self.tmpmax)
    if(speed > 5.0){
      speed = 5.0
    }
    drawText(lineWidth: flame, text: "SPEED : " + String( floor(self.tmpspeed*10)/10 ))
    let sliderFlame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height - (self.view.bounds.height/5))
    drawSlider(linewidth: sliderFlame)
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
  //スライダーを表示
  @objc func drawSlider(linewidth: CGPoint){
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
    // スライダーを画面に追加
    self.view.addSubview(slider)
  }
  //テキストボックスを表示
  @objc func drawText(lineWidth:CGPoint, text:String){
    let label = UILabel()
    label.text = text
    label.font = UIFont(name: "HiraMinProN-W3", size: 20)
    label.sizeToFit()
    label.center = lineWidth
    
    self.view.addSubview(label)
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
