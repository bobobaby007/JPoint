//
//  ViewController.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UIAlertViewDelegate,CLLocationManagerDelegate{
    var _mainView:MainView?
    var _leftPanel:LeftPanel?
    var _rightPanel:RightPanel?
    var _panG:UIPanGestureRecognizer?
    var _setuped:Bool =  false
    var _currentPage:String = "mainView"//leftPanel/rightPanel
    
    var _touchPoint:CGPoint?//---开始点击的位置
    var _isChanging:Bool = false
    var _startTransOfMainView:CGAffineTransform?
    var _startTransOfRightView:CGAffineTransform?
    
    let _distanceToSwape:CGFloat = 60
    var _backButton:UIButton?
    
    
    var _alertPanelV:UIView?
    let _alertPanelH:CGFloat = 50
    var _alertLabel:UILabel?
    
    var _alertType:String = "newVersion"//    newVersion/setupProfile
    
    static weak var _self:ViewController?
    
    var _shouldPan:Bool = true
    let _locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        //print(CoreAction._version())
        _showMainView()
        
        // Do any additional setup after loading the view, typically from a nib.
       // MainAction._deleteChatHistory("bingome")
        //let _:NSTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerHander", userInfo: nil, repeats: false)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationHander:", name: MainAction._Notification_needToLog, object: nil)
    }
    
    func notificationHander(notification:NSNotification){
        switch notification.name{
        case MainAction._Notification_needToLog:
            _showLogMain()
            break
        default:
            break
        }
    }
    
    
    
    func timerHander(){
        MainAction._receiveOneChat(NSDictionary(objects: [MessageCell._Type_Message,"bingome","为啥给你呢好噶时光萨嘎色噶速度，水电工翁","2015-11-09T06:10:26.795Z"], forKeys: ["type","from","content","time"]))
    }    
    func setup(){
        if _setuped{
            return
        }
        ViewController._self = self
        
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestAlwaysAuthorization()
        _refershLoaction()
        
        _mainView = MainView()
        self.view.backgroundColor = UIColor.blackColor()
        self.addChildViewController(_mainView!)
        self.view.addSubview(_mainView!.view)
        _startTransOfRightView = CGAffineTransformMake(0, 0, 0, 0, 0, 0)
        //_mainView?._loadBingoList()
        _panG = UIPanGestureRecognizer(target: self, action: "panHander:")
        self.view.addGestureRecognizer(_panG!)
        _backButton = UIButton(frame: CGRect(x: 0, y: 0, width: _distanceToSwape/2, height: self.view.frame.height))
        _backButton?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _setuped=true
    }
        
    
    func btnHander(sender:UIButton){
        _showMainView()
    }
    
    //-----判断用户信息是否完整
    func _checkUserInfo()->Bool{
        let _str:String = MainAction._checkUserOk()
        if _str == ""{//----为没有需要设置的属性
            return true
        }else{
            self._alertType = "setupProfile"
            let _alerter:UIAlertView = UIAlertView(title: "", message: _str, delegate: self, cancelButtonTitle: "再看看", otherButtonTitles: "去设置")
            _alerter.show()
            return false
        }
    }
    //-----判断版本号
    func _checkVersion(){
        MainAction._getVersion { (__dict) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self._alertType = "newVersion"
//                let _alerter:UIAlertView = UIAlertView(title: "BingoMe 有新版本了！", message: "", delegate: self, cancelButtonTitle: "再看看", otherButtonTitles: "去更新")
//                _alerter.show()
//            })
        }
    }
    //-----提示条
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 1:
            
            switch _alertType{
                case "setupProfile":
                    let _viewC:ProfilePage = ProfilePage()
                    self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                        
                    })
                break
                case "newVersion":
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://appsto.re/cn/gG6d_.i")!)
                default:
                    
                break
            }
            
            
            break
        default:
            break
        }
    }
    
    
    func panHander(sender:UIPanGestureRecognizer){

        //return
        if !_shouldPan{
            return
        }
        
        let _offset:CGPoint = sender.translationInView(self.view)
       // println(_offset.x)
        
        switch sender.state{
        case UIGestureRecognizerState.Began:
            _touchPoint = sender.locationInView(self.view)
            _startTransOfMainView = _mainView?.view.transform
            
            
            
            if (_offset.x>_offset.y  && _offset.x>0){//----左向右滑动
                if _currentPage=="mainView"{
                 _leftIn()
                }
                if _rightPanel != nil{
                    _startTransOfRightView =  _rightPanel?.view.transform
                }
                
                _isChanging = true
                return
            }
            if (_offset.x<_offset.y && _offset.x<0){//----右向左滑动
                if _currentPage=="mainView"{
                    _rightIn()
                }
                _startTransOfRightView =  _rightPanel?.view.transform
            
                _isChanging = true
                return
            }
            if _currentPage=="mainView"{
                _mainView?.panHander(sender)
            }
            break
        case UIGestureRecognizerState.Changed:
            if _isChanging{
                var _toTranMain:CGAffineTransform? = _startTransOfMainView
                var _toTranRight:CGAffineTransform? = _startTransOfRightView
                if  _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, min(_offset.x,self.view.frame.width), 0)
                    }
                    if _currentPage=="rightPanel"{
                       _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                        
                       //_rightPanel?.view.layer.shadowOffset = CGSize(width: -self._distanceToSwape+_offset.x/6, height: 0)
                        
                        _toTranRight = CGAffineTransformTranslate(_startTransOfRightView!, min(_offset.x*1.04,self.view.frame.width), 0)
                    }
                    if _currentPage == "leftPanel"{
                        return
                    }
                    //return
                }
                if  _offset.x<_offset.y && _offset.x<0{//----右向左滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                        var _offRight:CGFloat = _offset.x*1.5//+self._distanceToSwape/2
                        if _offRight < -self.view.frame.width+self._distanceToSwape/2{
                            _offRight = -self.view.frame.width+self._distanceToSwape/2
                        }
                        
                        //_rightPanel?.view.layer.shadowOffset = CGSize(width: _offset.x, height: 0)
                        
                        
                       _toTranRight = CGAffineTransformTranslate(_startTransOfRightView!, _offRight, 0)
                    }
                    if _currentPage=="leftPanel"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                    }
                    if _currentPage == "rightPanel"{
                        return
                    }
                    //return
                }
                
                UIView.animateWithDuration(0.05) { () -> Void in
                    self._mainView?.view.transform = _toTranMain!
                    self._rightPanel?.view.transform = _toTranRight!
                }
            }else{
                if _currentPage=="mainView"{
                    _mainView?.panHander(sender)
                }
            }
            
            break
        case UIGestureRecognizerState.Ended:
            
            if _isChanging{
                switch _currentPage{
                case "leftPanel":
                    if  _touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0{//----右向左滑动
                        if _offset.x < -100{
                            _showMainView()
                            break
                        }
                    }
                    _showLeft()
                    break
                case "rightPanel":
                    if _touchPoint!.x < _distanceToSwape && _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                        if _offset.x>100{
                            _showMainView()
                            break
                        }
                    }
                    _showRight()
                    break
                case "mainView":
                    if  _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                        if _offset.x>100{
                            _showLeft()
                            break
                        }
                    }
                    if  _offset.x<_offset.y && _offset.x<0{//----右向左滑动
                        if _offset.x < -100{
                            _showRight()
                            break
                        }
                    }
                    _showMainView()
                    break
                default:
                    break
                    
                }
                

            }else{
                if _currentPage=="mainView"{
                    _mainView?.panHander(sender)
                }
               
            }
            
            _isChanging = false
            
            break
        default:
            break
        }
        
        
    }
    func _leftIn(){
        if _leftPanel == nil{
            _leftPanel = LeftPanel()
            _leftPanel?._parentView = self
            self.addChildViewController(_leftPanel!)
           // self.view.addSubview(_leftPanel!.view)
            self.view.insertSubview(_leftPanel!.view, belowSubview: _mainView!.view)
            _leftPanel?.setup()
        }
        
    }
    func _rightIn(){
        
        if _rightPanel == nil{
            
            _rightPanel = RightPanel()
            _rightPanel?._parentView = self
            self.addChildViewController(_rightPanel!)
            _rightPanel?.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //_rightPanel?.view.layer.shadowColor = UIColor.blackColor().CGColor
            //_rightPanel?.view.layer.shadowOpacity = 0.4
            //_rightPanel?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            //_rightPanel?.view.layer.shadowRadius = 15
            self.view.addSubview(_rightPanel!.view)
            self._rightPanel?._getDatas()
        }
        
    }
    
    
    func _showLeft(){
        _leftIn()
        _currentPage = "leftPanel"
        
        self._mainView?.view.userInteractionEnabled = false
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._mainView?.view.transform = CGAffineTransformMakeTranslation(self.view.frame.width-self._distanceToSwape/2, 0)

            }) { (comp) -> Void in
                
                if self._rightPanel != nil&&self._currentPage=="leftPanel"{
                    
                    self._rightPanel?.view.removeFromSuperview()
                    self._rightPanel?.removeFromParentViewController()
                    self._rightPanel = nil
                }
                
                self._backButton!.frame = CGRect(x:  self.view.frame.width - self._distanceToSwape/2, y: 0, width: self._distanceToSwape/2, height: self.view.frame.height)
                self.view.addSubview(self._backButton!)
        }
    }
    func _showRight(){
        _rightIn()
        _currentPage = "rightPanel"
        self._mainView?.view.userInteractionEnabled = false
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._mainView?.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.width+self._distanceToSwape, 0)
            
            if self._rightPanel != nil{
                self._rightPanel?.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.width+self._distanceToSwape/2, 0)
                //self._rightPanel?.view.layer.shadowOffset = CGSize(width: -self._distanceToSwape, height: 0)
            }
            }) { (complete) -> Void in
            
            if self._leftPanel != nil&&self._currentPage=="rightPanel"{
                self._leftPanel?.view.removeFromSuperview()
                self._leftPanel?.removeFromParentViewController()
                self._leftPanel = nil
            }
            self._backButton!.frame = CGRect(x: 0, y: 0, width: self._distanceToSwape/2, height: self.view.frame.height)
            self.view.addSubview(self._backButton!)
        }
    }
    
    func _showMainView(){
        _currentPage = "mainView"
        self._mainView?.view.userInteractionEnabled = true
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
                self._mainView?.view.transform = CGAffineTransformMakeTranslation(0, 0)
            
                if self._rightPanel != nil{
                    self._rightPanel?.view.transform = CGAffineTransformMakeTranslation(50, 0)
                    //self._rightPanel?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
                }
            
            }) { (com) -> Void in
                if self._leftPanel != nil&&self._currentPage=="mainView"{
                    self._leftPanel?.view.removeFromSuperview()
                    self._leftPanel?.removeFromParentViewController()
                    self._leftPanel = nil
                }
                if self._rightPanel != nil&&self._currentPage=="mainView"{
                    self._rightPanel?.view.removeFromSuperview()
                    self._rightPanel?.removeFromParentViewController()
                    self._rightPanel = nil
                }
        }
       self._backButton?.removeFromSuperview()
    }
    //－－－展示登录注册页面
    func _showLogMain(){
        
        
        let _logMain:Log_Main = Log_Main()
        self.presentViewController(_logMain, animated: true) { () -> Void in
            
        }
    }
    
    
    //-----提示面板普通弹出
    
    func _showAlert(__text:String,__wait:Double){
        _showAlertThen(__text, __wait: __wait) { () -> Void in
            
        }
    }
    
    
    
    func _showAlertThen(__text:String,__wait:Double,__then:()->Void){
        if _alertPanelV == nil{
            _alertPanelV = UIView(frame: CGRect(x: 0, y: -_alertPanelH, width: self.view.frame.width, height: _alertPanelH))
            
            let _v:UIView = UIView(frame: CGRect(x: 0, y: -20, width: self.view.frame.width, height: _alertPanelH+20))
            
            _v.backgroundColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5)
            _alertLabel = UILabel(frame: CGRect(x: 5, y: 5, width: _alertPanelV!.frame.width-10, height: _alertPanelH))
            _alertLabel?.textAlignment = NSTextAlignment.Center
            _alertLabel?.textColor = UIColor.whiteColor()
            _alertLabel?.font = UIFont.systemFontOfSize(12)
            _alertPanelV?.addSubview(_v)
            _alertPanelV?.addSubview(_alertLabel!)
            
            self.view.addSubview(_alertPanelV!)
        }
        _alertLabel?.text = __text
        _alertPanelV?.layer.removeAllAnimations()
        self._alertPanelV!.frame.origin = CGPoint(x: 0, y: -_alertPanelH-20)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._alertPanelV!.frame.origin = CGPoint(x: 0, y: 0)
            }) { (comp) -> Void in
                
                if __wait >= 0{
                    self._hideAlert(__wait, __then: { () -> Void in
                        __then()
                    })
                }
                
        }
    }
    func _hideAlert(__wait:Double,__then:()->Void){
        UIView.animateWithDuration(0.2, delay: __wait, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self._alertPanelV!.frame.origin = CGPoint(x: 0, y: -self._alertPanelH-20)
            }) { (comp) -> Void in
                __then()
                
        }
    }
    
    
    //---刷新位置
    
    func _refershLoaction(){
        
        _locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _loction:CLLocation = manager.location!
//        if(_loction.horizontalAccuracy > 0){
//           _loction.coordinate.latitude
//            _loction.coordinate.longitude
//            manager.stopUpdatingLocation()
//        }
        MainAction._locationPoint.x = CGFloat(_loction.coordinate.longitude)
        MainAction._locationPoint.y = CGFloat(_loction.coordinate.latitude)
        //print(MainAction._locationPoint)
        //print(_loction.coordinate.latitude,_loction.coordinate.longitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

