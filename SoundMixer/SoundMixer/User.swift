//
//  User.swift
//  SoundMixer
//
//  Created by 利穂 虹希 on 2018/02/13.
//  Copyright © 2018年 EdTechTokushima. All rights reserved.
//

import Foundation
import MediaPlayer
class User {
  var Name:String!
  var Id:Int!
  //再生している曲の情報が入る
  var Playing_1:MPMediaItem?
  var Playing_2:MPMediaItem?
  var Playing_3:MPMediaItem?
  //チェックボックスのフラグ
  var musicEditFlag:[Bool] = [false,false,false]
  //どの曲を選択しているのか
  var SelectionFlag:Int = 0
  //音楽のみ読み込むフラグ
  var loadMusicFlag:Bool = false
  //テンプレート読み込み前にどの画面にいたか
  var beforeTmp:Int!
  //前にデータの受け渡しがあったビューがどこか教えてくれます．デバッグようなのでなくても大丈夫
  var BeforeView:String?
  //このフラグが立っていたらメトロノーム画面に遷移します絵d
  var homeflag:Bool = false
  var playerflag:Bool = false
  var musicSetFlag:Bool = false
  
  var editflag:Bool = false
  
  var itemUpdateFlag:Bool = false
  
  var template_name = [String]()
  
  var Playing_1_MPMedia = [MPMediaItem?]()
  var Playing_2_MPMedia = [MPMediaItem?]()
  var Playing_3_MPMedia = [MPMediaItem?]()
  
  var Playing_1_pitch = [Float]()
  var Playing_2_pitch = [Float]()
  var Playing_3_pitch = [Float]()
  
  var Playing_1_volume = [Float]()
  var Playing_2_volume = [Float]()
  var Playing_3_volume = [Float]()
  
  var Playing_1_position = [Double]()
  var Playing_2_position = [Double]()
  var Playing_3_position = [Double]()
  
  func setSetting(temp_name: String, MPMedia1: MPMediaItem?, MPMedia2: MPMediaItem?, MPMedia3: MPMediaItem?, pitch1: Float, pitch2: Float, pitch3: Float, volume1: Float, volume2: Float, volume3: Float, position1: Double, position2: Double, position3: Double) {
    self.template_name.append(temp_name)
    if MPMedia1 != nil {
      self.Playing_1_MPMedia.append(MPMedia1!)
    }
    else {
      self.Playing_1_MPMedia.append(nil)
    }
    if MPMedia2 != nil {
      self.Playing_2_MPMedia.append(MPMedia2!)
    }
    else {
      self.Playing_2_MPMedia.append(nil)
    }
    if MPMedia3 != nil {
      self.Playing_3_MPMedia.append(MPMedia3!)
    }
    else {
      self.Playing_3_MPMedia.append(nil)
    }
    
    self.Playing_1_pitch.append(pitch1)
    self.Playing_2_pitch.append(pitch2)
    self.Playing_3_pitch.append(pitch3)
    
    self.Playing_1_volume.append(volume1)
    self.Playing_2_volume.append(volume2)
    self.Playing_3_volume.append(volume3)
    
    self.Playing_1_position.append(position1)
    self.Playing_2_position.append(position2)
    self.Playing_3_position.append(position3)
  }
  
  func removeSetAtIndex(_ index: Int) {
    self.template_name.remove(at: index)
    
    self.Playing_1_MPMedia.remove(at: index)
    self.Playing_2_MPMedia.remove(at: index)
    self.Playing_3_MPMedia.remove(at: index)
    
    self.Playing_1_pitch.remove(at: index)
    self.Playing_2_pitch.remove(at: index)
    self.Playing_3_pitch.remove(at: index)
    
    self.Playing_1_volume.remove(at: index)
    self.Playing_2_volume.remove(at: index)
    self.Playing_3_volume.remove(at: index)
    
    self.Playing_1_position.remove(at: index)
    self.Playing_2_position.remove(at: index)
    self.Playing_3_position.remove(at: index)
  }
}
