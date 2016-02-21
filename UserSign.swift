//
//  ClickSign.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/2.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class UserSign: UIView{
    var _heart:UIImageView?
    var _circle_big:UIImageView?
    var _circle_small:UIImageView?
    
    var _timer:NSTimer?
    var _isBreathOut:Bool = false
    var _breathTime:Int = 0
    
    var _setuped:Bool = false
    
    func _show(){
        if _setuped{
            
        }else{
            _circle_big = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            _circle_big?.image = UIImage(named: "circle_big.png")
            _circle_big?.center = CGPoint(x: 0, y: 0)
            _circle_big?.alpha = 0
//            _circle_big!.layer.shadowColor = UIColor.blackColor().CGColor
//            _circle_big!.layer.shadowOpacity = 0.2
//            _circle_big?.layer.shadowRadius = 5
            addSubview(_circle_big!)
            
            
            _circle_small = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            _circle_small?.image = UIImage(named: "circle_small.png")
            _circle_small?.center = CGPoint(x: 0, y: 0)
            _circle_small?.alpha = 0
//            _circle_small!.layer.shadowColor = UIColor.blackColor().CGColor
//            _circle_small!.layer.shadowOpacity = 0.2
//            _circle_small?.layer.shadowRadius = 5
            addSubview(_circle_small!)
            
            _heart = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            _heart?.image = UIImage(named: "bingoSign.png")
            _heart?.center = CGPoint(x: 0, y: 0)
            _heart?.alpha = 0
//            _heart!.layer.shadowColor = UIColor.blackColor().CGColor
//            _heart!.layer.shadowOpacity = 0.2
//            _heart?.layer.shadowRadius = 8
            addSubview(_heart!)
            
            
            
            
            
            
            _startBreath()
            _setuped = true
        }
       
        
        self._heart?.transform = CGAffineTransformMakeScale(3, 3)
        self._heart?.alpha = 0
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._heart?.transform = CGAffineTransformMakeScale(1, 1)
            self._heart?.alpha = 0.9
            }) { (finished) -> Void in
                
                
        }
        
    }
    
    func _startBreath(){
        ++_breathTime
        //print(_breathTime)
        
        if _breathTime>2{
            //_out()
            // return
        }
        
        if self.superview == nil{
            return
        }
        
        // _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("_timerHander:"), userInfo: nil, repeats: true)
        
        self._circle_big!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self._circle_big?.center = CGPoint(x: 0, y: 0)
        self._circle_big?.alpha = 0
        
        self._circle_small!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self._circle_small?.center = CGPoint(x: 0, y: 0)
        self._circle_small?.alpha = 0
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big?.alpha = 0.6
            self._circle_small?.alpha = 0.6
            }) { (finished) -> Void in
                
        }
        
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big?.alpha = 0
            self._circle_small?.alpha = 0
            }) { (finished) -> Void in
                // self._startBreath()
        }
        
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big!.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
            self._circle_big?.center = CGPoint(x: 0, y: 0)
            self._circle_small!.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            self._circle_small?.center = CGPoint(x: 0, y: 0)
            //self._circle_big?.alpha = 0
            //self._circle_small?.alpha = 0
            }) { (finished) -> Void in
                self._startBreath()
        }
        if _isBreathOut{
            
            
            
            //_isBreathOut = false
        }else{
            _isBreathOut = true
        }
        
    }
    func _out(){
        self._circle_big!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self._circle_big?.center = CGPoint(x: 0, y: 0)
        self._circle_big?.alpha = 0
        
        self._circle_small!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self._circle_small?.center = CGPoint(x: 0, y: 0)
        self._circle_small?.alpha = 0
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big?.alpha = 0.6
            self._circle_small?.alpha = 0.6
            }) { (finished) -> Void in
                
        }
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big?.alpha = 0
            self._circle_small?.alpha = 0
            }) { (finished) -> Void in
                
        }
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._circle_big!.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
            self._circle_big?.center = CGPoint(x: 0, y: 0)
            self._circle_small!.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            self._circle_small?.center = CGPoint(x: 0, y: 0)
            
            self._heart!.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self._heart?.center = CGPoint(x: 0, y: 0)
            
            self._circle_big?.alpha = 0
            self._circle_small?.alpha = 0
            self._heart?.alpha = 0
            
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
        
    }
    
    
}