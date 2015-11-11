//
//  ChatCell.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/28.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    var inited:Bool = false
    var _profileImg:PicView?
    var _bgColorV:UIView?
    var _nameLabel:UILabel?
    var _contentLabel:UILabel?
    var _uid:String?
    
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            
            
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = true
            
//            _bgColorV = UIView(frame: CGRect(x: 5, y: 5, width: __frame.width-10, height: 60))
//            _bgColorV?.backgroundColor = UIColor(white: 0, alpha: 0.2)
//            _bgColorV?.layer.cornerRadius = 30
            self.selectedBackgroundView?.backgroundColor = UIColor.clearColor()
            
            //addSubview(_bgColorV!)
            
            _profileImg = PicView(frame:CGRect(x: 10, y: 22, width: 65, height: 65))
            _profileImg?.layer.cornerRadius = 32.5
            _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _profileImg?.layer.borderWidth = 2
            _profileImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            
            addSubview(_profileImg!)
            
            _nameLabel = UILabel(frame: CGRect(x: 90, y: 30, width: __frame.width, height: 22))
            _nameLabel?.textColor = UIColor.whiteColor()
            _nameLabel?.font = UIFont.boldSystemFontOfSize(16)
            
            addSubview(_nameLabel!)
            
            _contentLabel = UILabel(frame: CGRect(x: 90, y: 60, width: __frame.width, height: 20))
            _contentLabel?.textColor = UIColor.whiteColor()
            _contentLabel?.font = UIFont.systemFontOfSize(13)
            addSubview(_contentLabel!)
            //_setPic("profile")
            inited = true
        }
    }
    
//    override func setSelected(selected: Bool, animated: Bool) {
//       
//    }
    func _setId(__id:String){
        _uid = __id
    }
    func _setName(__name:String){
        _nameLabel?.text = __name
    }
    func _setContent(__str:String){
        _contentLabel?.text = __str
    }
    func _setPic(__picUrl:String){
        
        _profileImg?._setPic(NSDictionary(objects: [__picUrl,"file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            
        })
        
    }
//    override func setHighlighted(highlighted: Bool, animated: Bool) {
//        
//    }
    
}
