//
//  UserCell.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/26.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

//-----------消息单元
class MessageCell: UITableViewCell {
    var inited:Bool = false
    var _profileImg:PicView?
    static let _Type_Bingo:String = "bingo"
    static let _Type_Welfare:String = "welfare"
    static let _Type_Message:String = "message"
    static let _Type_Message_By_Me:String = "me"
    static let _Type_Time:String = "time"
    var _timeLabel:UILabel?
    var _type:String?
    var _frame:CGRect?
    
    var _bingoItem:BingoItem?
    var _welfareItem:WelfareItem?
    
    var _message_textView:UITextView?
    var _tapG:UITapGestureRecognizer?
    var _bingoId:String? //-----用于查看bingo详情，未赋值
    
    static let _messageTextFontSize:CGFloat = 14
    static let _messageTextMaxWidth:CGFloat = 220
    static let _messageTextPadding:CGFloat = 6
    var _myDict:NSDictionary?
    var _isOpen:Bool=false
    var _picUrl:String?
    func initWidthFrame(__frame:CGRect,__type:String){
        _frame = __frame
        _type = __type
        if inited{
            
        }else{
            
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = false
            //self.selectedBackgroundView = UIView()
            self.selectionStyle = UITableViewCellSelectionStyle.None
            _tapG = UITapGestureRecognizer(target: self, action: "tapHander:")
            inited = true
        }
    }
    override func removeFromSuperview() {
        clear()
    }
    func clear() {
        if _profileImg != nil{
            _profileImg?.removeFromSuperview()
        }
        if _timeLabel != nil{
            _timeLabel?.removeFromSuperview()
        }
        if _bingoItem != nil{
            _bingoItem?.removeFromSuperview()
        }
        if _welfareItem != nil{
            _welfareItem?.removeFromSuperview()
        }
        if _message_textView != nil{
            _message_textView?.removeFromSuperview()
        }
        _profileImg = nil
        _timeLabel = nil
        //_type = nil
        //_frame = nil
        _message_textView = nil
    }
    //-----清空内容便于重来
    func reset(){
        clear()
        switch _type!{
        case MessageCell._Type_Bingo:
            
            break
        case MessageCell._Type_Message:
            _message_textView = UITextView(frame: CGRect(x: 80, y: 0, width:MessageCell._messageTextMaxWidth, height: 50))
            _message_textView?.textContainerInset = UIEdgeInsets(top: MessageCell._messageTextPadding, left: MessageCell._messageTextPadding, bottom: MessageCell._messageTextPadding, right: MessageCell._messageTextPadding)
            _message_textView?.textColor = UIColor.whiteColor()
            _message_textView?.textAlignment = NSTextAlignment.Left
            _message_textView?.layer.cornerRadius = 15
            _message_textView?.clipsToBounds = true
            _message_textView?.editable = false
            _message_textView?.scrollEnabled = false
            _message_textView?.backgroundColor = UIColor.clearColor()
            _message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
            _message_textView?.layer.borderWidth = 1
            _message_textView?.font = UIFont.systemFontOfSize(MessageCell._messageTextFontSize)
            addSubview(_message_textView!)
            break
        case MessageCell._Type_Message_By_Me:
            _message_textView = UITextView(frame: CGRect(x:_frame!.width-280, y: 0, width: MessageCell._messageTextMaxWidth, height: 50))
            _message_textView?.textContainerInset = UIEdgeInsets(top: MessageCell._messageTextPadding, left: MessageCell._messageTextPadding, bottom: MessageCell._messageTextPadding, right: MessageCell._messageTextPadding)
            _message_textView?.textColor = UIColor(red: 138/255, green: 120/255, blue: 200/255, alpha: 1)
            _message_textView?.textAlignment = NSTextAlignment.Left
            _message_textView?.layer.cornerRadius = 15
            _message_textView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
            _message_textView?.clipsToBounds = true
            _message_textView?.font = UIFont.systemFontOfSize(MessageCell._messageTextFontSize)
            _message_textView?.editable = false
            _message_textView?.scrollEnabled = false
            addSubview(_message_textView!)
            break
        case MessageCell._Type_Time:
            _timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: _frame!.width, height: 25))
            _timeLabel?.font = UIFont.systemFontOfSize(12)
            _timeLabel?.textColor = UIColor(white: 1, alpha: 0.5)
            _timeLabel?.textAlignment = NSTextAlignment.Center
            addSubview(_timeLabel!)
            break
        default:
            break
        }
    }
    func _setSex(__set:Int){
        if _profileImg == nil{
            return
        }
        switch __set{
        case 0:
            _profileImg?.layer.borderColor = Config._color_sex_female.CGColor
            _message_textView?.layer.borderColor = Config._color_sex_female.CGColor
            break
        case 1:
            _profileImg?.layer.borderColor = Config._color_sex_male.CGColor
            _message_textView?.layer.borderColor = Config._color_sex_male.CGColor
            break
            
        default:
            _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
            break
        }
    }
    //--判断用户是否自己,同时设置头像,头像颜色
    func _userIsMe(__dict:NSDictionary)->Bool{
        var _is:Bool = false
        if let _author:NSDictionary = __dict.objectForKey("author") as? NSDictionary{
            if _author.objectForKey("_id") as! String == MainAction._profileDict?.objectForKey("_id") as! String{
                _is = true
            }else{
                self._setPic(MainAction._avatar(_author))
            }
            _setSex(MainAction._sex(_author))
        }
        return _is
    }
    func _setContent(__dict:NSDictionary){
        switch _type!{
        case MessageCell._Type_Bingo:
                self._bingoItem = BingoItem(frame: CGRect(x: 75, y: 0, width: 190, height: 190))
                self.addSubview(self._bingoItem!)
                _bingoItem?._setContent(__dict.objectForKey("message") as! String)
                if _userIsMe(__dict){
                    self._bingoItem?.frame.origin.x = _frame!.width-190-5
                }else{
                    
                }
            break
        case MessageCell._Type_Welfare:
            
                self._welfareItem = WelfareItem(frame: CGRect(x: 75, y: 0, width: 190, height: 190))
                self.addSubview(self._welfareItem!)
                _welfareItem?._setContent(__dict.objectForKey("message") as! String)
                if _userIsMe(__dict){
                    self._welfareItem?.frame.origin.x = _frame!.width-190-5
                }else{
                    
                }
            break
        case MessageCell._Type_Message:
            _message_textView?.text = __dict.objectForKey("message") as! String
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            _message_textView?.sizeToFit()
            if _message_textView?.frame.height < 60{
                _message_textView?.frame.origin.y =  (60 - _message_textView!.frame.height)/2
            }
            _userIsMe(__dict)
            break
        case MessageCell._Type_Message_By_Me:
            _message_textView?.text = __dict.objectForKey("message") as! String
            _message_textView?.sizeToFit()
            _message_textView?.frame.origin = CGPoint(x: _frame!.width-_message_textView!.frame.width-5, y: 0)
            _userIsMe(__dict)
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            break
        case MessageCell._Type_Time:
            _timeLabel?.text = CoreAction._dateDiff(__dict.objectForKey("time") as! String)
            break
        default:
            break
        }
        
    }
    //----大的字典，type类型包含在外面，由本地生成，content是接受自服务器的消息整个字典
    /*
    {
    content = {
    time = "2016-02-05T09:38:41.294Z";
    };
    height = 30;
    type = time;
    }
    其他
    {
    content =     {
    "__v" = 0;
    "_id" = 56b46da1e3c33d17001dfa8f;
    author =         {
    "_id" = 56ad83466db9cb10003d19f2;
    avatar = "avatar/image-1454300671510-2047.png";
    checkbingo = 184;
    checkl = 0;
    checkm = 0;
    checkright = 106;
    clickme = 32;
    clickright = 26;
    "create_at" = "2016-01-31T03:45:10.349Z";
    "login_at" = "2016-02-05T11:05:40.562Z";
    nickname = "\U963fB";
    "online_time" = 0;
    sendbingo = 14;
    sex = 1;
    socket = "";
    };
    "create_at" = "2016-02-05T09:38:41.294Z";
    message = "\U597d\U68d2\U54c8";
    readed = 1;
    to =         {
    "_id" = 56ada84c8ddd2c1400b63326;
    avatar = "avatar/image-1454297469387-1807.png";
    checkbingo = 53;
    checkl = 0;
    checkm = 0;
    checkright = 30;
    clickme = 44;
    clickright = 38;
    "create_at" = "2016-01-31T06:23:08.833Z";
    "login_at" = "2016-02-05T11:26:01.782Z";
    nickname = Marry;
    "online_time" = 0;
    sendbingo = 12;
    sex = 0;
    socket = qbqITV2m2qKfvzObAABN;
    };
    type = message;
    };
    height = 80;
    type = message;
    }

    */
    
    func _setDict(__dict:NSDictionary){
        _myDict = __dict
        print("我的消息：",__dict)
        reset()
        _setContent(__dict.objectForKey("content") as! NSDictionary)
        

    }
    
    
    func _setPic(__picUrl:String){
        _picUrl = __picUrl
        if _profileImg == nil{
            _profileImg = PicView(frame:CGRect(x: 10, y: 0, width: 60, height: 60))
            _profileImg?.layer.cornerRadius = 30
            _profileImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _profileImg?.layer.borderWidth = 2
            _profileImg?.addGestureRecognizer(_tapG!)
        }
        addSubview(_profileImg!)
        
        _profileImg?._loadImage(_picUrl!+"@!small")
        
        
        //_profileImg?._refreshView()
    }
    
    //------点击头像图片打开查看大图
    
    func tapHander(sender:UITapGestureRecognizer){
        if _isOpen{
            _closeImage()
        }else{
            _openImage()
        }
        
    }
    func _openImage(){
        UIApplication.sharedApplication().statusBarHidden = true
        _profileImg?.backgroundColor = UIColor.blackColor()
        _profileImg?._scaleType = PicView._ScaleType_Fit
        ViewController._self?._shouldPan = false
        _profileImg?.layer.borderWidth = 0
        
        _profileImg?._loadImage(_picUrl!)
        
        _profileImg?._move(self, __fromRect: _profileImg!.frame, __toView: MessageWindow._self!.view, __toRect: MessageWindow._self!.view.frame, __then: { () -> Void in
            self._profileImg!.layer.cornerRadius = 0
            self._profileImg!.scrollEnabled = true
            self._isOpen = true
        })
    }
    func _closeImage(){
        UIApplication.sharedApplication().statusBarHidden = false
        _profileImg?.backgroundColor = UIColor.clearColor()
        _profileImg?._scaleType = PicView._ScaleType_Full
        self._profileImg!.layer.cornerRadius = 30
        _profileImg?._back(MessageWindow._self!.view, __toView: self, __toRect: CGRect(x: 10, y: 0, width: 60, height: 60), __then: { () -> Void in
            
            self._profileImg!.scrollEnabled = false
            self._profileImg!.layer.borderWidth = 2
            self._isOpen = false
            ViewController._self?._shouldPan = true
        })
    }
    
    
    
    func _justSent(){
        switch _type!{
        case MessageCell._Type_Bingo:
            
            break
        case MessageCell._Type_Message:
            _animationOfMessage()
            break
        case MessageCell._Type_Message_By_Me:
            _animationOfMessageByMe()
            break
        case MessageCell._Type_Time:
            
            break
        default:
            break
        }
        
    }
    
    
    
    
    
    func _animationOfMessageByMe(){
        _message_textView?.frame.origin = CGPoint(x: _frame!.width-5, y: _message_textView!.frame.height)
        _message_textView?.transform = CGAffineTransformMakeScale(0, 0)
        _message_textView?.backgroundColor = UIColor.clearColor()
        _message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
        _message_textView?.textColor = UIColor.whiteColor()
        _message_textView?.layer.borderWidth = 1.5
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._message_textView?.transform = CGAffineTransformMakeScale(1, 1)
            self._message_textView?.frame.origin = CGPoint(x: self._frame!.width-self._message_textView!.frame.width-5, y: 0)
            }) { (_complete) -> Void in
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self._message_textView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
                    // self._message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
                    self._message_textView?.layer.borderWidth = 0
                    self._message_textView?.textColor = UIColor(red: 138/255, green: 120/255, blue: 200/255, alpha: 1)
                    }) { (_complete) -> Void in
                        
                }
        }
    }
    
    
    
    
    func _animationOfMessage(){
        _message_textView?.frame.origin = CGPoint(x: -80, y: _message_textView!.frame.origin.y)
        _message_textView?.sizeToFit()
        
        let _h:CGFloat = _message_textView!.frame.height
        var _y:CGFloat = 0
        if _h < 60{
            _y =  (60 - _h)/2
        }
        _message_textView?.transform = CGAffineTransformMakeScale(0, 0)
        _profileImg?.transform = CGAffineTransformMakeScale(0, 0)
        _profileImg?.alpha = 0
        //_message_textView?.backgroundColor = UIColor.clearColor()
        //_message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
        // _message_textView?.textColor = UIColor.whiteColor()
        //_message_textView?.layer.borderWidth = 1.5
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._message_textView?.transform = CGAffineTransformMakeScale(1, 1)
            self._message_textView?.frame.origin = CGPoint(x: 80, y: _y)
            self._profileImg?.transform = CGAffineTransformMakeScale(1, 1)
            self._profileImg?.alpha = 1
            }) { (_complete) -> Void in
                
        }
    }
    static func _getHighByStr(__str:String)->CGFloat{
        //CGSize size = [myLabel sizeThatFits:CGSizeMake(myLabel.frame.size.width, CGFLOAT_MAX)];
        //let _font:UIFont = UIFont.systemFontOfSize(12)
        //let _size:CGSize = NSString(string: __str).sizeWithAttributes([NSFontAttributeName:_font])
       // let _size:CGRect = NSString(string: __str).boundingRectWithSize(CGSize(width: 100, height: 1000), options: NSStringDrawingContext, attributes: <#T##[String : AnyObject]?#>, context: <#T##NSStringDrawingContext?#>)
        
        let _textV:UITextView  = UITextView(frame: CGRect(x: 80, y: 0, width:MessageCell._messageTextMaxWidth, height: 50))
        _textV.textContainerInset = UIEdgeInsets(top: MessageCell._messageTextPadding, left: MessageCell._messageTextPadding, bottom: MessageCell._messageTextPadding, right: MessageCell._messageTextPadding)
        
        _textV.textAlignment = NSTextAlignment.Left
        
        _textV.font = UIFont.systemFontOfSize(MessageCell._messageTextFontSize)
        _textV.text = __str
        _textV.sizeToFit()
       
        
        
        return _textV.frame.height+10
    }
    
}