//
//  PointItem.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/5.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class PointItem: UIView {
    func _setupWidthFrame(__frame:CGRect,__number:Int,__r:CGFloat){
        
        let _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2*__r, height: 2*__r))
        _v.layer.cornerRadius = __r
        _v.backgroundColor = UIColor.clearColor()
        _v.center = CGPoint(x: 0, y: 0)
        _v.layer.borderColor = UIColor.whiteColor().CGColor
        _v.layer.borderWidth = 1.5
        addSubview(_v)
        
        if __r > 30{
            
            let _lable:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
            _lable.textAlignment = NSTextAlignment.Center
            _lable.center = CGPoint(x: 25, y: 15)
            _lable.textColor = UIColor(red: 182/255, green: 58/255, blue: 213/255, alpha: 1)
            //_lable.alpha = 0.5
            _lable.text = "♡1.3万"
            _lable.font = UIFont.boldSystemFontOfSize(13)
            
            
            let _rectView:UIView = UIView(frame: CGRect(x:0, y: 0, width: 50, height: 30))
            _rectView.layer.cornerRadius = 2
            _rectView.backgroundColor = UIColor.whiteColor()
            //_rectView.alpha = 0.7
            //let _rectPoint:CGPoint = CGPoint(x: __p.x - _r - 40 - 5, y: __p.y - 15)
            let _rectPoint:CGPoint = CGPoint(x:  -50 - 0.5, y:  __r-15)
            _rectView.frame.origin = _rectPoint
            _rectView.addSubview(_lable)
            
            let _circleV:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            _circleV.center = CGPoint(x:0.5, y: __r)
            _circleV.layer.cornerRadius = 2.5
            _circleV.backgroundColor = UIColor.whiteColor()
            //_circleV.alpha = 0.7
            
            addSubview(_rectView)
            addSubview(_circleV)
            
        }
        
        
        
        
        //_v.transform = CGAffineTransformMakeScale(2, 2)
        //_v.alpha = 0

    }
}
