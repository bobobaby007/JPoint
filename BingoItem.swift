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
    var _uv:UIImageView?
    
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
        _matchImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _matchBackG?.addSubview(_matchImg!)
        
        _matchLabel = UILabel(frame: CGRect(x: 120, y: 80, width: 60, height: 100))
        _matchLabel?.numberOfLines = 0
        _matchLabel?.font = UIFont.systemFontOfSize(12)
        
        _matchLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        _matchLabel?.textColor = UIColor(red: 138/255, green: 120/255, blue: 200/255, alpha: 1)
        _matchLabel?.textAlignment = NSTextAlignment.Left
        _matchBackG?.addSubview(_matchLabel!)
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
