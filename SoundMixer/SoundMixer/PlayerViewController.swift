
import UIKit
import MediaPlayer
import AVFoundation

class PlayerViewController: UIViewController, MPMediaPickerControllerDelegate {
    /*********** 変数 いつか配列にしたい**********************/
    var audioPlayer:AVAudioPlayer?
    var PlayingSong:MPMediaItem!
    var PlayingSong2:MPMediaItem!
    var PlayingSong3:MPMediaItem!
    // player = AudioEnginePlayer.sharedInstance
    //var player = AudioEnginePlayer()
    //var player2 = AudioEnginePlayer()
    //var player3 = AudioEnginePlayer()
    
    var isPlaying1 = false
    var isPlaying2 = false
    var isPlaying3 = false
    
    var user:User = User()
    
    var player1_name:UILabel!
    var player2_name:UILabel!
    var player3_name:UILabel!
    var Player1Pitch:UILabel!
    var Player2Pitch:UILabel!
    var Player3Pitch:UILabel!
    var Player4Pitch:UILabel!
    var Player1Vol:UILabel!
    var Player2Vol:UILabel!
    var Player3Vol:UILabel!
    var Player4Vol:UILabel!
    var Player1Time:UILabel!
    var Player2Time:UILabel!
    var Player3Time:UILabel!
    
    
    private var StartButton1:UIButton! = UIButton()
    private var StartButton2:UIButton! = UIButton()
    private var StartButton3:UIButton! = UIButton()
    private var StartButton4:UIButton! = UIButton()
    private var StartButton5:UIButton! = UIButton()
    private var StartButton6:UIButton! = UIButton()
    private var StartButton7:UIButton! = UIButton()
    
    private var DeleteButton:[UIButton] = [UIButton(),UIButton(),UIButton()]
    
    var player1_pitch_slider:UISlider!
    var player2_pitch_slider:UISlider!
    var player3_pitch_slider:UISlider!
    var player4_pitch_slider:UISlider!
    
    var player1_vol_slider:UISlider!
    var player2_vol_slider:UISlider!
    var player3_vol_slider:UISlider!
    var player4_vol_slider:UISlider!
    
    var player1_pos_slider:UISlider!
    var player2_pos_slider:UISlider!
    var player3_pos_slider:UISlider!
    var player4_pos_slider:UISlider!
    
    var initFlag = false
    var timer: Timer?
    
    var loadFlag:Bool = false
    
    private var initLockFlag:Bool = true
    private var playLockFlag = false
    private var allMusicStopFlag = false
    private var musicLockFlag:[Bool] = [false,false,false,false]
    var rowNum:Int = 0
    private var playMusicNum = 3
    
    /****************** ライフサイクル系 ***************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(initFlag == false){
            self.setupDraw()
            initFlag = true
        }
        self.receiveData()
        self.setupTimer()
        self.loadTemplete()
        self.loadMusic()
        //self.setupDraw()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.user.beforeTmp = 1
        //self.setupAllBtnText()
        self.lockButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupMusicLabel()
        self.setupAllDrawTimeLabel()
        // self.loadTemplete()
        //ここにテンプレートから更新した値を代入
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.user.BeforeView = "player"
        
        self.setSendData()
        // self.allPause()
        print("player sendData finished")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*********** 初期化系 **************/
    
