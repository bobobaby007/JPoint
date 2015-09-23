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
    
    var _distanceToSwape:CGFloat = 60
    
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
        
        _rightPanel = RightPanel()
        self.addChildViewController(_rightPanel!)
        self.view.addSubview(_rightPanel!.view)
        
        _leftPanel = LeftPanel()
        self.addChildViewController(_leftPanel!)
        self.view.addSubview(_leftPanel!.view)
        
        
        _mainView = MainView()
        self.addChildViewController(_mainView!)
        self.view.addSubview(_mainView!.view)
        
        
        
        
        _panG = UIPanGestureRecognizer(target: self, action: "panHander:")
        self.view.addGestureRecognizer(_panG!)
        _setuped=true
    }
    
    
    func panHander(sender:UIPanGestureRecognizer){

        //return
        
        
        let _offset:CGPoint = sender.translationInView(self.view)
       // println(_offset.x)
        
        switch sender.state{
        case UIGestureRecognizerState.Began:
            _touchPoint = sender.locationInView(self.view)
            _startTransOfMainView = _mainView?.view.transform
            
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
                var _toTranMain:CGAffineTransform? = CGAffineTransform()
                if _touchPoint!.x < _distanceToSwape && _offset.x>_offset.y  && _offset.x>0{//----左向右滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                        
                    }
                    if _currentPage=="rightPanel"{
                       _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                    }
                    
                    
                    //return
                }
                if _touchPoint!.x > self.view.frame.width-_distanceToSwape && _offset.x<_offset.y && _offset.x<0{//----右向左滑动
                    if _currentPage=="mainView"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                    }
                    if _currentPage=="leftPanel"{
                        _toTranMain = CGAffineTransformTranslate(_startTransOfMainView!, _offset.x, 0)
                    }
                    //return
                }
                
                UIView.animateWithDuration(0.05) { () -> Void in
                    _mainView?.view.transform = _toTranMain!
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

            }) { (array) -> Void in
        }
    }
    func _showRight(){
        _currentPage = "rightPanel"
        self._mainView?.view.userInteractionEnabled = false
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._mainView?.view.transform = CGAffineTransformMakeTranslation(_distanceToSwape/2-self.view.frame.width, 0)
            
            }) { (array) -> Void in
        }
    }
    
    func _showMainView(){
        _currentPage = "mainView"
        self._mainView?.view.userInteractionEnabled = true
        UIView.animateWithDuration(0.2) { () -> Void in
           self._mainView?.view.transform = CGAffineTransformMakeTranslation(0, 0)
        }
       
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

