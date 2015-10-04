//
//  UserCell.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/26.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol BingoUserItemAtMyList_delegate:NSObjectProtocol{
    func _needToTalk(__id:String)
    func _showUser(__index:Int)
}

class BingoUserItemAtMyList: UIView {
    var inited:Bool = false
    var _bgImg:PicView?
    var _signImg:PicView?
    var _nameLabel:UILabel?
    var _index:Int?
    var _id:String?
    weak var _delegate:BingoUserItemAtMyList_delegate?
    
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            //self.clipsToBounds = true
            _bgImg = PicView(frame:CGRect(x: 0, y: 0, width: __frame.width, height: __frame.width))
            _bgImg?.layer.cornerRadius = __frame.width/2
            _bgImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _bgImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _bgImg?.layer.borderWidth = 2
            addSubview(_bgImg!)
             //let _img:UIImageView = UIImageView(image: UIImage(named: "profile"))
            //addSubview(_img)
            
            let _r:CGFloat = __frame.width/6
            _signImg = PicView(frame:CGRect(x: __frame.width-2*_r, y: __frame.width-2*_r, width: 2*_r, height: 2*_r))
            _signImg?.layer.cornerRadius = _r
            _signImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _signImg?._setImage("icon_messageMe")
            addSubview(_signImg!)
            
            _nameLabel = UILabel(frame: CGRect(x: 0, y: __frame.width, width: __frame.width, height: __frame.height-__frame.width))
            _nameLabel?.textColor = UIColor.whiteColor()
            _nameLabel?.font = UIFont.systemFontOfSize(16)
            _nameLabel?.textAlignment = NSTextAlignment.Center
            
            addSubview(_nameLabel!)
            
            let _tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapHander:")
            _signImg!.addGestureRecognizer(_tap)
            
            let _tap_1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapHander:")
            _bgImg!.addGestureRecognizer(_tap_1)
            
            inited = true
        }
    }
    func tapHander(sender:UITapGestureRecognizer){
        switch sender.view!{
        case _bgImg!:
            _delegate?._showUser(_index!)
            break
        case _signImg!:
            _delegate?._needToTalk(_id!)
            break
        default:
            break
        }
        
    }
    func _setPic(__picUrl:String){
        
        _bgImg?._setImage(__picUrl)
        _bgImg?._refreshView()
    }
    func _setName(__str:String){
        _nameLabel?.text = __str
    }
    
}