    func setupTimer(){
        if(self.timer == nil){
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlayerViewController.timerUpdate), userInfo: nil, repeats: true)
            print("タイマーを開始しました")
        }
    }
    func setupDraw(){
        self.StartButton1 = self.DrawStartButton(id:1)
        self.view.addSubview(self.StartButton1)
        
        self.StartButton2 = self.DrawStartButton(id:2)
        self.view.addSubview(self.StartButton2)
        
        self.StartButton3 = self.DrawStartButton(id:3)
        self.view.addSubview(self.StartButton3)
        
        self.StartButton4 = self.DrawStartButton(id:4)
        self.view.addSubview(self.StartButton4)
        
        self.StartButton5 = self.DrawStartButton(id:5)
        self.view.addSubview(self.StartButton5)
        
        self.StartButton6 = self.DrawStartButton(id: 6)
        self.view.addSubview(self.StartButton6)
        
        self.StartButton7 = self.DrawStartButton(id: 7)
        self.view.addSubview(self.StartButton7)
        
        for i in 8...10 {
            self.DeleteButton[i - 8] = self.DrawStartButton(id: i)
            self.view.addSubview(self.DeleteButton[i - 8])
        }
        
        self.player1_pitch_slider = self.drawPitchSlider(id:1)
        self.view.addSubview(self.player1_pitch_slider)
        self.player2_pitch_slider = self.drawPitchSlider(id:2)
        self.view.addSubview(self.player2_pitch_slider)
        self.player3_pitch_slider = self.drawPitchSlider(id:3)
        self.view.addSubview(self.player3_pitch_slider)
        self.player4_pitch_slider = self.drawPitchSlider(id:4)
        self.view.addSubview(self.player4_pitch_slider)
        
        self.player1_vol_slider = self.drawVolSlider(id:1)
        self.view.addSubview(self.player1_vol_slider)
        self.player2_vol_slider = self.drawVolSlider(id:2)
        self.view.addSubview(self.player2_vol_slider)
        self.player3_vol_slider = self.drawVolSlider(id:3)
        self.view.addSubview(self.player3_vol_slider)
        self.player4_vol_slider = self.drawVolSlider(id:4)
        self.view.addSubview(self.player4_vol_slider)
        
        self.player1_pos_slider = self.drawPosSlider(id:1)
        self.view.addSubview(self.player1_pos_slider)
        self.player2_pos_slider = self.drawPosSlider(id:2)
        self.view.addSubview(self.player2_pos_slider)
        self.player3_pos_slider = self.drawPosSlider(id:3)
        self.view.addSubview(self.player3_pos_slider)
        
        self.Player1Pitch = self.drawPitchLabel(id:1)
        self.view.addSubview(self.Player1Pitch)
        self.Player2Pitch = self.drawPitchLabel(id:2)
        self.view.addSubview(self.Player2Pitch)
        self.Player3Pitch = self.drawPitchLabel(id:3)
        self.view.addSubview(self.Player3Pitch)
        self.Player4Pitch = self.drawPitchLabel(id:4)
        self.view.addSubview(self.Player4Pitch)
        
        
        self.Player1Vol = self.drawVolLabel(id:1)
        self.view.addSubview(self.Player1Vol)
        self.Player2Vol = self.drawVolLabel(id:2)
        self.view.addSubview(self.Player2Vol)
        self.Player3Vol = self.drawVolLabel(id:3)
        self.view.addSubview(self.Player3Vol)
        self.Player4Vol = self.drawVolLabel(id:4)
        self.view.addSubview(self.Player4Vol)
        
        self.Player1Time = self.drawTimeLabel(id: 1)
        self.view.addSubview(self.Player1Time)
        self.Player2Time = self.drawTimeLabel(id: 2)
        self.view.addSubview(self.Player2Time)
        self.Player3Time = self.drawTimeLabel(id: 3)
        self.view.addSubview(self.Player3Time)
        
    }
    /********************* ラベル系 *********************/
    //テキストボックスを表示
    @objc func setupText(lineWidth:CGPoint, text:String,size:CGRect) -> UILabel {
        let label = UILabel(frame: size)
        label.text = text
        label.font = UIFont(name: "HiraMinProN-W3", size: 20)
        label.sizeToFit()
        label.center = lineWidth
        return label
    }
    
    // 曲名ラベル描画
    func drawLabel(id:Int) -> UILabel{
        var flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/3)
        var title = "選択されていません"
        
        // 曲名１
        if(id == 1){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 0.7)
            if(self.user.Playing_1 != nil){
                title = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
            // 曲名２
        else if(id == 2){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 2.7)
            if(self.user.Playing_2 != nil){
                title = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
            // 曲名３
        else if(id == 3){
            flame = CGPoint(x:self.view.bounds.width/2 , y:self.view.bounds.height/8 * 4.7)
            if(self.user.Playing_3 != nil){
                title = self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            }
        }
        var MusicTitle:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        MusicTitle = setupText(lineWidth: flame, text:title,size: rect)
        MusicTitle.sizeToFit()
        
        if(self.user.musicEditFlag[id - 1] == true){
            MusicTitle.backgroundColor = UIColor.gray // 白
        }
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return MusicTitle
    }
    
    // ピッチラベル描画
    func drawPitchLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        var flame:CGPoint
        let title = "ピッチ"
        
        flame = CGPoint(x:self.view.bounds.width/14 , y:pos_y[id - 1])
        
        var Pitch:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Pitch = setupText(lineWidth: flame, text:title,size: rect)
        Pitch.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Pitch.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return Pitch
    }
    
    // 音量ラベル描画
    func drawVolLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        var flame:CGPoint
        let title = "音量"
        
        flame = CGPoint(x:self.view.bounds.width*8/14 , y:pos_y[id - 1])
        
        var Vol:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Vol = setupText(lineWidth: flame, text:title,size: rect)
        Vol.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Vol.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        
        return Vol
    }
    
    // 再生時間表示ラベル描画
    func drawTimeLabel(id:Int) -> UILabel{
        
        //let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 2.0 / 8 , height * 4.0 / 8 , height * 6.0 / 8]
        
        var flame:CGPoint
        var min = 0
        var sec = 0
        
        if(id == 1){
            min = Int((player.pos + 0.49) / 60.0)
            sec = Int(Int(player.pos + 0.49) % 60)
        }
        else if(id == 2){
            min = Int((player2.pos + 0.49) / 60.0)
            sec = Int(Int(player2.pos + 0.49) % 60)
        }
        else if(id == 3){
            min = Int((player3.pos + 0.49) / 60.0)
            sec = Int(Int(player3.pos + 0.49) % 60)
        }
        
        let title = String(format:"%02d:%02d",min, sec)
        
        flame = CGPoint(x:self.view.bounds.width*8/14 , y:pos_y[id - 1])
        
        var Time:UILabel!
        let rect = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        
        Time = setupText(lineWidth: flame, text:title,size: rect)
        Time.font = UIFont(name: "HiraMinProN-W3", size: 20)
        Time.sizeToFit()
        
        //print(PlayingSong.value(forProperty: MPMediaItemPropertyTitle)! as! UnsafePointer<Int8>)
        return Time
    }
    func setupDrawTimeLabel(id:Int){
        var min = 0
        var sec = 0
        if(id == 1){
            min = Int((player.pos + 0.49) / 60.0)
            sec = Int(Int(player.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player1Time.text = title
            Player1Time.sizeToFit()
        }
        else if(id == 2){
            min = Int((player2.pos + 0.49) / 60.0)
            sec = Int(Int(player2.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player2Time.text = title
            Player2Time.sizeToFit()
        }
        else if(id == 3){
            min = Int((player3.pos + 0.49) / 60.0)
            sec = Int(Int(player3.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player3Time.text = title
            Player3Time.sizeToFit()
        }
        
    }
    
    // 再生位置が0になるのを編集しました
    func resetDrawTimeLabel(id:Int){
        
        var min = 0
        var sec = 0
        /*
        min = Int((0 + 0.49) / 60.0)
        sec = Int(Int(0 + 0.49) % 60)
        let title = String(format:"%02d:%02d",min, sec)
        */
        if(id == 1){
            min = Int((player.pos + 0.49) / 60.0)
            sec = Int(Int(player.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player1Time.text = title
            Player1Time.sizeToFit()
        }
        else if(id == 2){
            min = Int((player2.pos + 0.49) / 60.0)
            sec = Int(Int(player2.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player2Time.text = title
            Player2Time.sizeToFit()
        }
        else if(id == 3){
            min = Int((player3.pos + 0.49) / 60.0)
            sec = Int(Int(player3.pos + 0.49) % 60)
            let title = String(format:"%02d:%02d",min, sec)
            Player3Time.text = title
            Player3Time.sizeToFit()
        }
        
    }
    func setupAllDrawTimeLabel(){
        for i in 1...3{
            setupDrawTimeLabel(id: i)
        }
    }
    func resetAllDrawTimeLabel(){
        for i in 1...3{
            resetDrawTimeLabel(id: i)
        }
    }
    func setupMusicLabel(){
        if self.player1_name == nil {
            self.player1_name = self.drawLabel(id:1)
            self.view.addSubview(self.player1_name)
        }else{
            if self.user.Playing_1 != nil {
                self.player1_name.text = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle) as! String!
                self.player1_name.sizeToFit()
            }else{
                self.player1_name.text = "選択されていません"
                self.player1_name.sizeToFit()
            }
            
        }
        if self.player2_name == nil {
            self.player2_name = self.drawLabel(id:2)
            self.view.addSubview(self.player2_name)
        }else{
            if self.user.Playing_2 != nil {
                self.player2_name.text = self.user.Playing_2?.value(forProperty: MPMediaItemPropertyTitle) as! String!
                self.player2_name.sizeToFit()
            }else{
                self.player2_name.text = "選択されていません"
                self.player2_name.sizeToFit()
                
            }
            
        }
        if self.player3_name == nil {
            self.player3_name = self.drawLabel(id:3)
            self.view.addSubview(self.player3_name)
        }else{
            if self.user.Playing_3 != nil{
                self.player3_name.text = self.user.Playing_3?.value(forProperty: MPMediaItemPropertyTitle) as! String!
                self.player3_name.sizeToFit()
            }else{
                self.player3_name.text = "選択されていません"
                self.player3_name.sizeToFit()
                
            }
            
        }
    }
    /************** ボタン系 **********************/
    /*********** 描画　***************/
    // 曲再生ボタン
    func DrawStartButton(id:Int) -> UIButton{
        
        var text: String = ""
        var frame: CGPoint = CGPoint(x: 0,y: 0)
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let pos_y = [height * 2 / 8 , height * 4 / 8 , height * 6 / 8 ,  height * 13 / 14]
        
        let rect = CGRect(x:0,y:0,width:100,height:50)
        let btn = UIButton(frame: rect)
        
        if(id >= 1 && id <= 4) {
            
            switch id{
            case 1:
                text = "音楽1再生"
                if player.playing{
                    text = "音楽1停止"
                }
            case 2:
                text = "音楽2再生"
                if player2.playing{
                    text = "音楽2停止"
                }
            case 3:
                text = "音楽3再生"
                if player3.playing{
                    text = "音楽3停止"
                }
            case 4:
                text = "全曲再生"
            default:
                text = "再生"
            }
            
            // text = "準備中"
            btn.backgroundColor = UIColor.blue
            frame = CGPoint(x:width * 1 / 7,y:pos_y[id - 1])
        }
        else if(id == 5) {
            text = "登録"
            frame = CGPoint(x:width * 5 / 7,y:pos_y[3])
            btn.backgroundColor = UIColor.blue
        }
        else if(id == 6) {
            text = "完了"
            frame = CGPoint(x:width * 6 / 7,y:pos_y[3])
            btn.backgroundColor = UIColor.blue
        }
        else if(id == 7){
            text = "全曲停止"
            frame = CGPoint(x:width * 2 / 7,y:pos_y[4 - 1])
            btn.backgroundColor = UIColor.blue
        }else{
            text = "削除"
            btn.backgroundColor = UIColor.darkGray
            frame = CGPoint(x:width * 6 / 7,y:pos_y[id - 8])
        }
        
        btn.center = frame
        switch id {
        case 8:
            print("id 8")
            btn.addTarget(self, action: #selector(PlayerViewController.DeleteBtn8Tapped(sender:)), for: .touchUpInside)
        case 9:
            print("id 9")
            btn.addTarget(self, action: #selector(PlayerViewController.DeleteBtn9Tapped(sender:)), for: .touchUpInside)
        case 10:
            print("id 10")
            btn.addTarget(self, action: #selector(PlayerViewController.DeleteBtn10Tapped(sender:)), for: .touchUpInside)
        default:
            
            if(id == 1){
                btn.addTarget(self, action: #selector(PlayerViewController.StartBtn1Tapped(sender:)), for: .touchUpInside)
                if(player.playing == true){
                    text = "音楽1停止"
                }
            }
            if(id == 2){
                btn.addTarget(self, action: #selector(PlayerViewController.StartBtn2Tapped(sender:)), for: .touchUpInside)
                if(player2.playing == true){
                    text = "音楽2停止"
                }
            }
            if(id == 3){
                btn.addTarget(self, action: #selector(PlayerViewController.StartBtn3Tapped(sender:)), for: .touchUpInside)
                if(player3.playing == true){
                    text = "音楽3停止"
                }
            }
            if(id == 4){
                //  btn.addTarget(self, action: #selector(PlayerViewController.StartBtn4Tapped(sender:)), for: .touchUpInside)
                btn.addTarget(self, action: #selector(PlayerViewController.allStartTapped(sender:)), for: .touchUpInside)
            }
            if(id == 5){
                btn.addTarget(self, action: #selector(PlayerViewController.StartBtn5Tapped(sender:)), for: .touchUpInside)
            }
            if(id == 6){
                btn.addTarget(self, action: #selector(PlayerViewController.StartBtn6Tapped(sender:)), for: .touchUpInside)
            }
            if(id == 7){
                btn.addTarget(self, action: #selector(PlayerViewController.allStopTapped(sender:)), for: .touchUpInside)
            }
        }
        btn.setTitle(text,for:.normal)
        
        
        return btn
    }
    /************ ボタンテキスト編集******************/
    
    func setupAllBtnText(){
        for i in 1...3 {
            self.setupBtnText(id:i)
        }
    }
    func setupBtnText(id:Int){
        if self.user.playerflag || self.allMusicStopFlag || player.playing || player2.playing || player3.playing {
            
        } else {
            var text = "再生"
            switch id{
            case 1:
                text = "音楽1再生"
                if player.playing{
                    text = "音楽1停止"
                }
                self.StartButton1.setTitle(text,for:.normal)
            case 2:
                text = "音楽2再生"
                if player2.playing{
                    text = "音楽2停止"
                }
                self.StartButton2.setTitle(text,for:.normal)
            case 3:
                text = "音楽3再生"
                if player3.playing{
                    text = "音楽3停止"
                }
                self.StartButton3.setTitle(text,for:.normal)
            default:
                text = "再生"
            }
        }
    }
    /**************** ボタンロック　*****************/
    func feedOutText(id:Int){
        
        //  self.user.playerflag = false
        self.musicLockFlag[id] = true
        self.textChangePrepare(id:id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
            self.textChangePlay(id: id)
            self.musicLockFlag[id] = false
        }
        
    }
    
    func textChangePlay(id:Int){
        
        switch id {
        case 1:
            if player.playing == false {
                let text = "音楽1再生"
                self.StartButton1.setTitle(text,for:.normal)
                self.StartButton1.backgroundColor? = (UIColor.blue)
            } else {
                let text = "音楽1停止"
                self.StartButton1.setTitle(text,for:.normal)
                self.StartButton1.backgroundColor? = (UIColor.blue)
                
            }
        case 2:
            if player2.playing == false {
                let text = "音楽2再生"
                self.StartButton2.setTitle(text,for:.normal)
                self.StartButton2.backgroundColor? = (UIColor.blue)
            } else {
                let text = "音楽2停止"
                self.StartButton2.setTitle(text,for:.normal)
                self.StartButton2.backgroundColor? = (UIColor.blue)
                
            }
        case 3:
            if player3.playing ==  false {
                let text = "音楽3再生"
                self.StartButton3.setTitle(text,for:.normal)
                self.StartButton3.backgroundColor? = (UIColor.blue)
            } else {
                let text = "音楽3停止"
                self.StartButton3.setTitle(text,for:.normal)
                self.StartButton3.backgroundColor? = (UIColor.blue)
                
            }
        case 4:
            let text = "全曲再生"
            self.StartButton4.setTitle(text,for:.normal)
            self.StartButton4.backgroundColor? = (UIColor.blue)
        default:
            print("alltextchangeplayerror")
        }
    }
    func textChangePrepare(id:Int){
        //let text = "準備中"
        switch id {
        case 1:
            let text = "準備中"
            self.StartButton1.setTitle(text,for:.normal)
            self.StartButton1.backgroundColor? = (UIColor.red)
        case 2:
            let text = "準備中"
            self.StartButton2.setTitle(text,for:.normal)
            self.StartButton2.backgroundColor? = (UIColor.red)
        case 3:
            let text = "準備中"
            self.StartButton3.setTitle(text,for:.normal)
            self.StartButton3.backgroundColor? = (UIColor.red)
            
        case 4:
            let text = "準備中"
            self.StartButton4.setTitle(text,for:.normal)
            self.StartButton4.backgroundColor? = (UIColor.red)
        default:
            print("alltextchangeplayerror")
        }
    }
    
    func allTextChengePlay(){
        for i in 1...4 {
            self.textChangePlay(id:i)
        }
        print("alltext change play")
    }
    func allTextChangePrepare(){
        for i in 1...4 {
            self.textChangePrepare(id:i)
        }
        
    }
    
    func lockButton(){
        if  self.user.playerflag || self.allMusicStopFlag || player.playing || player2.playing || player3.playing || self.initLockFlag {
            self.initLockFlag = false
            // self.user.playerflag = false
            self.allMusicStopFlag = false
            self.playLockFlag = true
            //タブ切り替えの時はすでにインスタンスが生成されているので一つ見ればわかる
            // if self.StartButton1 != nil{
            self.allTextChangePrepare()
            // }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                //現れてから3秒後にはもうインスタンスが生成されているので
                
                self.playLockFlag = false
                self.allTextChengePlay()
                self.resetAllDrawTimeLabel()
                //self.setupAllBtnText()
                
            }
        }
    }
    
    /************** タップされたとき　***********/
    @objc func StartBtn1Tapped(sender:UIButton){
        if self.playLockFlag || self.musicLockFlag[1] {
        } else {
            self.music1Play()
        }
    }
    func music1Play(){
        if self.user.Playing_1 == nil {
            self.CheckPlaylist(whitchplaylist: 1)
        } else if player.playing == false
        {
            let text = "音楽1停止"
            self.StartButton1.setTitle(text,for:.normal)
            player.play()
            
        }else{
            
            player.pause()
            self.feedOutText(id: 1)
            
        }
    }
    
    @objc func StartBtn2Tapped(sender:UIButton){
        if(self.playLockFlag || self.musicLockFlag[2]){
            
        }else{
            self.music2Play()
        }
    }
    func music2Play(){
        if self.user.Playing_2 == nil {
            self.CheckPlaylist(whitchplaylist: 2)
        }
        if player2.playing == false
        {
            if(self.user.Playing_2 != nil){
                let text = "音楽2停止"
                self.StartButton2.setTitle(text,for:.normal)
                player2.play()
            }
            
        }else{
            if(self.user.Playing_2 != nil){
                player2.pause()
                self.feedOutText(id: 2)
            }
        }
    }
    @objc func StartBtn3Tapped(sender:UIButton){
        if self.playLockFlag || self.musicLockFlag[3] {
            
        }else{
            self.music3Play()
        }
        
    }
    func music3Play(){
        if self.user.Playing_3 == nil {
            self.CheckPlaylist(whitchplaylist: 3)
        }
        if player3.playing == false
        {
            if(self.user.Playing_3 != nil){
                let text = "音楽3停止"
                self.StartButton3.setTitle(text,for:.normal)
                player3.play()
            }
            
        }else{
            if(self.user.Playing_3 != nil){
                player3.pause()
                self.feedOutText(id: 3)
            }
        }
    }
    @objc func StartBtn4Tapped(sender:UIButton){
        if self.playLockFlag {
        } else {
            self.musicAllPlay()
        }
    }
    func musicAllPlay(){
        if (player3.playing == false || player2.playing || false && player.playing == false)
        {
            self.allPause()
        }else{
            self.allStart()
        }
        
    }
    @objc func allStartTapped(sender:UIButton){
        if (player3.playing == false && player2.playing == false && player.playing == false)
        {
            //全部止まってる時だけ再生開始
            // self.allStop()
            self.allStart()
        }else{
            
        }
    }
    @objc func allStopTapped(sender:UIButton){
        if (player3.playing == true || player2.playing == true || player.playing == true)
        {
            self.allMusicStopFlag = true
            self.allPause()
            self.lockButton()
        }else{
            // self.allStart()
        }
    }
    
    func allStart(){
        var text = "全曲停止"
        if(self.user.Playing_1 != nil){
            text = "音楽1停止"
            self.StartButton1.setTitle(text,for:.normal)
            player.play()
        }
        if(self.user.Playing_2 != nil){
            text = "音楽2停止"
            self.StartButton2.setTitle(text,for:.normal)
            player2.play()
        }
        if(self.user.Playing_3 != nil){
            text = "音楽3停止"
            self.StartButton3.setTitle(text,for:.normal)
            player3.play()
        }
        // text = "全曲停止"
        //  self.StartButton4.setTitle(text,for:.normal)
    }
    func allPause(){
        // var text = "音楽1再生"
        if(self.user.Playing_1 != nil){
            //   text = "音楽1再生"
            //   self.StartButton1.setTitle(text,for:.normal)
            player.pause()
        }
        if(self.user.Playing_2 != nil){
            //    text = "音楽2再生"
            //     self.StartButton2.setTitle(text,for:.normal)
            player2.pause()
        }
        if(self.user.Playing_3 != nil){
            //   text = "音楽3再生"
            //    self.StartButton3.setTitle(text,for:.normal)
            player3.pause()
        }
        // text = "全曲再生"
        //    self.StartButton4.setTitle(text,for:.normal)
        
    }
    @objc func  StartBtn5Tapped(sender:UIButton){
      self.showInputAlert()
    }
  func showInputAlert() {
    let alert = UIAlertController(title: "テンプレート名を入力してください", message: "", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "入力完了", style: .default) { (action:UIAlertAction!) -> Void in
      let textField = alert.textFields![0] as UITextField
      var template_name = textField.text!
      if(template_name.isEmpty) {
        self.urgeInputAlert()
      }
      else {
        self.user.setSetting(temp_name: template_name, MPMedia1: self.user.Playing_1, MPMedia2: self.user.Playing_2, MPMedia3: self.user.Playing_3, pitch1: self.player1_pitch_slider.value, pitch2: self.player2_pitch_slider.value, pitch3: self.player3_pitch_slider.value, volume1: self.player1_vol_slider.value, volume2: self.player2_vol_slider.value, volume3: self.player3_vol_slider.value, position1: Double(self.player1_pos_slider.value), position2: Double(self.player2_pos_slider.value), position3: Double(self.player3_pos_slider.value))
        
        self.sendUserInfo()
        
        let MPMedia1 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_1_MPMedia) as NSData?
        let MPMedia2 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_2_MPMedia) as NSData?
        let MPMedia3 = NSKeyedArchiver.archivedData(withRootObject: self.user.Playing_3_MPMedia) as NSData?
        userDefaults.set(["temp_name": self.user.template_name, "MPMedia1": MPMedia1!, "MPMedia2": MPMedia2!, "MPMedia3": MPMedia3!, "pitch1": self.user.Playing_1_pitch, "pitch2": self.user.Playing_2_pitch, "pitch3": self.user.Playing_3_pitch, "volume1": self.user.Playing_1_volume, "volume2": self.user.Playing_2_volume, "volume3": self.user.Playing_3_volume, "position1": self.user.Playing_1_position, "position2": self.user.Playing_2_position, "position3": self.user.Playing_3_position], forKey: String(self.user.Id - 1)+"_"+"Setting")
        print("いけてる，その2")
      }
    }
    let cancelAction = UIAlertAction(title: "取り消し", style: .default) { (action:UIAlertAction!) -> Void in }
    
    // UIAlertControllerにtextFieldを追加
    alert.addTextField { (textField:UITextField!) -> Void in }
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  func urgeInputAlert() {
    let alert = UIAlertController(title: "テンプレート名を入力しないと登録できません", message: "", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "了解", style: .default) { (action:UIAlertAction!) -> Void in
      self.showInputAlert()
    }
    let cancelAction = UIAlertAction(title: "登録せずに終了", style: .default) { (action:UIAlertAction!) -> Void in }
    
    // UIAlertControllerにtextFieldを追加
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
    @objc func  StartBtn6Tapped(sender:UIButton){
        
        self.goHome()
    }
    @objc func  DeleteBtn8Tapped(sender:UIButton){
        
        if self.user.Playing_1 != nil{
            player.stop()
            self.musicLockFlag[1] = true
            self.user.Playing_1 = nil
            self.DeleteButton[0].backgroundColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
                self.DeleteButton[0].backgroundColor = UIColor.darkGray
                self.player1_name.text = "再生ボタンから音楽を選択できます"
                self.player1_name.sizeToFit()
                self.musicLockFlag[1] = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
                    self.resetDrawTimeLabel(id:1)
                }
                
            }
            
            
        }
    }
    @objc func  DeleteBtn9Tapped(sender:UIButton){
        
        self.player1_name.sizeToFit()
        if self.user.Playing_2 != nil{
            player2.stop()
            self.user.Playing_2 = nil
            self.musicLockFlag[2] = true
            self.DeleteButton[1].backgroundColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
                self.DeleteButton[1].backgroundColor = UIColor.darkGray
                self.player2_name.text = "再生ボタンから音楽を選択できます"
                self.player2_name.sizeToFit()
                self.musicLockFlag[2] = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
                    self.resetDrawTimeLabel(id:2)
                }
            }
        }
    }
    @objc func  DeleteBtn10Tapped(sender:UIButton){
        if self.user.Playing_3 != nil{
            player3.stop()
            self.user.Playing_3 = nil
            self.musicLockFlag[3] = true
            self.DeleteButton[2].backgroundColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
                self.player3_name.text = "再生ボタンから音楽を選択できます"
                self.DeleteButton[2].backgroundColor = UIColor.darkGray
                self.player3_name.sizeToFit()
                self.musicLockFlag[3] = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
                    self.resetDrawTimeLabel(id:3)
                }
                
            }
            
        }
    }
    
    /************ 画面遷移系 ********************/
    func goHome(){
        self.user.homeflag = true
        self.goNextPage(page: "MainTabBar")
        if self.user.Playing_1 != nil{
            player.stop()
            player.pos = 0.0
        }
        if self.user.Playing_2 != nil {
            player2.stop()
            player2.pos = 0.0
        }
        if self.user.Playing_3 != nil {
            player3.stop()
            player3.pos = 0.0
        }
    }
    func goNextPage(page:String){
        let storyboard: UIStoryboard = UIStoryboard(name: page, bundle: nil)
        let secondViewController = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    //音楽選択画面に移動
    func CheckPlaylist(whitchplaylist:Int){
        //音楽1の変更の場合1 2なら2 3,なら3
        self.user.SelectionFlag = whitchplaylist
        
        let myPlaylistQuery = MPMediaQuery.playlists()
        if let playlists = myPlaylistQuery.collections {
            print(playlists.count)
            self.user.BeforeView = "music statement"
            self.setSendData()
            self.goNextPage(page: "PlaylistSelection")
        }
    }
    
    
    /*************** スライダー系 ********************/
    //スライダーを表示
    
    func drawPitchSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width*1.2/4  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 3
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = -1000
        // 最大値を tmpmax に変更する
        slider.maximumValue = 1000
        
        slider.value = 0   // スライダーの値が変更された時に呼び出されるメソッドを設定
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changePitch1), for: .valueChanged)
            slider.value = player.pitch
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changePitch2), for: .valueChanged)
            slider.value = player2.pitch
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changePitch3), for: .valueChanged)
            slider.value = player3.pitch
        }
        if(id == 4){
            slider.addTarget(self, action: #selector(self.changePitch4), for: .valueChanged)
            slider.value = 0.0
        }
        
        return slider
        
    }
    
    
    @objc func changePitch1(_ sender: UISlider) {
        if(user.musicEditFlag[0] == true){
            player.pitch = player1_pitch_slider.value
            player.audioUnitTimePitch.pitch = player1_pitch_slider.value
        }
    }
    @objc func changePitch2(_ sender: UISlider) {
        if(user.musicEditFlag[1] == true){
            player2.pitch = player2_pitch_slider.value
            player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
        }
    }
    @objc func changePitch3(_ sender: UISlider) {
        if(user.musicEditFlag[2] == true){
            player3.pitch = player3_pitch_slider.value
            player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
        }
    }
    @objc func changePitch4(_ sender: UISlider) {
        
        if(user.musicEditFlag[0] == true){
            player.pitch = player1_pitch_slider.value
            player1_pitch_slider.value = player4_pitch_slider.value
            player.audioUnitTimePitch.pitch = player1_pitch_slider.value
        }
        if(user.musicEditFlag[1] == true){
            player2.pitch = player2_pitch_slider.value
            player2_pitch_slider.value = player4_pitch_slider.value
            player2.audioUnitTimePitch.pitch = player2_pitch_slider.value
        }
        if(user.musicEditFlag[2] == true){
            player3.pitch = player3_pitch_slider.value
            player3_pitch_slider.value = player4_pitch_slider.value
            player3.audioUnitTimePitch.pitch = player3_pitch_slider.value
        }
    }
    
    // 音量調整用スライダ作成
    func drawVolSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 1.3 / 8 , height * 3.3 / 8 , height * 5.3 / 8 ,  height * 10 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width * 3.2 / 4  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 3
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = 0.0
        // 最大値を tmpmax に変更する
        slider.maximumValue = 1.0
        
        slider.value = 0.5   // スライダーの値が変更された時に呼び出されるメソッドを設定
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changeVol1), for: .valueChanged)
            slider.value = player.vol
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changeVol2), for: .valueChanged)
            slider.value = player2.vol
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changeVol3), for: .valueChanged)
            slider.value = player3.vol
        }
        if(id == 4){
            slider.addTarget(self, action: #selector(self.changeVol4), for: .valueChanged)
        }
        
        return slider
        
    }
    
    @objc func changeVol1(_ sender: UISlider) {
        player.audioEngine.mainMixerNode.outputVolume = player1_vol_slider.value
        player.vol = player1_vol_slider.value
    }
    @objc func changeVol2(_ sender: UISlider) {
        player2.audioEngine.mainMixerNode.outputVolume = player2_vol_slider.value
        player2.vol = player2_vol_slider.value
    }
    @objc func changeVol3(_ sender: UISlider) {
        player3.audioEngine.mainMixerNode.outputVolume = player3_vol_slider.value
        player3.vol = player3_vol_slider.value
    }
    @objc func changeVol4(_ sender: UISlider) {
        player1_vol_slider.value = player4_vol_slider.value
        player2_vol_slider.value = player4_vol_slider.value
        player3_vol_slider.value = player4_vol_slider.value
        player.audioEngine.mainMixerNode.outputVolume = player1_vol_slider.value
        player2.audioEngine.mainMixerNode.outputVolume = player2_vol_slider.value
        player3.audioEngine.mainMixerNode.outputVolume = player3_vol_slider.value
        player.vol = player1_vol_slider.value
        player2.vol = player2_vol_slider.value
        player3.vol = player3_vol_slider.value
    }
    
    // 再生位置スライダ作成
    func drawPosSlider(id:Int) -> UISlider{
        let height = self.view.bounds.height
        let pos_y = [height * 2.2 / 8 , height * 4.2 / 8 , height * 6.2 / 8 ,  height * 11 / 12]
        
        let sliderFlame = CGPoint(x:self.view.bounds.width * 1.8 / 3  , y:pos_y[id - 1])
        
        // スライダーの作成
        let slider = UISlider()
        // 幅を いい感じ に変更する
        slider.frame.size.width = self.view.bounds.width / 2
        slider.sizeToFit()
        slider.center = sliderFlame
        
        // 最小値を tmpmin に変更する
        slider.minimumValue = 0.0
        // 最大値を tmpmax に変更する
        slider.maximumValue = 10.0
        // スライダーの値が変更された時に呼び出されるメソッドを設定
        slider.value = 0.0
        
        if(id == 1){
            slider.addTarget(self, action: #selector(self.changePos1), for: .touchUpInside)
            slider.value = player.pos
        }
        if(id == 2){
            slider.addTarget(self, action: #selector(self.changePos2), for: .touchUpInside)
            slider.value = player2.pos
        }
        if(id == 3){
            slider.addTarget(self, action: #selector(self.changePos3), for: .touchUpInside)
            slider.value = player3.pos
        }
        
        return slider
        
    }
    
    @objc func changePos1(_ sender: UISlider) {
        if(self.user.Playing_1 != nil){
            
            let PlayFlag1 = player.playing
            
            let position = Double(self.player1_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player.sampleRate * length)
            
            player.offset = position // ←シーク位置までの時間を一旦退避
            
            player.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player.audioPlayerNode.scheduleSegment(player.audioFile,
                                                       startingFrame: newsampletime,
                                                       frameCount: framestoplay,
                                                       at: nil,
                                                       completionHandler: nil)
                
            }
            if(PlayFlag1 == true){
                player.audioPlayerNode.play()
            }
        }
    }
    @objc func changePos2(_ sender: UISlider) {
        if(self.user.Playing_2 != nil){
            
            let PlayFlag2 = player2.playing
            
            let position = Double(self.player2_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player2.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player2.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player2.sampleRate * length)
            
            player2.offset = position // ←シーク位置までの時間を一旦退避
            
            player2.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player2.audioPlayerNode.scheduleSegment(player2.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
                print(newsampletime)
            }
            
            if(PlayFlag2 == true){
                player2.audioPlayerNode.play()
            }
        }
    }
    @objc func changePos3(_ sender: UISlider) {
        if(self.user.Playing_3 != nil){
            
            let PlayFlag3 = player3.playing
            
            let position = Double(self.player3_pos_slider.value)
            
            // シーク位置（AVAudioFramePosition）取得
            let newsampletime = AVAudioFramePosition(player3.sampleRate * position)
            
            // 残り時間取得（sec）
            let length = player3.duration - position
            
            // 残りフレーム数（AVAudioFrameCount）取得
            let framestoplay = AVAudioFrameCount(player3.sampleRate * length)
            
            player3.offset = position // ←シーク位置までの時間を一旦退避
            
            player3.audioPlayerNode.stop()
            
            if framestoplay > 100 {
                // 指定の位置から再生するようスケジューリング
                player3.audioPlayerNode.scheduleSegment(player3.audioFile,
                                                        startingFrame: newsampletime,
                                                        frameCount: framestoplay,
                                                        at: nil,
                                                        completionHandler: nil)
                
            }
            
            if(PlayFlag3 == true){
                player3.audioPlayerNode.play()
            }
        }
    }
    /************** タイマー系　***************/
    @objc func timerUpdate() {
        
        if player.playing == true && player.feedOutFlag == false{
            
            let nodeTime = player.audioPlayerNode.lastRenderTime
            let playerTime = player.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / player.sampleRate) + player.offset // シーク位置以前の時間を追加
            
            // 残り時間取得（sec）
            let length = player.duration - currentTime
            
            if(length < 0.0){
                player.audioPlayerNode.stop()
                player.audioPlayerNode.scheduleSegment(player.audioFile,
                                                       startingFrame: 0,
                                                       frameCount: AVAudioFrameCount(player.audioFile.length),
                                                       at: nil,
                                                       completionHandler: nil)
                player.audioPlayerNode.play()
                self.player1_pos_slider.value = 0.0
                player.pos = 0.0
                player.offset = 0.0
                Player1Time.text = String(format:"%02d:%02d",0, 0)
                print("\n\naaaaaaaaaaaaaaaaaaaaaaaa\n\n")
            }
            else{
                
                self.player1_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                player.pos = Float(currentTime)
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player1Time.text = String(format:"%02d:%02d",min, sec)
                print("time : " , String(format:"%02d:%02d",min, sec))
            }
        }
        
        
        if player2.playing == true && player2.feedOutFlag == false{
            
            let nodeTime = player2.audioPlayerNode.lastRenderTime
            let playerTime = player2.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / player2.sampleRate) + player2.offset // シーク位置以前の時間を追加
            
            // 残り時間取得（sec）
            let length = player2.duration - currentTime
            
            if(length < 0.0){
                player2.audioPlayerNode.stop()
                player2.audioPlayerNode.scheduleSegment(player2.audioFile,
                                                        startingFrame: 0,
                                                        frameCount: AVAudioFrameCount(player2.audioFile.length),
                                                        at: nil,
                                                        completionHandler: nil)
                player2.audioPlayerNode.play()
                self.player2_pos_slider.value = 0.0
                player2.pos = 0.0
                player2.offset = 0.0
                Player2Time.text = String(format:"%02d:%02d",0, 0)
                
            }
            else{
                
                self.player2_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                player2.pos = Float(currentTime)
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player2Time.text = String(format:"%02d:%02d",min, sec)
            }
        }
        
        
        if player3.playing == true && player3.feedOutFlag == false{
            
            let nodeTime = player3.audioPlayerNode.lastRenderTime
            let playerTime = player3.audioPlayerNode.playerTime(forNodeTime: nodeTime!)
            let currentTime = (Double(playerTime!.sampleTime) / player3.sampleRate) + player3.offset // シーク位置以前の時間を追加
            
            // 残り時間取得（sec）
            let length = player3.duration - currentTime
            
            if(length < 0.0){
                player3.audioPlayerNode.stop()
                player3.audioPlayerNode.scheduleSegment(player3.audioFile,
                                                        startingFrame: 0,
                                                        frameCount: AVAudioFrameCount(player3.audioFile.length),
                                                        at: nil,
                                                        completionHandler: nil)
                player3.audioPlayerNode.play()
                self.player3_pos_slider.value = 0.0
                player3.pos = 0.0
                player3.offset = 0.0
                Player3Time.text = String(format:"%02d:%02d",0, 0)
                
            }
            else{
                
                self.player3_pos_slider.value = Float(currentTime)  // 現在の経過時間をスライダーで表示
                player3.pos = Float(currentTime)
                
                let min = Int((currentTime + 0.49) / 60.0)
                let sec = Int(Int(currentTime + 0.49) % 60)
                Player3Time.text = String(format:"%02d:%02d",min, sec)
            }
        }
        
    }
    
    
    
    
    /***********  データ送受信 ************/
    func setSendData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = self.user
        if(self.user.Playing_1 != nil){
            let music1 = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
            print("player music")
            print(music1)
        }
    }
    func sendUserInfo() {
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate! {
            appDelegate.user = self.user
        }
    }
    func receiveData(){
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
            self.user = appDelegate.user
            self.loadFlag = appDelegate.loadFlag
            self.rowNum = appDelegate.rowNum
            //print("get data")
        }
    }
    
    
    /*****  テンプレート読み込み    *****/
    func loadTemplete(){
        if self.loadFlag == true { //テンプレートを読み込んだとき
            /*
             self.user.Playing_1 = self.user.Playing_1_MPMedia[self.rowNum]
             self.user.Playing_2 = self.user.Playing_2_MPMedia[self.rowNum]
             self.user.Playing_3 = self.user.Playing_3_MPMedia[self.rowNum]
             
             player.audioEngine.mainMixerNode.outputVolume = self.user.Playing_1_volume[self.rowNum]
             */
            player1_vol_slider.value = self.user.Playing_1_volume[self.rowNum]
            //      player2.audioEngine.mainMixerNode.outputVolume = self.user.Playing_2_volume[self.rowNum]
            player2_vol_slider.value = self.user.Playing_2_volume[self.rowNum]
            //    player3.audioEngine.mainMixerNode.outputVolume = self.user.Playing_3_volume[self.rowNum]
            player3_vol_slider.value = self.user.Playing_3_volume[self.rowNum]
            
            //  player.audioUnitTimePitch.pitch = self.user.Playing_1_pitch[self.rowNum]
            player1_pitch_slider.value = self.user.Playing_1_pitch[self.rowNum]
            //   player2.audioUnitTimePitch.pitch = self.user.Playing_2_pitch[self.rowNum]
            player2_pitch_slider.value = self.user.Playing_2_pitch[self.rowNum]
            //   player3.audioUnitTimePitch.pitch = self.user.Playing_3_pitch[self.rowNum]
            player3_pitch_slider.value = self.user.Playing_3_pitch[self.rowNum]
            
            if let appDelegate = UIApplication.shared.delegate as! AppDelegate!{
                appDelegate.loadFlag = false
            }
            self.loadFlag = false
        }
        
        /*
         if(self.user.Playing_1 != nil){
         title = self.user.Playing_1?.value(forProperty: MPMediaItemPropertyTitle)! as! String
         }
         */
        
        
        if(player.duration != 0.0){
            self.player1_pos_slider.maximumValue = Float(player.duration)
        }
        if(player2.duration != 0.0){
            self.player2_pos_slider.maximumValue = Float(player2.duration)
        }
        if(player3.duration != 0.0){
            self.player3_pos_slider.maximumValue = Float(player3.duration)
        }
        //user.SelectionFlag = 0
    }
    /*************  音楽読み込み　*********************/
    func loadMusic(){
        self.player1_pos_slider.maximumValue = Float(player.duration)
        self.player1_pos_slider.value = 0.0
        
        self.player2_pos_slider.maximumValue = Float(player2.duration)
        self.player2_pos_slider.value = 0.0
        
        self.player3_pos_slider.maximumValue = Float(player3.duration)
        self.player3_pos_slider.value = 0.0
        /*
         else if(self.loadFlag == true) {
         if(self.user.Playing_1 != nil){
         player.audioPlayerNode.stop()
         let url: URL  = self.user.Playing_1!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
         player.SetUp(text_url : url)
         print("曲１セット完了")
         self.player1_pos_slider.maximumValue = Float(player.duration)
         }
         if(self.user.Playing_2 != nil){
         player2.audioPlayerNode.stop()
         let url: URL  = self.user.Playing_2!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
         player2.SetUp(text_url : url)
         print("曲2セット完了")
         self.player2_pos_slider.maximumValue = Float(player2.duration)
         }
         if(self.user.Playing_3 != nil){
         player3.audioPlayerNode.stop()
         let url: URL  = self.user.Playing_3!.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
         player3.SetUp(text_url : url)
         print("曲3セット完了")
         self.player3_pos_slider.maximumValue = Float(player3.duration)
         }
         self.loadFlag = false
         }
         */
    }
}

