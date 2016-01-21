//
//  MainView.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/30.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class MainView:UIViewController,PicItemDelegate,profilePanelDelegate,BingoView_delegate,EditingView_delegate,InfoPanel_delegate{
    let _gap:CGFloat = 10
    var _bgView:UIImageView?
    var _setuped:Bool = false
    
    var _panGesture:UIPanGestureRecognizer?
    
    var _forDelectPicItem:PicItem?
    var _currentPicItem:PicItem?
    var _nextPicItem:PicItem?
    
    var _nickname = "someone"
    var _avator = "profile"
    var _uid = "" //---用户id
    var _sex = 0
    
    //var _thirdPicItem:PicItem?
    
    var _CentralY:CGFloat = 130
    var _bottomY:CGFloat = 330
    var _bottomOut:CGFloat = 40
    var _picItemW:CGFloat = 300
    
    //--
    var _center_currentPicItem:CGPoint = CGPoint()
    var _center_infoPanel:CGPoint = CGPoint()
    var _center_nextPicItem:CGPoint = CGPoint()
    var _center_profilePanel:CGPoint = CGPoint()
    var _center_btn_list:CGPoint = CGPoint()
    var _center_btn_plus:CGPoint = CGPoint()
    var _center_btn_love:CGPoint = CGPoint()
    var _editingViewCY:CGFloat = 0
    
    //
    var _currentIndex:Int = 0
    
    var _firstIndex:Int = 0
    
    var _infoPanel:InfoPanel?
    var _infoH:CGFloat = 25
    
    var _btn_list:UIButton?
    var _btn_plus:UIButton?
    var _btn_love:UIButton?
    
    var _btnY:CGFloat = 80
    var _btnW:CGFloat = 60

    var _btnsIn:Bool = false
    
    var _profilePanel:ProfilePanel?
    var _profielH:CGFloat = 80
    
    var _editingViewC:EditingView?
    
    var _bingoController:BingoView?
    
    var _currentStatus:String = "mainView"// editingPage // showingBtns
    
    let _defaultQuestions:NSArray = ["猜猜我喜欢哪里","你喜欢哪里呢？","我们会有共同点吗？\n点点图片你就知道","找亮点","点一下，看看跟我的兴趣点一致不","点点图片，bingo me!","猜我的兴趣点在哪里","点图片就对了","我想看看你点哪里","喜欢哪里点哪里，跟我一样有奖励","你的兴趣点在哪里","大家来点点"]
    
    var _shouldReceivePan:Bool = true
    
    
    
    var _isFirstLoaded:Bool = true
    var _waitingForNext:Bool = false // －－－提示面板缩回后是否要展示下一张
    var _listLoaded:Bool = false // 列表下载完毕
    
    var _loadingV:UIView?
    
    
    var _replayTimes:Int = 0
    var _timer:NSTimer?
    
    var _btn_needTo:UIButton?
    var _needTo:Int = 0 //----需要做的动作
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 15
        
        _bgView = UIImageView(image: UIImage(named: "bg.jpg"))
        _bgView?.contentMode = UIViewContentMode.ScaleToFill
        _bgView?.frame = self.view.bounds
        
        _CentralY = self.view.frame.height/2
        _picItemW = self.view.frame.width-2*_gap
        _bottomY = self.view.frame.height+_picItemW/2

        //_panGesture = UIPanGestureRecognizer(target: self, action: Selector("panHander:"))
        
       // self.view.addGestureRecognizer(_panGesture!)
        self.view.addSubview(_bgView!)
        
        _editingViewC = EditingView()
        
        self.addChildViewController(_editingViewC!)
        _editingViewC!._delagate = self
        _editingViewC!._mainView = self
        _editingViewC?.view.frame=CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(_editingViewC!.view)
        _editingViewC?.didMoveToParentViewController(self)
        
        _btn_list = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_list?.center = CGPoint(x: 50, y: -_btnW)
        _btn_list?.backgroundColor = UIColor(red: 255/255, green: 94/255, blue: 94/255, alpha: 1)
        //_btn_list?.layer.masksToBounds = true
        _btn_list?.layer.cornerRadius = _btnW/2
        _btn_list?.layer.shadowColor = UIColor.blackColor().CGColor
        _btn_list?.layer.shadowOpacity = 0.2
        _btn_list?.layer.shadowRadius = 5
        _btn_list?.addTarget(self, action: Selector("buttonHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_plus = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW*1, height: _btnW*1))
        _btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -_btnW)
        _btn_plus?.backgroundColor = UIColor(red: 129/255, green: 255/255, blue: 36/255, alpha: 1)
        _btn_plus?.contentMode=UIViewContentMode.Center
        //_btn_plus?.layer.masksToBounds = true
        //_btn_plus?.layer.borderColor = UIColor.whiteColor().CGColor
        //_btn_plus?.layer.borderWidth = 2
        _btn_plus?.layer.cornerRadius = 1*_btnW/2
        _btn_plus?.layer.shadowColor = UIColor.blackColor().CGColor
        _btn_plus?.layer.shadowOpacity = 0.2
        _btn_plus?.layer.shadowRadius = 5
        _btn_plus?.addTarget(self, action: Selector("buttonHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_love = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_love?.backgroundColor = UIColor(red: 255/255, green: 222/255, blue: 42/255, alpha: 1)
        _btn_love?.center = CGPoint(x: self.view.frame.width-50, y: -_btnW)
        //_btn_love?.layer.masksToBounds = true
        _btn_love?.layer.cornerRadius = _btnW/2
        _btn_love?.layer.shadowColor = UIColor.blackColor().CGColor
        _btn_love?.layer.shadowOpacity = 0.2
        _btn_love?.layer.shadowRadius = 5
        _btn_love?.addTarget(self, action: Selector("buttonHander:"), forControlEvents: UIControlEvents.TouchUpInside)
       
        var _img:UIImage = UIImage(named: "icon_list.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_list?.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
       
        _img = UIImage(named: "icon_plus.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*8, height: _btnW*8), false, 1)
        _img.drawInRect(CGRect(x: _btnW*2, y: _btnW*2, width: _btnW*4, height: _btnW*4))
        _btn_plus?.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        _img = UIImage(named: "icon_love.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2-1, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_love?.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        
        self.view.addSubview(_btn_list!)
        self.view.addSubview(_btn_plus!)
        self.view.addSubview(_btn_love!)
        
        _infoPanel = InfoPanel(frame: CGRect(x: _gap, y: _CentralY+_picItemW/2+_gap, width: _picItemW, height: _infoH))
        _infoPanel?._delegate = self
        _infoPanel?.alpha = 0
        self.view.addSubview(_infoPanel!)
        
        
        _profilePanel = ProfilePanel(frame: CGRect(x: _gap, y: 60, width: self.view.frame.width-2*_gap, height: 30))
        _profilePanel?.alpha = 0
        self.view.addSubview(_profilePanel!)
        
        
        
        
        _showBtns()
        
        _setuped = true
        
        
        _nextPicItem = nil
        _showLoadingV()
        
        _checkProfile()
        //_thirdPicItem = nil
       
        //_showIndex(0)
        
        
    }
    
    
    func _getNewMessages(){
        MainAction._getNewMessages { (__dict) -> Void in
            print("新消息：",__dict)
        }
    }
    
    
    
    func _checkProfile(){
        MainAction._getMyProfile { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                dispatch_async(dispatch_get_main_queue(), {
                    MainAction._soketConnect()
                    self._loadBingoList()
                    self._getNewMessages()
                    
                    //----------上线需注释掉
                    
                    MainAction._clearMyReadRecord()
                    
                })
            }else{
//                dispatch_async(dispatch_get_main_queue(), {
//                    self._startTimer()
//                })
                if (__dict.objectForKey("recode") as? Int) < 0{
                    dispatch_async(dispatch_get_main_queue(), {
                        ViewController._self!._showAlert("链接失败，请检查网络",__wait: 1.5)
                        self._needTo = 0
                        self._showNeedTo("网络似乎出现问题，\n 请确认设备已经链接到网络，\n[点击重新登录]")
                    })
                    return
                }
                if (__dict.objectForKey("recode") as? Int) == 202{
                    dispatch_async(dispatch_get_main_queue(), {
                        MainAction._loginQuick({ (__dict) -> Void in
                            self._checkProfile()
                        })
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let _reson:String = __dict.objectForKey("reson") as? String{
                        self._needTo = 0
                        self._showNeedTo(_reson + "\n[点击重新登录]")
                    }else{
                        self._needTo = 0
                        self._showNeedTo("网络出现问题了...\n[点击重试]")
                    }
                    
                })
                
            }
        }
    }

    //----加载列表
    func _loadBingoList()->Void{
        //_startTimer()
        _showLoadingV()
        MainAction._getBingoList { (__dict) -> Void in
            print("图片总数：",MainAction._BingoList.count)
           // self._showIndex(self._currentIndex)
            if __dict.objectForKey("recode") as! Int == 200{
                if MainAction._BingoList.count == 0{
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if self._isFirstLoaded{
                        self._showMainPage()
                        self._isFirstLoaded=false
                        self._currentIndex = self._firstIndex-1
                        self._next()
                        //self._showIndex(self._currentIndex)
                    }else{
                        self._currentIndex = self._firstIndex-1
                        
                    }
                    self._listLoaded = true
                    self._removeLoading()
                    self._timer?.invalidate()
                })
            }else{
                if (__dict.objectForKey("recode") as? Int) < 0 {
                    dispatch_async(dispatch_get_main_queue(), {
                        ViewController._self!._showAlert("链接失败，请检查网络",__wait: 0.5)
                        self._needTo = 1
                        self._showNeedTo("网络似乎出现问题，\n 请确认设备已经链接到网络，\n[点击重新加载]")
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self._startTimer()
                })
                
            }
            
        }
    }
    
    //-----需要重新连接
    
    func _showNeedTo(__text:String){
        if _btn_needTo == nil{
            _btn_needTo = UIButton(frame: CGRect(x: 0, y: 0, width: 205, height: 60))
            _btn_needTo?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
            _btn_needTo?.clipsToBounds = true
            _btn_needTo?.layer.cornerRadius = 5
            _btn_needTo?.titleLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
            _btn_needTo?.titleLabel?.textAlignment = NSTextAlignment.Center
            _btn_needTo?.titleLabel?.font = UIFont.systemFontOfSize(13)
            _btn_needTo?.setBackgroundImage(UIImage(named: "btn_circle.png"), forState: UIControlState.Normal)
            _btn_needTo?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
            _btn_needTo?.setTitleColor(UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5), forState: UIControlState.Normal)
            
            _btn_needTo?.backgroundColor = UIColor(white: 1, alpha: 0.5)
            self.view.addSubview(_btn_needTo!)
        }
        _btn_needTo?.setTitle(__text, forState: UIControlState.Normal)
    }
    func btnHander(sender:UIButton){
        switch _needTo{
        case 0:
            self._checkProfile()
            break
        case 1:
            self._loadBingoList()
            break
        default:
            
            break
        }
        if _btn_needTo != nil{
            _btn_needTo?.removeFromSuperview()
            _btn_needTo = nil
        }
    }
    
    
    //-----循环访问
    func _startTimer(){
        if self._timer ==  nil{
            self._timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "_timerHander", userInfo: nil, repeats: true)
            
            
        }
        NSRunLoop.mainRunLoop().addTimer(self._timer!, forMode: NSDefaultRunLoopMode)
        //self._timer!.fire()
    }
    
    func _timerHander(){
        print("oo")
        _loadBingoList()
    }
    
    
    //----展示加载动画
    
    func _showLoadingV(){
        if self._loadingV == nil{
            _loadingV = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            //_loadingV?.backgroundColor = UIColor.yellowColor()
            let _heart:ClickSign = ClickSign(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            _heart.center = CGPoint(x: _loadingV!.frame.width/2,y: _loadingV!.frame.height/2)
            _heart.transform = CGAffineTransformMakeScale(2, 2)
            //_heart.alpha = 0.4
            _loadingV?.addSubview(_heart)
            _heart._show()
            _loadingV?.center = CGPoint(x:self.view.frame.width/2, y: _CentralY)
        }
        _loadingV?.transform = CGAffineTransformMakeScale(1, 1)
        self.view.insertSubview(_loadingV!, aboveSubview: _bgView!)
    }
    func _removeLoading(){
        if self._loadingV != nil{
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self._loadingV!.transform = CGAffineTransformMakeScale(0, 0)
                }, completion: { (yes) -> Void in
                    if self._loadingV != nil{
                        self._loadingV!.removeFromSuperview()
                        self._loadingV = nil
                    }
                    
            })
            
            
        }
    }
    
    //----信息条代理
    //---举报
    func _report_this(__des:String){
        let _dict:NSDictionary = _currentPicItem!._dict!
        let _author:NSDictionary = _dict.objectForKey("author") as! NSDictionary
        MainAction._report(_author.objectForKey("_id") as! String, __bingoId: _dict.objectForKey("_id") as! String, __description: __des) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    ViewController._self!._showAlert("感谢您的举报，我们会尽快处理！", __wait: 3)
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    ViewController._self!._showAlert("网络似乎不太给力..", __wait: 3)
                })
                //
            }
        }
        
