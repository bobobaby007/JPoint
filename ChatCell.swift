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
    var _alertSign:UIView?
    var _myFrame:CGRect?
    var _bingoIcon:UIImageView?
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            _myFrame = __frame
            
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
            
            _contentLabel = UILabel(frame: CGRect(x: 90, y: 60, width: __frame.width-90-60, height: 20))
            _contentLabel?.textColor = UIColor.whiteColor()
            _contentLabel?.font = UIFont.systemFontOfSize(13)
            addSubview(_contentLabel!)
            
            
            
            _bingoIcon = UIImageView(image: UIImage(named: "icon_bing_at_message.png"))
            _bingoIcon?.backgroundColor = UIColor.clearColor()
            _bingoIcon?.frame = CGRect(x: 45, y: 38, width: 160, height: 50)
            _bingoIcon?.contentMode = UIViewContentMode.ScaleAspectFit
            
            addSubview(_bingoIcon!)
            //_setPic("profile")
            inited = true
        }
    }
    
//    override func setSelected(selected: Bool, animated: Bool) {
//       
//    }
    func _setDict(_dict:NSDictionary){
        let _type:String = _dict.objectForKey("type") as! String
        
        var _content:String = _dict.objectForKey("content") as! String
        _bingoIcon?.hidden = true
        
        
        switch _type{
        case MessageCell._Type_Bingo:
            _content = ""
            _bingoIcon?.hidden = false
            break
        case MessageCell._Type_Bingo_By_Me:
            _content = ""
            _bingoIcon?.hidden = false
            break
        default:
            break
        }
        
        _setId(_dict.objectForKey("uid") as! String)
        _setPic(_dict.objectForKey("image") as! String)
        _setName(_dict.objectForKey("nickname") as! String)
        _setContent(_content)
    
        if let _isNew:Bool = _dict.objectForKey("isnew") as? Bool{
            _setAlert(_isNew)
        }else{
            _setAlert(false)
        }
    }
    
    func _setAlert(__has:Bool){
        if __has{
            if _alertSign == nil{
               _alertSign = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                _alertSign?.backgroundColor = MainAction._MyColor
                _alertSign?.layer.borderColor = UIColor.whiteColor().CGColor
                _alertSign?.layer.borderWidth = 2
                _alertSign?.layer.cornerRadius = 10
                _alertSign?.center = CGPoint(x: _myFrame!.width-60, y: _profileImg!.center.y)
            }
            addSubview(_alertSign!)
        }else{
            if _alertSign != nil{
                _alertSign?.removeFromSuperview()
                _alertSign = nil
            }
        }
    }
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
