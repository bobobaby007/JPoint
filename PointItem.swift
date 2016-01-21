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
    func _setupWidthFrame(__point:CGPoint,__width:CGFloat, __number:Int,__r:CGFloat){
        
        let _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2*__r, height: 2*__r))
        _v.layer.cornerRadius = __r
        _v.backgroundColor = UIColor.clearColor()
        _v.center = CGPoint(x: 0, y: 0)
        _v.layer.borderColor = UIColor(red: 182/255, green: 58/255, blue: 213/255, alpha: 1).CGColor
        _v.layer.borderWidth = 1.5
        
        
        let _v_in:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2*__r-3, height: 2*__r-3))
        _v_in.layer.cornerRadius = __r-1.5
        _v_in.backgroundColor = UIColor.clearColor()
        _v_in.center = CGPoint(x: 0, y: 0)
        _v_in.layer.borderColor = UIColor(red: 182/255, green: 58/255, blue: 213/255, alpha: 0.5).CGColor
        _v_in.layer.borderWidth = 2
        
        addSubview(_v)
        addSubview(_v_in)
        
        if __r > 5{
            
            
            var _rectView:UIView
            
            
            _rectView = UIView(frame: CGRect(x:0, y: 0, width: 30, height: 15))
            _rectView.layer.cornerRadius = 2
            //_rectView.layer.borderColor = UIColor.whiteColor().CGColor
            //_rectView.layer.borderWidth = 1
            
            _rectView.backgroundColor = UIColor(red: 182/255, green: 58/255, blue: 213/255, alpha: 1)
            
            
            let _lable:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: _rectView.frame.width, height: _rectView.frame.height))
            _lable.textAlignment = NSTextAlignment.Center
            //_lable.center = CGPoint(x: 25, y: 0)
            _lable.textColor = UIColor.whiteColor()
            //_lable.alpha = 0.5
            _lable.text = "☉\(__number)"
            _lable.font = UIFont.boldSystemFontOfSize(9)

            
            _rectView.addSubview(_lable)
            //_rectView.alpha = 0.7
            //let _rectPoint:CGPoint = CGPoint(x: __p.x - _r - 40 - 5, y: __p.y - 15)
            var _circleV:UIView //---小圆点
            
            _circleV = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            _circleV.layer.cornerRadius = 2.5
            //_circleV.layer.borderColor = UIColor.whiteColor().CGColor
            //_circleV.layer.borderWidth = 1
            _circleV.backgroundColor = UIColor(red: 182/255, green: 58/255, blue: 213/255, alpha: 1)
            //_circleV.alpha = 0.7
            
            
            var _pX:CGFloat = -__r
            var _pY:CGFloat = 0
            if (__point.x-__r-_rectView.frame.width)<0{
                _pX = __r
            }
            if (__point.y-__r)<0{
                _pY = __r
            }
            
            _circleV.center = CGPoint(x:_pX, y: _pY)
            
            if _pX<0{
                _rectView.frame.origin = CGPoint(x: _pX-_rectView.frame.width, y: _pY-_rectView.frame.height/2)
            }else{
                _rectView.frame.origin = CGPoint(x: _pX, y: _pY-_rectView.frame.height/2)
            }
            
            
            
            addSubview(_rectView)
            addSubview(_circleV)
            
        }
        
        
        
        
        //_v.transform = CGAffineTransformMakeScale(2, 2)
        //_v.alpha = 0

    }
}
