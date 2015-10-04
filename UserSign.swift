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
    
    var _timer:NSTimer?
    var _isBreathOut:Bool = false
    var _breathTime:Int = 0
    
    
    func _show(){
        
       
        if _heart == nil{
            _heart = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            _heart?.image = UIImage(named: "heart.png")
            _heart?.center = CGPoint(x: 0, y: 0)
            _heart?.alpha = 0
            //_heart!.layer.shadowColor = UIColor.blackColor().CGColor
            //_heart!.layer.shadowOpacity = 0.8
            //_heart?.layer.shadowRadius = 8
            addSubview(_heart!)
        
        
            
            
           
        }else{
            
        }
        self._heart!.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self._heart!.alpha = 0
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._heart!.transform = CGAffineTransformMakeScale(0.35, 0.35)
            self._heart!.alpha = 0.7
            
            }) { (finished) -> Void in
                // self._startBreath()
        }
        //_startBreath()
        
    }
    
    func _startBreath(){
        ++_breathTime
        if _breathTime>2{
           // _out()
           // return
        }
        if self.superview == nil{
            return
        }
        // _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("_timerHander:"), userInfo: nil, repeats: true)
        var _alpha:CGFloat
        var _scale:CGFloat
        
        if self._breathTime%2 == 1{
            _alpha = 0.6
            _scale = 0.35
        }else{
            _alpha = 0.7
            _scale = 0.3
        }

        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self._heart!.transform = CGAffineTransformMakeScale(_scale, _scale)
            self._heart!.alpha = _alpha
            
            }) { (finished) -> Void in
                self._startBreath()
        }
        if _isBreathOut{
            
            
            
            //_isBreathOut = false
        }else{
            _isBreathOut = true
        }
        
    }
    
    
}