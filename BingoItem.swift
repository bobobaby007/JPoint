//
//  BingoItem.swift
//  JPoint
//
//  Created by Bob Huang on 16/2/1.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class BingoItem: UIView {
    
    var _matchImg:PicView?
    var _matchLabel:UILabel?
    var _matchBackG:UIView?
    var _message_textView:UITextView?
    
    var _bingoId:String? //-----用于查看bingo详情，未赋值
    var _bingoDict:NSDictionary?
    var _uv:UIImageView?
    
    var _tapG:UITapGestureRecognizer?
    var _isOpen:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _matchBackG = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _matchBackG?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        _matchBackG?.layer.cornerRadius = 15
        addSubview(_matchBackG!)
        
        _uv = UIImageView(image: UIImage(named: "icon_bing_at_message.png"))
        _uv?.backgroundColor = UIColor.clearColor()
        _uv?.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        _uv?.contentMode = UIViewContentMode.ScaleAspectFit
        
        _matchBackG?.addSubview(_uv!)
        
        _matchImg = PicView(frame:CGRect(x: 10, y: 80, width: 100, height: 100))
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
        
        _matchImg?._scaleType = PicView._ScaleType_Fit
        self._matchImg?._loadImage(MainAction._imageUrl(self._bingoDict!.objectForKey("image") as! String))
        UIApplication.sharedApplication().statusBarHidden = true
        _matchImg?._move(_matchBackG!, __fromRect: _matchImg!.frame, __toView: MessageWindow._self!.view, __toRect: MessageWindow._self!.view.frame, __then: { () -> Void in
            self._matchImg?.layer.cornerRadius = 0
            self._matchImg!.scrollEnabled = true
            
            self._isOpen = true
            
        })
    }
    func _closeImage(){
        
        _matchImg?._scaleType = PicView._ScaleType_Full
        UIApplication.sharedApplication().statusBarHidden = false
        _matchImg?._back(MessageWindow._self!.view, __toView: _matchBackG!, __toRect: CGRect(x: 10, y: 80, width: 100, height: 100), __then: { () -> Void in
            self._matchImg?.layer.cornerRadius = 12
            self._matchImg!.scrollEnabled = false
            self._isOpen = false
        })
    }
    //-----是bingo情况下下载bingo
    func _getBingo(__bingoId:String){
        MainAction._getBingoInfo(__bingoId) { (__dict) -> Void in
                        
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _dict:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                    let _bingo:NSDictionary = _dict.objectForKey("bingo") as! NSDictionary
                    self._setDict(_bingo)
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self._setToBroken(__dict.objectForKey("reason") as! String)
                })
            }
        }
    }
    func _setContent(__str:String){
        let index = __str.startIndex.advancedBy(7) //swift 2.0+
        let index2 = __str.endIndex.advancedBy(-1) //swift 2.0+
        let range = Range<String.Index>(start: index,end: index2)
        if let _str:String = __str.substringWithRange(range){
            _getBingo(_str)
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
        _bingoDict = __bingo
        if _matchImg != nil{
            addSubview(_matchImg!)
        }
        self._matchImg?._setImage("noPic.jpg")
        
        self._matchImg?._loadImage(MainAction._imageUrl(_bingoDict!.objectForKey("image") as! String)+"@!small")
        self._matchLabel?.text = __bingo.objectForKey("question") as? String
        self._matchLabel?.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
