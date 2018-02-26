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
  
}
