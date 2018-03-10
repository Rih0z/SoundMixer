//
//  MyShapeLayer.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/18.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//
//  The base of this program is http://uruly.xyz/%E3%80%90swift-3%E3%80%91calayer%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6%E5%9B%B3%E5%BD%A2%E3%82%92%E7%A7%BB%E5%8B%95%E3%83%BB%E6%8B%A1%E5%A4%A7%E7%B8%AE%E5%B0%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/
//  by Reo
import UIKit

class MyShapeLayer: CALayer {

  @objc func drawRect(lineWidth:CGFloat){
    let rect = CAShapeLayer()
    rect.strokeColor = UIColor.black.cgColor
    rect.fillColor = UIColor.clear.cgColor
    rect.lineWidth = lineWidth
    rect.path = UIBezierPath(rect:CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)).cgPath
    self.addSublayer(rect)
  }
  
  @objc func drawOval(lineWidth:CGFloat){
    let ovalShapeLayer = CAShapeLayer()
    ovalShapeLayer.strokeColor = UIColor.blue.cgColor
    ovalShapeLayer.fillColor = UIColor.clear.cgColor
    ovalShapeLayer.lineWidth = lineWidth
    ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:self.frame.width, height: self.frame.height)).cgPath
    self.addSublayer(ovalShapeLayer)
  }
  @objc func drawSideOval(lineWidth:CGFloat){
    let ovalShapeLayer = CAShapeLayer()
    ovalShapeLayer.strokeColor = UIColor.blue.cgColor
    ovalShapeLayer.fillColor = UIColor.clear.cgColor
    ovalShapeLayer.borderColor = UIColor.clear.cgColor
    ovalShapeLayer.lineWidth = lineWidth
    ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:self.frame.width, height: self.frame.height)).cgPath
    self.addSublayer(ovalShapeLayer)
  }
  @objc func clearAll(lineWidth:CGFloat){
    let rect = CAShapeLayer()
    rect.strokeColor = UIColor.white.cgColor
    rect.fillColor = UIColor.white.cgColor
    rect.lineWidth = lineWidth
    rect.path = UIBezierPath(rect:CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)).cgPath
    self.addSublayer(rect)
  }

  
}
