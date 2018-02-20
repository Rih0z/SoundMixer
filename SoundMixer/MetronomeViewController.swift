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
 // let dateLabel = UILabel()  // 日時表示ラベル
  var timer: Timer!
  var leftoval: CALayer!
  var rightoval: CALayer!
  var flag = 0
  // 日時フォーマット
  var dateFormatter: DateFormatter{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return formatter
  }

  private var selectLayer:CALayer!
  private var touchLastPoint:CGPoint!
  
  private var beginGestureScale:CGFloat!
  private var effectiveScale:CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    /*
     dateLabel.frame = view.bounds
     dateLabel.textAlignment = .center
     view.addSubview(dateLabel)
    */
    effectiveScale = 1.0
    
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    /*
    //丸を生成するボタン
    let ovalBtn = UIButton()
    ovalBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    ovalBtn.center = CGPoint(x:width / 3,y:height - 100)
    ovalBtn.addTarget(self, action: #selector(MetronomeViewController.ovalBtnTapped(sender:)), for: .touchUpInside)
    ovalBtn.setTitle("丸",for:.normal)
    ovalBtn.backgroundColor = UIColor.green
    self.view.addSubview(ovalBtn)
    
    //四角を生成するボタン
    let rectBtn = UIButton()
    rectBtn.frame = CGRect(x:0,y:0,width:100,height:50)
    rectBtn.center = CGPoint(x:width * 2 / 3,y:height - 100)
    rectBtn.addTarget(self, action: #selector(MetronomeViewController.rectBtnTapped(sender:)), for: .touchUpInside)
    rectBtn.setTitle("四角",for:.normal)
    rectBtn.backgroundColor = UIColor.red
    self.view.addSubview(rectBtn)
    */
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
    
    //ピンチ
    let pinch = UIPinchGestureRecognizer()
    pinch.addTarget(self,action:#selector(MetronomeViewController.pinchGesture(sender:)))
    pinch.delegate = self
    self.view.addGestureRecognizer(pinch)

    // 初回
    //updateDateLabel()
    
    // 一定間隔で実行
   // Timer.scheduledTimer(timeInterval: 1.0, target: self, selecter: #selector(self.updateDateLabel), userInfo: nil, repeats: true)
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    timer.fire()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @objc func update(tm: Timer) {
    // do something
    
    if self.flag == 0 {
    self.blueBorder(layer: self.leftoval)
      self.flag = 1
    }else {
      self.blueBorder(layer: self.rightoval)
      self.flag = 0
    }
    
  }
  /* 日時表示ラベル更新メソッド
  @objc func updateDateLabel(){
    let now = Date()
    dateLabel.text = dateFormatter.string(from:now)
  }*/
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
    //丸を描く
    let oval = MyShapeLayer()
    oval.frame = CGRect(x:30,y:30,width:80,height:80)
    oval.drawOval(lineWidth:1)
    self.view.layer.addSublayer(oval)
  }
  @objc func rectBtnTapped(sender:UIButton){
    //四角を描く
    let rect = MyShapeLayer()
    rect.frame = CGRect(x:40,y:40,width:50,height:50)
    rect.drawRect(lineWidth:1)
    self.view.layer.addSublayer(rect)
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


}
