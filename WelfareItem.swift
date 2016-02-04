//
//  BingoItem.swift
//  JPoint
//
//  Created by Bob Huang on 16/2/1.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class WelfareItem: UIView {
    
    var _matchImg:PicView?
    var _matchLabel:UILabel?
    var _matchBackG:UIView?
    var _message_textView:UITextView?
    
    var _tapG:UITapGestureRecognizer?
    var _isOpen:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _matchBackG = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _matchBackG?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        _matchBackG?.layer.cornerRadius = 15
        addSubview(_matchBackG!)
        
        
        _matchImg = PicView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _matchImg?.layer.cornerRadius = 12
        _matchImg?._scaleType = PicView._ScaleType_Full
        
        _matchImg?.backgroundColor = UIColor(white: 0, alpha: 1)
        _matchBackG?.addSubview(_matchImg!)
        
        _tapG = UITapGestureRecognizer(target: self, action: "tapHander:")
        _matchImg?.addGestureRecognizer(_tapG!)
        
        _matchLabel = UILabel(frame: CGRect(x: 120, y: 80, width: 60, height: 100))
        _matchLabel?.numberOfLines = 0
        _matchLabel?.font = UIFont.systemFontOfSize(12)
        
        _matchLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        _matchLabel?.textColor = UIColor(red: 138/255, green: 120/255, blue: 200/255, alpha: 1)
        _matchLabel?.textAlignment = NSTextAlignment.Left
        _matchBackG?.addSubview(_matchLabel!)
    }
    func tapHander(sender:UITapGestureRecognizer){
        if _isOpen{
            _closeImage()
        }else{
            _openImage()
        }
        
    }
    func _openImage(){
        UIApplication.sharedApplication().statusBarHidden = true
        _matchImg?._scaleType = PicView._ScaleType_Fit
        _matchImg?._move(_matchBackG!, __fromRect: _matchImg!.frame, __toView: MessageWindow._self!.view, __toRect: MessageWindow._self!.view.frame, __then: { () -> Void in
            self._matchImg?.layer.cornerRadius = 0
            self._matchImg!.scrollEnabled = true
            self._isOpen = true
        })
    }
    func _closeImage(){
        UIApplication.sharedApplication().statusBarHidden = false
        _matchImg?._scaleType = PicView._ScaleType_Full
        _matchImg?._back(MessageWindow._self!.view, __toView: _matchBackG!, __toRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), __then: { () -> Void in
            self._matchImg?.layer.cornerRadius = 12
            self._matchImg!.scrollEnabled = false
            self._isOpen = false
        })
    }
    func _setContent(__str:String){
        
        let _arr:[String] = __str.componentsSeparatedByString(",")
        let _str_1:String = _arr[0]
        let _str_2:String = _arr[1]
        
        
        
        let index = _str_1.startIndex.advancedBy(9) //swift 2.0+
        let index2 = _str_1.endIndex.advancedBy(0)
        
        let range_type = Range<String.Index>(start: index,end: index2)
        
        
        let _type:String = _str_1.substringWithRange(range_type)
        
        if _type == "image"{
            let index3 = _str_2.startIndex.advancedBy(0) //swift 2.0+
            let index4 = _str_2.endIndex.advancedBy(-1)
            
            let range_url = Range<String.Index>(start: index3,end: index4)
            let _url:String = _str_2.substringWithRange(range_url)
            
            print("福利图地址：",_url)
            self._matchImg?._loadImage(MainAction._imageUrl(_url))
        }

    }
    //-----设置成加载有问题样式
    func _setToBroken(__str:String){
        if _matchImg != nil{
            _matchImg?.removeFromSuperview()
        }
        _matchLabel?.frame = CGRect(x: 0, y: 80, width: 180, height: 100)
        _matchBackG?.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        //_uv?.image = CoreAction._converImageToGray(_uv!.image!)
        self._matchLabel?.text = "[\(__str)]"
        self._matchLabel?.sizeToFit()
        self._matchLabel?.center = CGPoint(x: 180/2, y: 100/2+80)
    }
    
    func _setDict(__bingo:NSDictionary){
        if _matchImg != nil{
            addSubview(_matchImg!)
        }
        self._matchImg?._loadImage(MainAction._imageUrl(__bingo.objectForKey("image") as! String))
        self._matchLabel?.text = __bingo.objectForKey("question") as? String
        self._matchLabel?.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
