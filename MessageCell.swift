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
    static let _Type_Bingo_By_Me = "_Type_Bingo_By_Me"
    static let _Type_Message:String = "message"
    static let _Type_Message_By_Me:String = "me"
    static let _Type_Time:String = "time"
    var _timeLabel:UILabel?
    var _type:String?
    var _frame:CGRect?
    
    var _bingoItem:BingoItem?
    var _welfareItem:WelfareItem?
    
    var _message_textView:UITextView?
    
    var _bingoId:String? //-----用于查看bingo详情，未赋值
    
    static let _messageTextFontSize:CGFloat = 14
    static let _messageTextMaxWidth:CGFloat = 220
    static let _messageTextPadding:CGFloat = 6
    
    func initWidthFrame(__frame:CGRect,__type:String){
        _frame = __frame
        _type = __type
        if inited{
            
        }else{
            
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = false
            //self.selectedBackgroundView = UIView()
            self.selectionStyle = UITableViewCellSelectionStyle.None
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
    
    func reset(){
        clear()
        switch _type!{
        case MessageCell._Type_Bingo:
            _profileImg = PicView(frame:CGRect(x: 10, y: 0, width: 60, height: 60))
            _profileImg?.layer.cornerRadius = 30
            _profileImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _profileImg?.layer.borderWidth = 2
            addSubview(_profileImg!)
            break
            
        case MessageCell._Type_Bingo_By_Me:
            
            break
        case MessageCell._Type_Message:
            _profileImg = PicView(frame:CGRect(x: 10, y: 0, width: 60, height: 60))
            _profileImg?.layer.cornerRadius = 30
            _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
            _profileImg?.layer.borderWidth = 2
            _profileImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            addSubview(_profileImg!)
            _setPic("profile")
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
    func _setContent(__dict:NSDictionary){
        switch _type!{
        case MessageCell._Type_Bingo:
                self._bingoItem = BingoItem(frame: CGRect(x: 75, y: 0, width: 190, height: 190))
                self.addSubview(self._bingoItem!)
                _bingoItem?._setContent(__dict.objectForKey("message") as! String)
            break
        case MessageCell._Type_Welfare:
                self._welfareItem = WelfareItem(frame: CGRect(x: 75, y: 0, width: 190, height: 190))
                self.addSubview(self._welfareItem!)
                _welfareItem?._setContent(__dict.objectForKey("message") as! String)
            break
            
        case MessageCell._Type_Bingo_By_Me:
            self._bingoItem = BingoItem(frame: CGRect(x: _frame!.width-190-5, y: 0, width: 190, height: 190))
            self.addSubview(self._bingoItem!)
            _bingoItem?._setContent(__dict.objectForKey("message") as! String)
            break
        case MessageCell._Type_Message:
            _message_textView?.text = __dict.objectForKey("message") as! String
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            _message_textView?.sizeToFit()
            if _message_textView?.frame.height < 60{
                _message_textView?.frame.origin.y =  (60 - _message_textView!.frame.height)/2
            }
            break
        case MessageCell._Type_Message_By_Me:
            _message_textView?.text = __dict.objectForKey("message") as! String
            _message_textView?.sizeToFit()
            _message_textView?.frame.origin = CGPoint(x: _frame!.width-_message_textView!.frame.width-5, y: 0)
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            break
        case MessageCell._Type_Time:
            _timeLabel?.text = CoreAction._dateDiff(__dict.objectForKey("time") as! String)
            break
        default:
            break
        }
        
        if let _from:NSDictionary = __dict.objectForKey("author") as? NSDictionary{
            _setSex(MainAction._sex(_from))
        }
    }
    
    func _setDict(__dict:NSDictionary){
        
        print("我的消息：",__dict)
        reset()
        
        _setContent(__dict.objectForKey("content") as! NSDictionary)
        
    }
    
    
    func _setPic(__picUrl:String){
        _profileImg?._setPic(NSDictionary(objects: [__picUrl,"file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            
        })
        //_profileImg?._refreshView()
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