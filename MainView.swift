//
//  MainView.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/30.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class MainView:UIViewController,PicItemDelegate,profilePanelDelegate,BingoView_delegate,EditingView_delegate{
    let _gap:CGFloat = 10
    var _bgView:UIImageView?
    var _setuped:Bool = false
    
    var _panGesture:UIPanGestureRecognizer?
    
    var _currentPicItem:PicItem?
    var _nextPicItem:PicItem?
    var _thirdPicItem:PicItem?
    
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
    
    var _infoPanel:InfoPanel?
    var _infoH:CGFloat = 25
    
    var _btn_list:UIButton?
    var _btn_plus:UIButton?
    var _btn_love:UIButton?
    
    var _btnY:CGFloat = 60
    var _btnW:CGFloat = 60

    var _btnsIn:Bool = false
    
    var _profilePanel:ProfilePanel?
    var _profielH:CGFloat = 80
    
    var _editingViewC:EditingView?
    
    var _bingoController = BingoView()
    
    var _currentStatus:String = "mainView"// editingPage // showingBtns
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        _bgView = UIImageView(image: UIImage(named: "bg.jpg"))
        _bgView?.contentMode = UIViewContentMode.ScaleToFill
        _bgView?.frame = self.view.bounds
        
        _CentralY = self.view.frame.height/2
        _picItemW = self.view.frame.width-2*_gap
        _bottomY = self.view.frame.height+_picItemW/2

        _panGesture = UIPanGestureRecognizer(target: self, action: Selector("panHander:"))
        
        self.view.addGestureRecognizer(_panGesture!)
        self.view.addSubview(_bgView!)
        
        
        _editingViewC = EditingView()
        
        self.addChildViewController(_editingViewC!)
        _editingViewC!._delagate = self
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
        
        _btn_plus = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -_btnW)
        _btn_plus?.backgroundColor = UIColor(red: 129/255, green: 255/255, blue: 36/255, alpha: 1)
        _btn_plus?.contentMode=UIViewContentMode.Center
        //_btn_plus?.layer.masksToBounds = true
        _btn_plus?.layer.cornerRadius = _btnW/2
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
        
        
        _profilePanel = ProfilePanel(frame: CGRect(x: _gap, y: 60, width: self.view.frame.width-2*_gap, height: 30))
        
        self.view.addSubview(_profilePanel!)
        
        
        self.addChildViewController(_bingoController)
        _bingoController._delagate=self
        
       
        _showIndex(0)
        
        _setuped = true
        
    }
    
    //----编辑页面代理
    func _edingImageIn() {
        self.view.removeGestureRecognizer(_panGesture!)
    }
    //----bingo页面代理
    func _bingoViewOut() {
        _next()
        self.view.addGestureRecognizer(_panGesture!)
    }
    func _talkNow() {
        self.view.addGestureRecognizer(_panGesture!)
    }
    
    //----图片点击代理
    func _clicked() {
        //_next()
        _showBingo()
    }
    func _bingoFailed(){
        
    }
    func _bingo(){
        
    }
    //---头像点击代理
    func _viewUser() {
        
    }
    //----
    func _showBingo(){
        self.view.removeGestureRecognizer(_panGesture!)
        self.view.addSubview(_bingoController.view)
//        _bingoController._setMyImage(NSDictionary(objects: ["image_3.jpg","file"], forKeys: ["url","type"]))
        _bingoController._setBingoName("小甜甜")
        _bingoController._setBingoImage(NSDictionary(objects: ["image_2.jpg","file"], forKeys: ["url","type"]))
        _bingoController._show()
    }
    //----下一张
    func _next(){
        _btnsIn = false
        self._infoPanel?.alpha=0
        self._profilePanel?.alpha=0
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: -100)
            self._currentPicItem?.alpha = 0
            self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._CentralY)
            
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: -self._btnW)
            self._btn_list?.center = CGPoint(x: 50, y: -self._btnW)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -self._btnW)
            
            
            
            //self._thirdPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY-self._bottomOut)
        }) { (finished) -> Void in
            self.didMoveStop()
        }
    }
    //---向上移动完成
    func didMoveStop(){
        ++_currentIndex
        _showIndex(_currentIndex)
    }
    
    //-----展示当前用户和图片
    func _showIndex(__index:Int){
        _currentIndex = __index
        if _currentIndex == 0{
            _nextPicItem = _picInAtIndex(_currentIndex)
            _nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _CentralY)
            _nextPicItem?.alpha = 0
            _infoPanel = InfoPanel(frame: CGRect(x: _gap, y: _nextPicItem!.center.y+_picItemW/2+_gap, width: _picItemW, height: _infoH))
            _thirdPicItem = _picInAtIndex(_currentIndex+1)
            _thirdPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _bottomY-_bottomOut)
            self.view.addSubview(_thirdPicItem!)
            self.view.addSubview(_nextPicItem!)
            self.view.addSubview(_infoPanel!)
        }else{
            _currentPicItem?.removeFromSuperview()
            
        }
        _currentPicItem = _nextPicItem!
        _currentPicItem?._ready()
        _nextPicItem = _thirdPicItem!
        
        _thirdPicItem = _picInAtIndex(_currentIndex+2)
        _thirdPicItem?.alpha = 0
        _thirdPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _bottomY)
        
        _infoPanel?.center = CGPoint(x: _currentPicItem!.center.x,y:_currentPicItem!.center.y + _picItemW/2 + _gap + _infoH)
        _infoPanel?.alpha = 0
        _infoPanel?._setTime("3分钟前")
        _infoPanel?._setClick(_currentIndex*3)
        _infoPanel?._setLike(_currentIndex)
        
        self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2+_profielH)
        self._profilePanel?.alpha = 0
        
        _profilePanel?._setPic("profile.png")
        _profilePanel?._setName("千年等一回，等一会啊啊啊啊")
        _profilePanel?._setSay("我喜欢这里的一本书，你猜猜哪个是，")
        self._profilePanel?.alpha = 0
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: self._bottomY-self._bottomOut)
            self._currentPicItem?.alpha = 1
            self._nextPicItem?.alpha = 1
            self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:self._currentPicItem!.center.y + self._picItemW/2 + self._gap + self._infoH/2)
            self._infoPanel?.alpha = 1
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2-self._profielH)
            self._profilePanel?.alpha = 1
            
            }) { (finished) -> Void in
                
        }
        self.view.addSubview(_nextPicItem!)
    }
    //----载入图片
    func _picInAtIndex(__index:Int)->PicItem{
        var _item:PicItem =  PicItem(frame: CGRect(x: 20, y: _bottomY+10, width: _picItemW, height: _picItemW))
        _item._setPic("image_"+String(__index%3+1)+".jpg")
        _item._delegate = self
        return _item
    }
    //--------滑动代理
    func panHander(__gesture:UIPanGestureRecognizer){
        let _offset:CGPoint = __gesture.translationInView(self.view)
        
        
        
        switch __gesture.state{
        case UIGestureRecognizerState.Began:
            _center_currentPicItem = _currentPicItem!.center
            _center_infoPanel = _infoPanel!.center
            _center_nextPicItem = _nextPicItem!.center
            _center_profilePanel = _profilePanel!.center
            _center_btn_list = _btn_list!.center
            _center_btn_plus = _btn_plus!.center
            _center_btn_love = _btn_love!.center
            _editingViewCY = _editingViewC!.view.frame.origin.y
            return
        case UIGestureRecognizerState.Changed:
            
            
            UIView.beginAnimations("go", context: nil)
            _currentPicItem?.center = CGPoint(x: _currentPicItem!.center.x, y: _center_currentPicItem.y+_offset.y)
            _infoPanel?.center = CGPoint(x: _currentPicItem!.center.x,y:_center_infoPanel.y+_offset.y*0.9)
            _infoPanel?.alpha = 1+_offset.y*0.006
            _nextPicItem?.center = CGPoint(x: _nextPicItem!.center.x, y: _center_nextPicItem.y+_offset.y*0.7)
            _profilePanel?.alpha = 1+_offset.y*0.006
            _btn_list?.center = CGPoint(x: 50, y: _center_btn_list.y+_offset.y*0.7)
            _btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _center_btn_plus.y+_offset.y*0.8)
            _btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _center_btn_love.y+_offset.y*0.7)
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: _center_profilePanel.y+_offset.y*0.8)
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
            
            
            if _offset.y > 120{//像下拉
                switch _currentStatus{
                case "mainView":
                   showBtns()
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
                    showBtns()
            default:
                break
            }
            
        default:
            return
        }
        
        
    }
    //-----恢复到开始的查看page
    func _showMainPage(){
        _currentStatus = "mainView"
        _btnsIn = false
        
        self._editingViewC?._reset()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._CentralY)
            self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:self._CentralY + self._picItemW/2 + self._gap + self._infoH/2)
            self._infoPanel?.alpha = 1
            self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY-self._bottomOut)
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: -self._btnW)
            self._btn_list?.center = CGPoint(x: 50, y: -self._btnW)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: -self._btnW)
            
            
            self._btn_love?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0)
            self._btn_list?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0)
            self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0)
            self._btn_plus?.backgroundColor =  UIColor(red: 129/255, green: 255/255, blue: 36/255, alpha: 1)
            
            
            self._profilePanel?.alpha = 1
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2-self._profielH)
            self._editingViewC?.view.frame = CGRect(x: 0, y:-self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (complete) -> Void in
            //self._removeEditePage()
            self.view.addGestureRecognizer(self._panGesture!)
        }
    }
    //－－－－－出现按钮--按钮在顶端
    func showBtns(){
        _currentStatus = "showingBtns"
        var _btnToY:CGFloat = _btnY
        var _toY:CGFloat = _CentralY+2*_btnW
        _btnsIn=true
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _btnToY)
            self._btn_list?.center = CGPoint(x: 50, y: _btnToY)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _btnToY)
            self._editingViewC?.view.frame = CGRect(x: 0, y:-self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (array) -> Void in
            
        }
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY)
            self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:_toY + self._picItemW/2 + self._gap + self._infoH/2)
            self._infoPanel?.alpha = 0
            self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY)
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: self._currentPicItem!.center.y-self._picItemW/2-self._profielH)
            self._profilePanel?.alpha=1
            }) { (array) -> Void in
                
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
            break
        case _btn_list!:
            break
        default:
            break
        }
    }
    
    
    //-----清除制作页面
    func _removeEditePage(){
        _editingViewC?.removeFromParentViewController()
        _editingViewC!.view.removeFromSuperview()
    }
    
    //-------展示制作页面
    func _showEdtingPage(){
        _currentStatus = "editingPage"
        
        var _btnToY:CGFloat = _bottomY-_picItemW/2-_btnY+_gap
        var _toY:CGFloat = _bottomY+_profielH + 2*_gap
        _btnsIn=true
        
        self._editingViewC?._show()

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_love?.center = CGPoint(x: self.view.frame.width-50, y: _btnToY)
            self._btn_list?.center = CGPoint(x: 50, y: _btnToY)
            self._btn_plus?.center = CGPoint(x: self.view.frame.width/2, y: _btnToY)
            self._editingViewC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }) { (array) -> Void in
        }
        UIView.animateWithDuration(1, delay: 0.6, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0.25*3.14)
            self._btn_plus?.backgroundColor = UIColor.redColor()
            
            self._btn_plus?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0.25*3.14)
                        //self._btn_plus?.layer.transform = CATransform3DMakeRotation(0, 45, 45, 45)
            }) { (array) -> Void in
        }
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._btn_love?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0)
            self._btn_list?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0)
            //self._btn_plus?.layer.transform = CATransform3DMakeRotation(0, 45, 45, 45)
            }) { (array) -> Void in
        }
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._currentPicItem?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY)
            self._infoPanel?.center = CGPoint(x: self._currentPicItem!.center.x,y:_toY + self._picItemW/2 + self._gap + self._infoH/2)
            self._infoPanel?.alpha = 0
            self._nextPicItem?.center = CGPoint(x: self._nextPicItem!.center.x, y: self._bottomY+self._picItemW)
            self._profilePanel?.center = CGPoint(x: self._currentPicItem!.center.x, y: _toY-self._picItemW/2-self._profielH)
            
            }) { (array) -> Void in
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
}
