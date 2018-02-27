//
//  setupParts.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/26.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import Foundation
import UIKit

class setupParts : CALayer {
  //テキストボックスを表示
  @objc func setupText(lineWidth:CGPoint, text:String,size:CGRect, fontSize : CGFloat) -> UILabel {
    let label = UILabel(frame: size)
    label.text = text
    label.font = UIFont(name: "HiraMinProN-W3", size: fontSize)
    label.sizeToFit()
    label.center = lineWidth
    return label
  }
  @objc func setupButton(rect: CGRect,lineWidth:CGPoint , text:String , color:UIColor ) -> UIButton {
    //非表示ボタン
    let Btn = UIButton()
    Btn.frame = rect
    Btn.center = lineWidth
    Btn.setTitle(text,for:.normal)
    Btn.backgroundColor = color
    return Btn
  }
  
  @objc func setupSwitch(linewidth : CGPoint , color:UIColor,switchco:Bool ) -> UISwitch{
    // Swicthを作成する.
    let mySwicth: UISwitch = UISwitch()
   mySwicth.layer.position = linewidth
    // Swicthの枠線を表示する.
    mySwicth.tintColor = color
    // SwitchをOnに設定する.
    mySwicth.isOn = switchco
    // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
    //mySwicth.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.valueChanged)
    // SwitchをViewに追加する.
    return mySwicth
  }
  
}
