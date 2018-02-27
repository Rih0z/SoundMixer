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
  //前にデータの受け渡しがあったビューがどこか教えてくれます．デバッグようなのでなくても大丈夫
  var BeforeView:String?
  //このフラグが立っていたらメトロノーム画面に遷移します絵d
  var homeflag:Bool = false
  var musicSetFlag:Bool = false
}
