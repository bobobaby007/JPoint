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
    
    var _delegate:profilePanelDelegate?
    var _dialogBoxView:UIView?
    var _boxV:UIView?
    var _arrowV:UIView?
    var _nameLabel:UILabel?
    var _tapG:UITapGestureRecognizer?
    
    var _sayText:UITextView?
    var _sayW:CGFloat = 20
    var _boxW:CGFloat?{
        didSet{
           
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _userImg = PicView(frame: CGRect(x: 0, y: 0, width: _imageH, height: _imageH))
        _userImg?.layer.cornerRadius = _imageH/2
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        
        _nameLabel = UILabel(frame: CGRect(x: _imageH+12, y: 0, width: frame.width-_imageH-12, height: 20))
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.font = UIFont.systemFontOfSize(12)
        
        
        _dialogBoxView = UIView(frame: CGRect(x: _imageH+12, y: 20, width: 30, height: 30))
        _dialogBoxView?.layer.shadowRadius = 5
        _dialogBoxView?.layer.shadowColor = UIColor.blackColor().CGColor
        _dialogBoxView?.layer.shadowOpacity = 0.2
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
        
        addSubview(_userImg!)
        addSubview(_dialogBoxView!)
        addSubview(_nameLabel!)
        
    }

    func tapHander(__sender:UITapGestureRecognizer){
        _delegate?._viewUser()
    }
    
    func _setPic(__pic:String){
        _userImg?._setImage(__pic)
    }
    func _setName(__set:String){
        _nameLabel?.text = __set
    }
    func _setSay(__set:String){
        _sayText?.text = __set
        
        let _size:CGSize = _sayText!.sizeThatFits(CGSize(width: _sayW, height: CGFloat.max))
        //_sayText?.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._boxV?.frame = CGRect(x: 0, y: 0, width: self._sayW+10, height: _size.height+10)
            self._sayText?.frame = CGRect(x: 5, y: 5, width: self._sayW, height: _size.height)
          //  self._sayText?.alpha = 1
        })
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}