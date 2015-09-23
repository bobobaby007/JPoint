//
//  BingoView.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/3.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol BingoView_delegate:NSObjectProtocol{
    func _bingoViewOut()
    func _talkNow()
   
    
}


class BingoView:UIViewController {
    var _setuped:Bool = false
    var _btn_talkNow:UIButton = UIButton()
    var _btn_notNow:UIButton = UIButton()
    var _bingoView:UIImageView = UIImageView()
    var _colorsV:UIView = UIView()
    var _blurV:UIVisualEffectView = UIVisualEffectView()
    //var _myImg:PicView = PicView()
    var _bingoImg:PicView = PicView()
    
    var _delagate:BingoView_delegate?
    var _bingoLable:UILabel = UILabel()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
//    func _setMyImage(__pic:NSDictionary){
//        
//        _myImg._setPic(__pic, __block: { (dict) -> Void in
//            
//        })
//    }
    func _setBingoImage(__pic:NSDictionary){
        _bingoImg._setPic(__pic, __block: { (dict) -> Void in
            
        })
    }
    func _setBingoName(__str:String){
        _bingoLable.text = "太棒了，你猜中了"+__str+"的心思"
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.clearColor()
        
        _colorsV.backgroundColor = UIColor.clearColor()
        
        let blurEffect:UIBlurEffect=UIBlurEffect(style: UIBlurEffectStyle.Dark)
        _blurV = UIVisualEffectView(effect: blurEffect)
        
        _blurV.frame = self.view.bounds
        _blurV.alpha = 0
        
        _bingoView = UIImageView(image: UIImage(named: "bingoIcon.png"))
        
        let _bingoW:CGFloat = 0.6*self.view.frame.width
        
        _bingoView.frame = CGRect(x: 0, y: 0, width: _bingoW, height: 27*_bingoW/56)
        _bingoView.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2-200)
        _bingoView.alpha = 0
        
        _bingoLable = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        _bingoLable.textAlignment = NSTextAlignment.Center
        _bingoLable.textColor = UIColor.whiteColor()
        _bingoLable.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2+50)
        _bingoLable.alpha = 0
        
