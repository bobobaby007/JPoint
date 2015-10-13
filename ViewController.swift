//
//  ViewController.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var _mainView:MainView?
    var _leftPanel:LeftPanel?
    var _rightPanel:RightPanel?
    var _panG:UIPanGestureRecognizer?
    var _setuped:Bool =  false
    var _currentPage:String = "mainView"//leftPanel/rightPanel
    
    var _touchPoint:CGPoint?
    var _isChanging:Bool = false
    var _startTransOfMainView:CGAffineTransform?
    var _startTransOfRightView:CGAffineTransform?
    
    let _distanceToSwape:CGFloat = 60
    var _backButton:UIButton?
    
    static var _self:ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
        _showMainView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setup(){
        if _setuped{
            return
        }
        
        ViewController._self = self
        
        
        
        _leftPanel = LeftPanel()
        self.addChildViewController(_leftPanel!)
        self.view.addSubview(_leftPanel!.view)
        _leftPanel?._parentView = self
        
        
        _mainView = MainView()
        self.addChildViewController(_mainView!)
        self.view.addSubview(_mainView!.view)
        _mainView?._loadBingoList()
        
        _rightPanel = RightPanel()
        _rightPanel?._parentView = self
        self.addChildViewController(_rightPanel!)
        _rightPanel?.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        _rightPanel?.view.layer.shadowColor = UIColor.blackColor().CGColor
        _rightPanel?.view.layer.shadowOpacity = 0.7
        _rightPanel?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        _rightPanel?.view.layer.shadowRadius = 15
        
        
        
        self.view.addSubview(_rightPanel!.view)
        
        
        _panG = UIPanGestureRecognizer(target: self, action: "panHander:")
        self.view.addGestureRecognizer(_panG!)
        
        _backButton = UIButton(frame: CGRect(x: 0, y: 0, width: _distanceToSwape/2, height: self.view.frame.height))
        _backButton?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _setuped=true
    }
    func btnHander(sender:UIButton){
        _showMainView()
    }
    
    func panHander(sender:UIPanGestureRecognizer){

        //return
        
        
        let _offset:CGPoint = sender.translationInView(self.view)
       // println(_offset.x)
        
        switch sender.state{
        case UIGestureRecognizerState.Began:
            _touchPoint = sender.locationInView(self.view)
            _startTransOfMainView = _mainView?.view.transform
            
            _startTransOfRightView = _rightPanel?.view.transform
            
            if (_touchPoint!.x < _distanceToSwape && _offset.x>_offset.y  && _offset.x>0)||(_touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0){//----左向右滑动
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
                if _touchPoint!.x < _distanceToSwape && _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                    }
                    if _currentPage=="rightPanel"{
                       _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                        
                       _rightPanel?.view.layer.shadowOffset = CGSize(width: -self._distanceToSwape+_offset.x/6, height: 0)
                        
                        _toTranRight = CGAffineTransformTranslate(_startTransOfRightView!, _offset.x, 0)
                    }
                    if _currentPage == "leftPanel"{
                        return
                    }
                    //return
                }
                if _touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0{//----右向左滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                        var _offRight:CGFloat = _offset.x*1.5-50
                        if _offRight < -self.view.frame.width-50{
                            _offRight = -self.view.frame.width-50
                        }
                        
                        _rightPanel?.view.layer.shadowOffset = CGSize(width: _offset.x/10, height: 0)
                        
                        
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
                    if _touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0{//----右向左滑动
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
                    if _touchPoint!.x < _distanceToSwape && _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                        if _offset.x>100{
                            _showLeft()
                            break
                        }
                    }
                    if _touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0{//----右向左滑动
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
    func _showLeft(){
        _currentPage = "leftPanel"
        _leftPanel?.setup()
        self._mainView?.view.userInteractionEnabled = false
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._mainView?.view.transform = CGAffineTransformMakeTranslation(self.view.frame.width-_distanceToSwape/2, 0)

            }) { (comp) -> Void in
                self._backButton!.frame = CGRect(x:  self.view.frame.width - self._distanceToSwape/2, y: 0, width: self._distanceToSwape/2, height: self.view.frame.height)
                self.view.addSubview(self._backButton!)
        }
    }
    func _showRight(){
        _currentPage = "rightPanel"
        self._mainView?.view.userInteractionEnabled = false
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._mainView?.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.width+self._distanceToSwape, 0)
            
            self._rightPanel?.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.width+self._distanceToSwape/2, 0)
            self._rightPanel?.view.layer.shadowOffset = CGSize(width: -self._distanceToSwape, height: 0)
            
            }) { (complete) -> Void in
            //self._leftPanel?.view.removeFromSuperview()
            //self._leftPanel?.removeFromParentViewController()
            
            self._backButton!.frame = CGRect(x: 0, y: 0, width: self._distanceToSwape/2, height: self.view.frame.height)
            self.view.addSubview(self._backButton!)

                
            self._rightPanel?._getDatas()
        }
    }
    
    func _showMainView(){
        _currentPage = "mainView"
        self._mainView?.view.userInteractionEnabled = true
        UIView.animateWithDuration(0.2) { () -> Void in
           self._mainView?.view.transform = CGAffineTransformMakeTranslation(0, 0)
           self._rightPanel?.view.transform = CGAffineTransformMakeTranslation(50, 0)
            self._rightPanel?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
       self._backButton?.removeFromSuperview()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

