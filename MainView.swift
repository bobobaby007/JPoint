//
//  MainView.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/30.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class MainView:UIViewController,PicItemDelegate{
    var _bgView:UIImageView?
    var _setuped:Bool = false
    
    var _panGesture:UIPanGestureRecognizer?
    
    var _currentPicItem:PicItem?
    var _nextPicItem:PicItem?
    var _CentralY:CGFloat = 130
    var _bottomY:CGFloat = 330
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        _CentralY = self.view.frame.height/2
        
        _bottomY = self.view.frame.height + 80
        
        _bgView = UIImageView(image: UIImage(named: "bg.jpg"))
        _bgView?.contentMode = UIViewContentMode.ScaleToFill
        _bgView?.frame = self.view.bounds
        
        _currentPicItem = PicItem(frame: CGRect(x: 20, y: _CentralY, width: self.view.frame.width-40, height: self.view.frame.width))
        _currentPicItem?._delegate = self
        
        
        _currentPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _CentralY)
        _currentPicItem?._setPic("image_1.jpg")
        
        _nextPicItem = PicItem(frame: CGRect(x: 20, y: _bottomY, width: self.view.frame.width-40, height: self.view.frame.width))
        _nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _bottomY)
        
        _nextPicItem?._setPic("image_1.jpg")
        
        //_bgView?.frame = self.view.frame
        _panGesture = UIPanGestureRecognizer(target: self, action: Selector("panHander:"))
        
        self.view.addGestureRecognizer(_panGesture!)
        

        self.view.addSubview(_bgView!)
        self.view.addSubview(_currentPicItem!)
        self.view.addSubview(_nextPicItem!)
        
        
        _setuped = true
        
    }
    
    func _clicked() {
        _next()
    }
    
    func _next(){
        UIView.beginAnimations("go", context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector(Selector("goOk:__finished:__context:"))
        _currentPicItem?.center = CGPoint(x: _currentPicItem!.center.x, y: 0)
        _currentPicItem?.alpha = 0
        _nextPicItem?.center = CGPoint(x: _nextPicItem!.center.x, y: _CentralY)
        UIView.commitAnimations()
    }
    func goOk(__id:String,__finished:Bool,__context:AnyObject){
        
        _currentPicItem?.removeFromSuperview()
        
        _currentPicItem = _nextPicItem!
        _currentPicItem?._delegate = self
        
        
        
        _nextPicItem = PicItem(frame: CGRect(x: 20, y: _bottomY+20, width: self.view.frame.width-40, height: self.view.frame.width))
        _nextPicItem?._setPic("image_1.jpg")
        _nextPicItem?.alpha = 0
        UIView.beginAnimations("go", context: nil)
        _nextPicItem?.center = CGPoint(x: self.view.frame.width/2, y: _bottomY)
        _nextPicItem?.alpha = 1
        
        UIView.commitAnimations()
        
        
        self.view.addSubview(_nextPicItem!)
        
        println("oo")
    }
    
    func panHander(__gesture:UIPanGestureRecognizer){
        let _offset:CGPoint = __gesture.translationInView(self.view)
        switch __gesture.state{
        case UIGestureRecognizerState.Changed:
            UIView.beginAnimations("go", context: nil)
            _currentPicItem?.center = CGPoint(x: _currentPicItem!.center.x, y: _CentralY+_offset.y)
            _nextPicItem?.center = CGPoint(x: _nextPicItem!.center.x, y: _bottomY+_offset.y*1.4)
            UIView.commitAnimations()
            
            return
        case UIGestureRecognizerState.Ended:
            if _offset.y < -120{
                _next()
                return
            }
            
            UIView.beginAnimations("go", context: nil)
            _currentPicItem?.center = CGPoint(x: _currentPicItem!.center.x, y: _CentralY)
            _nextPicItem?.center = CGPoint(x: _nextPicItem!.center.x, y: _bottomY)
            UIView.commitAnimations()
            return
        default:
            return
        }
        
        
    }
}
