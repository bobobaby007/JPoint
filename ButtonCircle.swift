//
//  ButtonCircle.swift
//  JPoint
//
//  Created by Bob Huang on 16/1/22.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class ButtonCircle: UIButton {
    var _iconImg:UIImage?
    var _setuped:Bool = false
    var _pic:PicView?
    var _newSign:UIView?
    override func didMoveToSuperview() {
      _setup()
    }
    
    func _setup(){
        if _setuped{
            return
        }
        self.contentMode=UIViewContentMode.Center
        self.layer.cornerRadius = self.frame.width/2
//        self.layer.shadowColor = UIColor.blackColor().CGColor
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowRadius = 5
        
        _setuped = true
    }
    func _setIcon(__img:String){
        let _img = UIImage(named: __img)!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.frame.width*2, height: self.frame.width*2), false, 1)
        _img.drawInRect(CGRect(x: self.frame.width/2-1, y: self.frame.width/2, width: self.frame.width, height: self.frame.width))
        _iconImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setImage(_iconImg!, forState: UIControlState.Normal)
        
        
    }
    func _showIcon(){
        if _pic != nil{
            _pic?.removeFromSuperview()
            _pic = nil
        }
        
    }
    func _hasNew(__yes:Bool){
        if __yes{
            if _newSign == nil{
                _newSign = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                _newSign?.layer.cornerRadius = 5
                _newSign?.center = CGPoint(x: 2*self.frame.width/3,y: self.frame.height/3)
                _newSign?.backgroundColor = MainAction._MyColor
                _newSign?.layer.borderColor = UIColor.whiteColor().CGColor
                _newSign?.layer.borderWidth = 2
                _newSign?.userInteractionEnabled = false
                
            }
            if _pic != nil{
                insertSubview(_newSign!, belowSubview: _pic!)
            }else{
                addSubview(_newSign!)
            }
            
        }else{
            if _newSign != nil{
                _newSign?.removeFromSuperview()
                _newSign = nil
            }
        }
    }
    func _showPic(__pic:String){
        if _pic == nil{
            _pic = PicView(frame: CGRect(x: 0, y: 0, width: self.frame.width-10, height: self.frame.height-10))
            _pic?.layer.cornerRadius = self.frame.width/2-5
            _pic?.center = CGPoint(x: self.frame.width/2,y: self.frame.height/2)
            _pic?.userInteractionEnabled = false
        }
        insertSubview(_pic!, belowSubview: self.imageView!)
        if _newSign != nil{
            addSubview(_newSign!)
        }
        _pic?._setPic(NSDictionary(objects: [__pic,"file"], forKeys: ["url","type"]), __block: { (__dict) -> Void in
           // self.setImage(self._pic?._imgView?.image, forState: UIControlState.Normal)
        })
    }
}
