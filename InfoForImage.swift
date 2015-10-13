//
//  ProfilePanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/3.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol InfoForImage_delegate:NSObjectProtocol{
    
}

class InfoForImage:UIView,UITextViewDelegate{
    var _userImg:PicView?
    var _imageH:CGFloat = 60
    
    weak var _delegate:InfoForImage_delegate?
    var _dialogBoxView:UIView?
    var _boxV:UIView?
    var _arrowV:UIView?
    //var _nameLabel:UILabel?
    var _tapG:UITapGestureRecognizer?
    var _sayText:UITextView?
    var _sayW:CGFloat = 20
    let _maxNum:Int = 40
    let _placeHold:String = "告诉别人猜什么"
    
    var _boxW:CGFloat?{
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _userImg = PicView(frame: CGRect(x: 0, y: -10, width: _imageH, height: _imageH))
        _userImg?._imgView?.layer.cornerRadius = _imageH/2
        _userImg?.clipsToBounds = false
        _userImg?._imgView?.clipsToBounds = true
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
//        _userImg?.layer.shadowRadius = 5
//        _userImg?.layer.shadowColor = UIColor.blackColor().CGColor
//        _userImg?.layer.shadowOpacity = 0.2
        _userImg?._imgView?.layer.borderColor = UIColor.whiteColor().CGColor
        _userImg?._imgView?.layer.borderWidth = 2
        
        
        
        
//        _nameLabel = UILabel(frame: CGRect(x: _imageH+12, y: 0, width: frame.width-_imageH-12, height: 20))
//        _nameLabel?.textColor = UIColor.whiteColor()
//        _nameLabel?.font = UIFont.systemFontOfSize(12)
        
        
        _dialogBoxView = UIView(frame: CGRect(x: _imageH+12, y: 0, width: 30, height: 20))
        
        //_dialogBoxView?.layer.shadowRadius = 5
//        _dialogBoxView?.layer.shadowColor = UIColor.blackColor().CGColor
//        _dialogBoxView?.layer.shadowOpacity = 0.2
        _dialogBoxView?.backgroundColor = UIColor.clearColor()
        _dialogBoxView?.userInteractionEnabled = true
        
        _boxV = UIView(frame: CGRect(x: 0, y: 0, width: frame.width-_imageH-12, height: _imageH))
        _boxV?.userInteractionEnabled = true
        _boxV?.layer.cornerRadius = 10
        _boxV?.backgroundColor = UIColor.whiteColor()
        
        
        _sayW = frame.width-_imageH-12-10
        
        _sayText = UITextView(frame: CGRect(x: 5, y: 5, width: _sayW, height: _imageH-10))
        _sayText?.editable = true
        _sayText!.textContainer.maximumNumberOfLines = 3
        _sayText?.textColor = UIColor(red: 76/255, green: 83/255, blue: 126/255, alpha: 1)
        _sayText?.delegate = self
        //_sayText?.editable = false
        _sayText?.scrollEnabled = false
        _sayText?.font = UIFont.systemFontOfSize(14)
        //_sayText?.backgroundColor = UIColor.clearColor()
        
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        //_tapG = UITapGestureRecognizer(target: self, action: "tanHander:")
        _dialogBoxView!.addGestureRecognizer(_tapG!)
        
        _boxV?.addSubview(_sayText!)
        
        
        _arrowV = UIImageView(image: UIImage(named: "arrow.png"))
        _arrowV?.frame = CGRect(x: -8, y: 15, width: 10, height: 10)
        _arrowV?.clipsToBounds = true
        
        _dialogBoxView?.addSubview(_arrowV!)
        _dialogBoxView?.addSubview(_boxV!)
        
       addSubview(_userImg!)
        addSubview(_dialogBoxView!)
        //addSubview(_nameLabel!)
     
        _setSay(_placeHold)
    }
    
    func tapHander(sender:UITapGestureRecognizer){
        
        self.superview?.removeGestureRecognizer(_tapG!)
        //_sayText?.becomeFirstResponder()
        _sayText?.resignFirstResponder()
    }
    
    
    //----文字输入代理
    
    func textViewDidBeginEditing(textView: UITextView) {
        if _sayText?.text == _placeHold{
            _sayText?.text=""
        }
        self.superview?.addGestureRecognizer(_tapG!)
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        let _n:Int=_sayText!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
//        
//        if (_n+text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2)>_maxNum{
//            return false
//        }
        
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
       _refreshIt()
    }
    
    
    func _setPic(__pic:String){
        _userImg?._setImage(__pic)
    }
//    func _setName(__set:String){
//        _nameLabel?.text = __set
//    }
    func _setSay(__set:String){
        _sayText?.text = __set
        _refreshIt()
    }
    func _refreshIt(){
        let _size:CGSize = _sayText!.sizeThatFits(CGSize(width: _sayW, height: CGFloat.max))
        //_sayText?.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._boxV?.frame = CGRect(x: 0, y: 0, width: self._sayW+10, height: _size.height+10)
            self._dialogBoxView?.frame = CGRect(x: self._imageH+12, y: 0, width: self._sayW+10, height: _size.height+10)
            self._sayText?.frame = CGRect(x: 5, y: 5, width: self._sayW, height: _size.height)
            //  self._sayText?.alpha = 1
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
