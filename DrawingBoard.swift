//
//  DrawingBoard.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/12.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class DrawingBoard:UIViewController {
    var _setuped:Bool = false
    var _panG:UIPanGestureRecognizer = UIPanGestureRecognizer()
    var _tapG:UITapGestureRecognizer = UITapGestureRecognizer()
    var _containerView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds=true
        _containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _containerView.alpha = 0.6
        _containerView.layer.shadowColor = UIColor.blackColor().CGColor
        _containerView.layer.shadowOffset = CGSizeMake(20, 20)
        _containerView.layer.shadowRadius = 20
        _containerView.layer.shadowOpacity = 0.4
        _containerView.clipsToBounds=true
        _panG = UIPanGestureRecognizer(target: self, action: "panHander:")
        _tapG = UITapGestureRecognizer(target: self, action: "tapHander:")
        
        self.view.addSubview(_containerView)
        
        _setuped=true
    }
    
    func _setEnabled(__set:Bool){
        if __set{
            self.view.addGestureRecognizer(_panG)
            self.view.addGestureRecognizer(_tapG)

        }else{
           self.view.removeGestureRecognizer(_panG)
            self.view.removeGestureRecognizer(_tapG)
        }
    }
    
    func panHander(sender:UIPanGestureRecognizer){
        switch sender.state{
        case UIGestureRecognizerState.Began:
            break
        case UIGestureRecognizerState.Changed:
            let _point:CGPoint = sender.locationInView(_containerView)
            if _point.x<0||_point.x>self.view.frame.width||_point.y<0||_point.y>self.view.frame.height{
                return
            }
            _addPointAt(_point)
            break
        default:
            break
        }
    }
    func tapHander(sender:UITapGestureRecognizer){
        let _point:CGPoint = sender.locationInView(_containerView)
        _addPointAt(_point)
        
    }
    func _addPointAt(__p:CGPoint){
        let _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        _v.layer.cornerRadius = 50
        _v.backgroundColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 1)
        _v.center = __p
        _v.alpha = 0
        //            _v.layer.shadowColor = UIColor.blackColor().CGColor
        //            _v.layer.shadowOffset = CGSizeMake(20, 20)
        //            _v.layer.shadowRadius = 20
        //            _v.layer.shadowOpacity = 0.4
        
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            _v.transform = CGAffineTransformMakeScale(0.3, 0.3)
            _v.alpha = 1
            }, completion: { (stop) -> Void in
                
        })
        _containerView.addSubview(_v)
    }
    
    func _clear(){
        for view in _containerView.subviews{
            view.removeFromSuperview()
        }
    }
    
}
