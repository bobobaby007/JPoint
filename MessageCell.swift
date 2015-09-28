//
//  UserCell.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/26.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class MessageCell: UITableViewCell {
    var inited:Bool = false
    var _bgImg:PicView?
    
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            self.clipsToBounds = true
            _bgImg = PicView(frame:CGRect(x: 5, y: 5, width: 60, height: 60))
            _bgImg?.layer.cornerRadius = 30
            _bgImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            addSubview(_bgImg!)
            
            _setPic("profile")
            inited = true
        }
    }
    func _setPic(__picUrl:String){
        
        _bgImg?._setImage(__picUrl)
        _bgImg?._refreshView()
    }
    
}