//        _myImg = PicView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
//        _myImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
//        _myImg.layer.borderWidth = 2
//        _myImg.layer.cornerRadius = 70
//        _myImg.layer.borderColor = UIColor.whiteColor().CGColor
//        _myImg.alpha=0
        _bingoImg = PicView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        _bingoImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _bingoImg.layer.borderWidth = 2
        _bingoImg.layer.cornerRadius = 60
        _bingoImg.layer.borderColor = UIColor.whiteColor().CGColor
        _bingoImg.alpha=0
        
        _btn_talkNow = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 50))
        _btn_notNow = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 50))
        _btn_talkNow.setBackgroundImage(UIImage(named: "talkNow.png"), forState: UIControlState.Normal)
        _btn_talkNow.setTitle("聊一聊", forState: UIControlState.Normal)
        _btn_notNow.setBackgroundImage(UIImage(named: "notNow.png"), forState: UIControlState.Normal)
        _btn_notNow.setTitle("等一下", forState: UIControlState.Normal)
        _btn_talkNow.alpha=0
        _btn_notNow.alpha=0
        
        _btn_talkNow.addTarget(self, action: "buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_notNow.addTarget(self, action: "buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        self.view.addSubview(_blurV)
        self.view.addSubview(_colorsV)
        self.view.addSubview(_bingoView)
        //self.view.addSubview(_myImg)
        self.view.addSubview(_bingoImg)
        self.view.addSubview(_btn_talkNow)
        self.view.addSubview(_btn_notNow)
        self.view.addSubview(_bingoLable)
        
        _setuped = true
    }
    
    
    
    
    
    func _show(){
       
        UIView.animateWithDuration(0.4, animations: { () -> Void in
         self._blurV.alpha=1
            
        }) { (stoped) -> Void in
         self._colorsIn()
            self._bingoOut()
            self._imgsOut()
            self._buttonsOut()
            self._labelOut()
        }
        
    }
    //----按钮出现
    func _buttonsOut(){
        _btn_talkNow.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+120)
        _btn_notNow.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+200)
        _btn_talkNow.transform = CGAffineTransformMakeScale(0.1, 0.1)
        _btn_talkNow.alpha = 0
        _btn_notNow.transform = CGAffineTransformMakeScale(0.1, 0.1)
        _btn_notNow.alpha = 0
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_talkNow.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_talkNow.alpha=1
           
            }) { (stop) -> Void in
                
        }
        UIView.animateWithDuration(1.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
           
            self._btn_notNow.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_notNow.alpha=1
            }) { (stop) -> Void in
                
        }
        
    }
    //－－－－－说明文字出现
    func _labelOut(){
        _bingoLable.alpha=0
        UIView.animateWithDuration(1, delay: 0.4, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._bingoLable.alpha=1
            }) { (stop) -> Void in
                
        }
    }
    //---头像出现
    func _imgsOut(){
        //_myImg.center = CGPoint(x: -100, y: self.view.frame.height/2-50)
        _bingoImg.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2-50)
        //self._myImg.alpha=0
        _bingoImg.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self._bingoImg.alpha=0
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            //self._myImg.center = CGPoint(x: self.view.frame.width/2-60, y: self.view.frame.height/2-50)
            //self._myImg.alpha=1
            self._bingoImg.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2-50)
            self._bingoImg.transform = CGAffineTransformMakeScale(1, 1)
            self._bingoImg.alpha=1
            }) { (stop) -> Void in
                
        }
    }
    //----bingo图标出现
    func _bingoOut(){
        self._bingoView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self._bingoView.alpha = 0
        UIView.animateWithDuration(1.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._bingoView.transform = CGAffineTransformMakeScale(1, 1)
            self._bingoView.alpha = 1
        }) { (stop) -> Void in
            
        }
    }
    //---颜色出现
    func _colorsIn(){
        
        
        let _width:CGFloat = self.view.bounds.width
        
        for index in 0...100{
            
            
            let _w:CGFloat = CGFloat(random()%5)
            let _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: _w, height: _w))
            _v.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2-200)
            _v.layer.cornerRadius = _w/2
            _colorsV.addSubview(_v)
            
            
            _v.backgroundColor = UIColor(red: 0.3+CGFloat(random()%50)*0.01, green: 0.3+CGFloat(random()%80)*0.01, blue: 0.3+CGFloat(random()%70)*0.01, alpha: 1)
            
            let durantion:NSTimeInterval = 0.1+Double(random()%500)*0.01
            
            UIView.animateWithDuration(durantion, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                let _length:CGFloat = -_width/2+CGFloat(random()%Int(_width))
                let _lengthY:CGFloat = -100+CGFloat(random()%200)
                
                
                
                _v.transform = CGAffineTransformMakeScale(2, 2)
                _v.center = CGPoint(x: self.view.bounds.width/2+_length, y: self.view.bounds.height/2+_lengthY-200)
            }, completion: { (stop) -> Void in
                
            })
            
            
        }
        
    }
    func _clearColors(){
        for subview in _colorsV.subviews {
            subview.removeFromSuperview()
        }
    }
    func buttonHander(sender:UIButton){
        switch sender{
        case _btn_talkNow:
            _talkNow()
        case _btn_notNow:
            _notNow()
        default:
            break
        }
    }
    func _talkNow(){
         _clearColors()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        _delagate?._talkNow()
    }
    func _notNow(){
        _clearColors()
        self._delagate?._bingoViewOut()
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
//            self._myImg.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2-50)
//            self._myImg.alpha=0
            self._bingoImg.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2-50)
            self._bingoImg.alpha=0
            self._bingoView.alpha=0
            self._blurV.alpha = 0
            
            self._btn_talkNow.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self._btn_talkNow.alpha=0
            
            self._btn_notNow.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self._btn_notNow.alpha=0
            
            self._bingoLable.alpha = 0
            
            }) { (stop) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
               
        }
    }
    
    func _out(){
        
    }
    
}
