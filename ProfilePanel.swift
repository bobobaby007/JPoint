//
//  ProfilePanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/3.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol profilePanelDelegate:NSObjectProtocol{
    func _viewUser()
}

class ProfilePanel:UIView {
    var _userImg:PicView?
    var _imageH:CGFloat = 60
    
    weak var _delegate:profilePanelDelegate?
    var _dialogBoxView:UIView?
    var _boxV:UIView?
    var _arrowV:UIView?
    var _nameLabel:UILabel?
    
    var _sayText:UITextView?
    var _sayW:CGFloat = 20
    
    
    
    var _tapG:UITapGestureRecognizer?
    var _isOpen:Bool = false
    var _userPic:String?
    var _boxW:CGFloat?{
        didSet{
           
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _userImg = PicView(frame: CGRect(x: 0, y: 0, width: _imageH, height: _imageH))
        _userImg?._imgView?.layer.cornerRadius = _imageH/2
        _userImg?.clipsToBounds = false
        _userImg?._imgView?.clipsToBounds = true
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?._scaleType = PicView._ScaleType_Full
//        _userImg?.layer.shadowRadius = 5
//        _userImg?.layer.shadowColor = UIColor.blackColor().CGColor
//        _userImg?.layer.shadowOpacity = 0.2
        _userImg?._imgView?.layer.borderColor = UIColor.whiteColor().CGColor
        _userImg?._imgView?.layer.borderWidth = 2
        
        
        _tapG = UITapGestureRecognizer(target: self, action: "tapHander:")
        _userImg?.addGestureRecognizer(_tapG!)
        
        
        _nameLabel = UILabel(frame: CGRect(x: _imageH+12, y: 0, width: frame.width-_imageH-12, height: 20))
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.font = UIFont.systemFontOfSize(12)
        
        
        _dialogBoxView = UIView(frame: CGRect(x: _imageH+12, y: 20, width: 30, height: 30))
//        _dialogBoxView?.layer.shadowRadius = 5
//        _dialogBoxView?.layer.shadowColor = UIColor.blackColor().CGColor
//        _dialogBoxView?.layer.shadowOpacity = 0.2
        _dialogBoxView?.backgroundColor = UIColor.clearColor()
        
        
        _boxV = UIView(frame: CGRect(x: 0, y: 0, width: frame.width-_imageH-12, height: _imageH))
        
        _boxV?.layer.cornerRadius = 10
        _boxV?.backgroundColor = UIColor.whiteColor()
        
        _sayW = frame.width-_imageH-12-10
        
        _sayText = UITextView(frame: CGRect(x: 5, y: 5, width: _sayW, height: _imageH-10))
        _sayText?.textColor = UIColor(red: 76/255, green: 83/255, blue: 126/255, alpha: 1)
        _sayText?.editable = false
        _sayText?.scrollEnabled = false
        _sayText?.font = UIFont.systemFontOfSize(14)
        _sayText?.backgroundColor = UIColor.clearColor()
        
        _boxV?.addSubview(_sayText!)
        
        
        _arrowV = UIImageView(image: UIImage(named: "arrow.png"))
        _arrowV?.frame = CGRect(x: -8, y: 15, width: 10, height: 10)
        
        _dialogBoxView?.addSubview(_arrowV!)
        _dialogBoxView?.addSubview(_boxV!)
        
        
        addSubview(_dialogBoxView!)
        addSubview(_nameLabel!)
        addSubview(_userImg!)
        
    }
    func _setPic(__pic:String){
        _userPic = __pic
        
        _userImg?._setImage("noPic.jpg")
        
        _userImg?._loadImage(_userPic!+"@!small")
        
//        _userImg?._setPic(NSDictionary(objects: ["noPic.jpg","file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
//            
//        })
    }
    func _setSex(__set:Int){
        
        switch __set{
        case 0:
           _userImg?._imgView?.layer.borderColor = Config._color_sex_female.CGColor
            break
        case 1:
            _userImg?._imgView?.layer.borderColor = Config._color_sex_male.CGColor
            break
            
        default:
            _userImg?._imgView?.layer.borderColor = UIColor.whiteColor().CGColor
            break
        }
    }
    
    func _setName(__set:String){
        _nameLabel?.text = __set
    }
    func _setSay(__set:String){
        //print(_sayText)
       self._sayText!.text = __set
        let _size:CGSize = _sayText!.sizeThatFits(CGSize(width: _sayW, height: CGFloat.max))
        //_sayText?.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._boxV?.frame = CGRect(x: 0, y: 0, width: self._sayW+10, height: _size.height+10)
            self._sayText?.frame = CGRect(x: 5, y: 5, width: self._sayW, height: _size.height)
          //  self._sayText?.alpha = 1
        })
    }
    
    //------点击头像图片打开查看大图
    
    func tapHander(sender:UITapGestureRecognizer){
        if _isOpen{
            _closeImage()
        }else{
            _openImage()
        }
    }
    func _openImage(){
        UIApplication.sharedApplication().statusBarHidden = true
        _userImg?.backgroundColor = UIColor.blackColor()
        _userImg?._scaleType = PicView._ScaleType_Fit
        ViewController._self?._shouldPan = false
        _userImg?._imgView?.layer.borderWidth = 0
        self._userImg!.layer.cornerRadius = self._imageH/2
        _userImg?._loadImage(_userPic!)
        _userImg?._move(self, __fromRect: _userImg!.frame, __toView: ViewController._self!.view, __toRect: ViewController._self!.view.frame, __then: { () -> Void in
            self._userImg!.layer.cornerRadius = self._imageH/2
            self._userImg!._imgView!.layer.cornerRadius = 0
            self._userImg!.layer.cornerRadius = 0
            self._userImg!.scrollEnabled = true
            self._isOpen = true
        })
    }
    func _closeImage(){
        UIApplication.sharedApplication().statusBarHidden = false
        _userImg?.backgroundColor = UIColor.clearColor()
        _userImg?._scaleType = PicView._ScaleType_Full
        self._userImg!._imgView!.layer.cornerRadius = self._imageH/2
        _userImg?._back(ViewController._self!.view, __toView: self, __toRect: CGRect(x: 0, y: 0, width: _imageH, height: _imageH), __then: { () -> Void in
            
            self._userImg!.scrollEnabled = false
            self._userImg!._imgView!.layer.borderWidth = 2
            self._isOpen = false
            ViewController._self?._shouldPan = true
        })
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