//        MainAction._sentBingo(_currentPicItem!._dict!.objectForKey("_id") as! String, __x: __x, __y: __y,__right:"yes") { (__dict) -> Void in
//            let recode:Int = __dict.objectForKey("recode") as! Int
//            if recode == 200{
//                
//            }else{
//                ViewController._self!._showAlert("网络似乎不太给力..", __wait: 3)
//            }
//            
//        }
//        MainAction._addBingosTo(self._uid, __type: MainAction._BingoType_bingo, __content: "[Bingo]", __nickname: self._nickname, __image: self._avator)
//        //MainAction._saveOneChat(<#T##__dict: NSDictionary##NSDictionary#>)
//        self._showBingo(self._nickname, __image: self._avator)
    }
    //---分享求助
    func _share_this() {
        sendWXContentUser()
    }
    func sendWXContentUser() {//分享给朋友！！
        let _image:UIImage = CoreAction._captureImage(_currentPicItem!._imageV!)
        let _thumbImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _thumbImage.image = _image
        let _pic:UIImage = CoreAction._captureImage(_thumbImage)
        var _ta:String = "她"
        if _sex == 1 {
            _ta = "他"
        }
        let message:WXMediaMessage = WXMediaMessage()
        message.title = "我喜欢"+_ta+"，帮我找找"+_ta+"的兴趣点"
        message.description = _nickname + "说:" + (_profilePanel?._sayText?.text)!
        message.setThumbImage(_pic);
        let ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "http://4view.cn"
        message.mediaObject = ext
        let resp = GetMessageFromWXResp()
        resp.message = message
        WXApi.sendResp(resp);
    }
    
    func sendWXContentFriend() {//分享朋友圈
        let _image:UIImage = CoreAction._captureImage(_currentPicItem!._imageV!)
        let _thumbImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _thumbImage.image = _image
        let _pic:UIImage = CoreAction._captureImage(_thumbImage)
        var _ta:String = "她"
        if _sex == 1 {
            _ta = "他"
        }
        let message:WXMediaMessage = WXMediaMessage()
        message.title = "我喜欢"+_ta+"，帮我找找"+_ta+"的兴趣点"
        message.description = _nickname + "说:" + (_profilePanel?._sayText?.text)!
        message.setThumbImage(_pic);
        
        let ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "http://4view.cn"
        message.mediaObject = ext
        message.mediaTagName = "Bingo一下"
        let req = SendMessageToWXReq()
        req.scene = 1
        req.text = "来，点一下"
        req.bText = false
        req.message = message
        WXApi.sendReq(req);
    }
    
    //----编辑页面代理
    
    
    
    func _edingImageIn() {
       // self.view.removeGestureRecognizer(_panGesture!)
        _shouldReceivePan = false
    }
    //----bingo页面代理
    func _bingoViewOut() {
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._btn_love!.center = CGPoint(x: self.view.frame.width-30, y: 10)
             //self._btn_love!.transform = CGAffineTransformMakeScale(2, 2)
            }) { (com) -> Void in
                UIView.animateWithDuration(0.4, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self._btn_love!.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    self._bingoController?.view.alpha = 0
                }) { (com) -> Void in
                    UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        
                        //self._btn_love!.center = CGPoint(x: self.view.frame.width-30, y: -40)
                        self._btn_love!.transform = CGAffineTransformMakeScale(0, 0)
                        self._bingoController?.view.removeFromSuperview()
                        self._bingoController?.removeFromParentViewController()
                        self._bingoController = nil
                        
                        }) { (com) -> Void in
                            //self._btn_love!.center = _p
                            
                            self._next()
                            //self.view.addGestureRecognizer(_panGesture!)
                            self._shouldReceivePan = true
                        }
                }
        }
    }
    func _talkNow() {
       // self.view.addGestureRecognizer(_panGesture!)
        _bingoController?.view.removeFromSuperview()
        _bingoController?.removeFromParentViewController()
        _bingoController = nil
        _shouldReceivePan = true
        let _messageWindow:MessageWindow = MessageWindow()
        _messageWindow._uid = _uid
        
        self.presentViewController(_messageWindow, animated: true) { (complete) -> Void in
            _messageWindow._setPorofileImg(self._avator)
            _messageWindow._setName(self._nickname)
            _messageWindow._getDatas()
        }
    }
    
    //----图片点击代理
    func _clicked() {
        //_next()
    }
    
    func _bingoFailed(__x:Int,__y:Int){
        MainAction._sentBingo(_currentPicItem!._dict!.objectForKey("_id") as! String, __x: __x, __y: __y,__right: "no") { (__dict) ->
        Void in
            
        }
        _waitingForNext = true
        ViewController._self?._showAlertThen("(>_<) 很遗憾！你没能猜中！", __wait: 1, __then: { () -> Void in
            if self._waitingForNext == true{
                self._next()
            }

        })
        
        
    }
    //=--------bingo成功
    func _bingo(__x:Int,__y:Int){
        MainAction._sentBingo(_currentPicItem!._dict!.objectForKey("_id") as! String, __x: __x, __y: __y,__right:"yes") { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                
            }else{
                ViewController._self!._showAlert("网络似乎不太给力..", __wait: 3)
            }
            
        }
       // MainAction._addBingosTo(self._uid,__content: "[Bingo]", __nickname: self._nickname, __image: self._avator)
        
        
        
        
       // MainAction._saveOneChat(<#T##__dict: NSDictionary##NSDictionary#>)
        
        //MainAction._saveOneChat(<#T##__dict: NSDictionary##NSDictionary#>)
        self._showBingo(self._nickname, __image: self._avator)
    }
    
    
    //-----提交bingo数据
    
    
    
    //---头像点击代理
    func _viewUser() {
        
    }
    
    //----
    func _showBingo(__name:String,__image:String){
       // self.view.removeGestureRecognizer(_panGesture!)
        _shouldReceivePan = false
        if _bingoController == nil{
            _bingoController = BingoView()
            _bingoController?._delagate=self
        }
        self.addChildViewController(_bingoController!)
        self.view.addSubview(_bingoController!.view)
        _bingoController?._setBingoName(__name)
        _bingoController?._setBingoImage(__image)
           // _bingoController?._setBingoImage(_avatar as! String)
        _bingoController?._show()
    }
    //----下一张
    func _next(){
        _btnsIn = false
        self._infoPanel?.alpha=0
        self._profilePanel?.alpha=0
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            if self._currentPicItem != nil{
                self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: -100)
                self._currentPicItem?.alpha = 0
            }
            if self._nextPicItem != nil{
                self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._CentralY)
            }
            
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: -self._btnW)
            self._btn_list?.center = CGPoint(x: 50, y: -self._btnW)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -self._btnW)
            self._btn_love!.transform = CGAffineTransformMakeScale(1, 1)
            
            //self._thirdPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY-self._bottomOut)
        }) { (finished) -> Void in
            
                self.didMoveStop()
            
            
        }
    }
    //---向上移动完成
    func didMoveStop(){
        if self._listLoaded == true{
            self._listLoaded = false
            self._showIndex(self._currentIndex)
            return
        }
        if _currentIndex >= MainAction._BingoList.count{
            _showBtns()
            return
        }
        if _currentPicItem == nil{
            return
        }
        ++_currentIndex
        _showIndex(_currentIndex)
    }
    
    //----轮巡并置换或初始化一次三个item
    func _checkItems(){
        
        if _currentPicItem != nil{
            self._currentPicItem?._delloc()
            self._currentPicItem?.removeFromSuperview()
            self._currentPicItem = nil
            
        }
        if _nextPicItem != nil{
            _currentPicItem = _nextPicItem
            
        }else{
            _currentPicItem = _picInAtIndex(_currentIndex)
            if _currentPicItem != nil{
                _currentPicItem?.alpha = 0
                _currentPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _CentralY+10)
                self.view.addSubview(_currentPicItem!)
            }
            //_currentPicItem?.alpha = 0
        }
        _nextPicItem = _picInAtIndex(_currentIndex+1)
        if _nextPicItem != nil{
            
            self.view.addSubview(_nextPicItem!)
            _nextPicItem?.alpha = 0
            _nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _bottomY-_bottomOut+10)
        }
    }
    
    //-----展示当前用户和图片
    func _showIndex(__index:Int){
        //return
        
        _currentIndex = __index
        if _currentIndex < 0{
            _currentIndex = 0
        }
        
        _checkItems()
        
        
        //----- _currentPicItem 实际是在下方准备要上来的item
        
        if _currentPicItem != nil{
            
            _currentPicItem?._ready()
            
            let _dict:NSDictionary = _currentPicItem!._dict!
            //print(_dict)
            
            _infoPanel?.center = CGPoint(x: _currentPicItem!.center.x,y:_currentPicItem!.center.y + _picItemW/2 + _gap + _infoH)
            _infoPanel?.alpha = 0
            _infoPanel?._setTime(CoreAction._dateDiff(_dict.objectForKey("create_at") as! String))
            _infoPanel?._setClick(_dict.objectForKey("like") as! Int)//点击次数
            _infoPanel?._setBingo(_dict.objectForKey("over") as! Int)//--点中次数
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2+_profielH)
            self._profilePanel?.alpha = 0
            
            if let _author:NSDictionary = _dict.objectForKey("author") as? NSDictionary{
                _uid = _author.objectForKey("_id") as! String
                
                
                
                if _dict.objectForKey("sex") as? Int == 1{
                    _sex = 1
                }else{
                    _sex = 0
                }
                
                _avator = MainAction._avatar(_author)
                _nickname = MainAction._nickName(_author)
                
            }
            _profilePanel?._setPic(_avator)
            _profilePanel?._setName(_nickname)
            
            _profilePanel?._setSay(_getQuestionByString(_dict.objectForKey("question") as! String))
            self._profilePanel?.alpha = 0
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:self._currentPicItem!.center.y + self._picItemW/2 + self._gap + self._infoH/2)
                self._infoPanel?.alpha = 1
                self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2-self._profielH)
                self._profilePanel?.alpha = 1
                
                }) { (finished) -> Void in
                    
            }
        }
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._CentralY)
            self._nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: self._bottomY-self._bottomOut)
            self._currentPicItem?.alpha = 1
            self._nextPicItem?.alpha = 1
            }) { (finished) -> Void in
                if self._forDelectPicItem != nil{
                    self._forDelectPicItem?._delloc()
                    self._forDelectPicItem?.removeFromSuperview()
                    self._forDelectPicItem = nil
                }
        }
    }
    func _getQuestionByString(__str:String)->String{
        if __str == ""||__str == "问题"{
            //let _n:Int = _defaultQuestions.count
            let _str:String =  _defaultQuestions[random()%_defaultQuestions.count] as! String
            return    _str
        }
        return __str
    }
    //----载入图片
    func _picInAtIndex(__index:Int)->PicItem?{
        if __index >= MainAction._BingoList.count{
            if __index == MainAction._BingoList.count{
                //_firstIndex = __index
                //print("again",_firstIndex)
                
                //_showLoadingV()
                
                _loadBingoList()
            }
            return nil
            //_item._setToLoading()
        }else{
            let _item:PicItem =  PicItem(frame: CGRect(x: 20, y: _bottomY+10, width: _picItemW, height: _picItemW))
            let _dict:NSDictionary = MainAction._BingoList[__index] as! NSDictionary
            //print("ddddd:",_dict)
            _item._dict = _dict
            _item._setPic(MainAction._imageUrl(_dict.objectForKey("image") as! String))
            _item._setAnswer(MainAction._imageUrl(_dict.objectForKey("answer") as! String))
            _item._delegate = self
            return _item
        }
    }
    //--------滑动代理
    func panHander(__gesture:UIPanGestureRecognizer){
        if _shouldReceivePan == false{
            return
        }
        
        let _offset:CGPoint = __gesture.translationInView(self.view)
        
        
        
        switch __gesture.state{
        case UIGestureRecognizerState.Began:
            
            _center_infoPanel = _infoPanel!.center
            _center_profilePanel = _profilePanel!.center
            
            if _currentPicItem != nil{
                _center_currentPicItem = _currentPicItem!.center
            }
            if _nextPicItem != nil{
                _center_nextPicItem = _nextPicItem!.center
            }
                _center_btn_list = _btn_list!.center
                _center_btn_plus = _btn_plus!.center
                _center_btn_love = _btn_love!.center
                _editingViewCY = _editingViewC!.view.frame.origin.y
            return
        case UIGestureRecognizerState.Changed:
            
            
            _waitingForNext = false
    
            UIView.beginAnimations("go", context: nil)
            
            _infoPanel?.center = CGPoint(x: _center_infoPanel.x,y:_center_infoPanel.y+_offset.y*0.9)
            self._profilePanel?.center = CGPoint(x: _center_profilePanel.x, y: _center_profilePanel.y+_offset.y*0.8)
            
            if _currentPicItem != nil{
                _currentPicItem?.center = CGPoint(x: _currentPicItem!.center.x, y: _center_currentPicItem.y+_offset.y)
            }
            if _nextPicItem != nil{
                _nextPicItem?.center = CGPoint(x: _nextPicItem!.center.x, y: _center_nextPicItem.y+_offset.y*0.7)
            }
            _btn_list?.center = CGPoint(x: 50, y: _center_btn_list.y+_offset.y*0.7)
            _btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _center_btn_plus.y+_offset.y*0.8)
            _btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _center_btn_love.y+_offset.y*0.7)
            
            self._editingViewC?.view.frame = CGRect(x: 0, y: _editingViewCY+_offset.y*0.6, width: self.view.frame.width, height: self.view.frame.height)
            
            UIView.commitAnimations()
            return
        case UIGestureRecognizerState.Ended:
            if _offset.y < -120{ //向上拉
                switch _currentStatus{
                case "mainView":
                    _next()
                case "editingPage":
                    _showMainPage()
                case "showingBtns":
                    _showMainPage()
                default:
                    break
                }
                return
            }
            
            if _offset.y > 250{
                if _currentStatus == "mainView"{
                    _showEdtingPage()
                    return
                }
            }
            
            
            if _offset.y > 120{//向下拉
                switch _currentStatus{
                case "mainView":
                   _showBtns()
                case "editingPage":
                    _showEdtingPage()
                case "showingBtns":
                    _showEdtingPage()
                default:
                    break
                }
                return
            }
            switch _currentStatus{
                case "mainView":
                _showMainPage()
                case "editingPage":
                _showEdtingPage()
                case "showingBtns":
                    _showBtns()
            default:
                break
            }
            
        default:
            return
        }
        
        
    }
    //-----恢复到开始的查看page
    func _showMainPage(){
        
        if _currentIndex >= MainAction._BingoList.count{
            _showBtns()
            return
        }
        
        _currentStatus = "mainView"
        _btnsIn = false
        self._editingViewC?._reset()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
             self._infoPanel?.center = CGPoint(x: self.view.frame.width/2,y:self._CentralY + self._picItemW/2 + self._gap + self._infoH/2)
            self._profilePanel?.center = CGPoint(x: self.self.view.frame.width/2, y: self._CentralY-self._picItemW/2-self._profielH)
            if self._currentPicItem != nil{
                self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._CentralY)
            }
            if self._nextPicItem != nil{
                self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY-self._bottomOut)
            }
            
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: -self._btnW)
            self._btn_list?.center = CGPoint(x: 50, y: -self._btnW)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -self._btnW)
            
            
            self._btn_love?.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_list?.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0)
            
            self._btn_plus?.backgroundColor =  UIColor(red: 129/255, green: 255/255, blue: 36/255, alpha: 1)
            self._editingViewC?.view.frame = CGRect(x: 0, y:-self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (complete) -> Void in
            //self._removeEditePage()
           // self.view.addGestureRecognizer(self._panGesture!)
            
            self._shouldReceivePan = true
        }
    }
    //－－－－－出现按钮--按钮在顶端
    func _showBtns(){
        
        
        
        
        _currentStatus = "showingBtns"
        let _btnToY:CGFloat = _btnY
        let _toY:CGFloat = _CentralY+1.5*_btnW
        _btnsIn=true
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _btnToY)
            self._btn_list?.center = CGPoint(x: 50, y: _btnToY)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _btnToY)
            
            
            
            self._btn_love?.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_list?.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0)
            self._btn_plus?.backgroundColor =  UIColor(red: 129/255, green: 255/255, blue: 36/255, alpha: 1)
            
            self._editingViewC?.view.frame = CGRect(x: 0, y:-self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (array) -> Void in
            
        }
        if self._currentPicItem != nil{
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
                self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY)
                self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:_toY + self._picItemW/2 + self._gap + self._infoH/2)
                //self._infoPanel?.alpha = 0
                self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2-self._profielH)
                //self._profilePanel?.alpha=1
                self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY)
            
            }) { (array) -> Void in
                
            }
        }
    }
    func buttonHander(sender:UIButton){
        switch sender{
        case _btn_plus!:
            
            switch _currentStatus{
                case "mainView":
                 _showEdtingPage()
                case "editingPage":
                    
                    if _editingViewC!._shouldBeClosed(){
                        _showMainPage()
                    }                
                case "showingBtns":
                _showEdtingPage()
            default:
               
                break
            }            
            break
        case _btn_love!:
            ViewController._self?._showRight()
            break
        case _btn_list!:
            ViewController._self?._showLeft()
            break
        default:
            break
        }
    }
    
    
    //-----清除制作页面
    func _removeEditePage(){
        _editingViewC!.view.removeFromSuperview()
        _editingViewC?.removeFromParentViewController()
        
    }
    
    //-------展示制作页面
    func _showEdtingPage(){
        _currentStatus = "editingPage"
        
        let _btnToY:CGFloat = _bottomY-_picItemW/2-_btnY+_gap
        let _toY:CGFloat = _bottomY+_profielH + 2*_gap
        _btnsIn=true
        
        
        self._editingViewC?._btn_closeH = _btnToY
        self._editingViewC?._show()

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _btnToY)
            self._btn_list?.center = CGPoint(x: 50, y: _btnToY)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _btnToY)
            self._editingViewC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }) { (array) -> Void in
        }
        
        
        UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self._btn_plus?.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { (ok) -> Void in
                UIView.animateWithDuration(0.4, delay: 0.4, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self._btn_plus?.backgroundColor = UIColor.redColor()
                    self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0.25*3.14)
                    //self._btn_plus?.layer.transform = CATransform3DMakeRotation(0, 45, 45, 45)
                    }) { (array) -> Void in
                }
        }
        
        
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._btn_love?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0)
            self._btn_list?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0)
            //self._btn_plus?.layer.transform = CATransform3DMakeRotation(0, 45, 45, 45)
            }) { (array) -> Void in
        }
        
        if self._currentPicItem != nil{
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY)
            self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:_toY + self._picItemW/2 + self._gap + self._infoH/2)
            //self._infoPanel?.alpha = 0
            self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY+self._picItemW)
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY-self._picItemW/2-self._profielH)
            
            }) { (array) -> Void in
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
}
