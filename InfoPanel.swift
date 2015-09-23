//
//  InfoPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/2.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class InfoPanel:UIView {
    var _icon_time:UIImageView?
    var _icon_click:UIImageView?
    var _icon_like:UIImageView?
    var _timeL:UILabel?
    var _clickL:UILabel?
    var _likeL:UILabel?
    
    
    var _likeNum:Int?
    var _clickNum:Int?
    let _IconW:CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _icon_time = UIImageView(image: UIImage(named: "time_icon.png"))
        _icon_time?.frame = CGRect(x: 5, y: 0, width: _IconW, height: _IconW)
        _timeL = UILabel(frame: CGRect(x: _icon_time!.frame.origin.x+_IconW+5, y: 0, width: 100, height: _IconW))
        _timeL?.font = UIFont.systemFontOfSize(12)
        _timeL?.textColor = UIColor.whiteColor()
        
        _icon_click = UIImageView(image: UIImage(named: "click_icon.png"))
        _icon_click?.frame = CGRect(x: frame.width-150, y: 0, width: _IconW, height: _IconW)
        _clickL = UILabel(frame: CGRect(x: _icon_click!.frame.origin.x+_IconW+5, y: 0, width: 60, height: _IconW))
        _clickL?.font = UIFont.systemFontOfSize(12)
        _clickL?.textColor = UIColor.whiteColor()
        
        _icon_like = UIImageView(image: UIImage(named: "like_icon.png"))
        _icon_like?.frame = CGRect(x: frame.width-60, y: 0, width: _IconW, height: _IconW)
        _likeL = UILabel(frame: CGRect(x: _icon_like!.frame.origin.x+_IconW+5, y: 0, width: 60, height: _IconW))
        _likeL?.font = UIFont.systemFontOfSize(12)
        _likeL?.textColor = UIColor.whiteColor()
        
        addSubview(_icon_time!)
        addSubview(_timeL!)
        addSubview(_icon_click!)
        addSubview(_clickL!)
        addSubview(_icon_like!)
        addSubview(_likeL!)
        
    }
    func _setTime(__timer:String){
        _timeL?.text=__timer
    }
    func _setClick(__num:Int){
        _clickNum = __num
        _clickL?.text=String(__num)
    }
    func _setLike(__num:Int){
        _likeNum = __num
        _likeL?.text=String(__num)
    }
    func _addOneClick(){
        ++_clickNum!
        _setClick(_clickNum!)
    }
    func _addOneLike(){
        ++_likeNum!
        _setLike(_likeNum!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
