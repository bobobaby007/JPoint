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
    static let _Type_Match:String = "_Type_Match"
    static let _Type_Message:String = "_Type_Message"
    static let _Type_Message_By_Me:String = "_Type_Message_By_Me"
    static let _Type_Time:String = "_Type_Time"
    var _timeLabel:UILabel?
    var _type:String?
    var _frame:CGRect?
    var _matchImg:PicView?
    var _matchLabel:UILabel?
    var _matchBackG:UIView?
    var _message_textView:UITextView?
    static let _messageTextFontSize:CGFloat = 16
    static let _messageTextMaxWidth:CGFloat = 220
    static let _messageTextPadding:CGFloat = 10
    
    func initWidthFrame(__frame:CGRect,__type:String){
        
        
        clear()
        
        if inited{
            
            
        }else{
            _frame = __frame
            
            _type = __type
            
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = false
            //self.selectedBackgroundView = UIView()
            self.selectionStyle = UITableViewCellSelectionStyle.None

            
            switch _type!{
            case MessageCell._Type_Match:
                
                
                _profileImg = PicView(frame:CGRect(x: 10, y: 0, width: 60, height: 60))
                _profileImg?.layer.cornerRadius = 30
                _profileImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
                _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
                _profileImg?.layer.borderWidth = 2
                addSubview(_profileImg!)
                _setPic("profile")

                
                
                _matchBackG = UIView(frame: CGRect(x: 75, y: 0, width: 190, height: 190))
                _matchBackG?.backgroundColor = UIColor(white: 1, alpha: 0.8)
                _matchBackG?.layer.cornerRadius = 15
                addSubview(_matchBackG!)
                
                let _uv:UIImageView = UIImageView(image: UIImage(named: "icon_bing_at_message.png"))
                _uv.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
                _uv.contentMode = UIViewContentMode.ScaleAspectFit
                
                _matchBackG?.addSubview(_uv)
                
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
                _message_textView?.layer.borderWidth = 1.5
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
                _timeLabel?.textColor = UIColor.whiteColor()
                _timeLabel?.textAlignment = NSTextAlignment.Center
                addSubview(_timeLabel!)
                break
            default:
                break
            }
            
          //  inited = true
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
        if _matchImg != nil{
            _matchImg?.removeFromSuperview()
        }
        if _matchLabel != nil{
            _matchLabel?.removeFromSuperview()
        }
        if _matchBackG != nil{
            _matchBackG?.removeFromSuperview()
        }
        if _message_textView != nil{
            _message_textView?.removeFromSuperview()
        }
        _profileImg = nil
        _timeLabel = nil
        _type = nil
        _frame = nil
        _matchImg = nil
        _matchLabel = nil
        _matchBackG = nil
        _message_textView = nil
    }
    
    func _setContent(__str:String){
        switch _type!{
        case MessageCell._Type_Match:
            //let fullNameArr = split(__str.characters){$0 == " "}.map(String.init)
            let _array:Array = __str.componentsSeparatedByString("||")
            
            _matchImg?._setImage(_array[0])
            
            _matchLabel?.text = _array[1]
            _matchLabel?.sizeToFit()
            _matchImg?._refreshView()
            break
        case MessageCell._Type_Message:
            _message_textView?.text = __str
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            _message_textView?.sizeToFit()
            break
        case MessageCell._Type_Message_By_Me:
            _message_textView?.text = __str
            _message_textView?.sizeToFit()
            _message_textView?.frame.origin = CGPoint(x: _frame!.width-_message_textView!.frame.width-5, y: 0)
            //_message_textView?.sizeThatFits(CGSize(width: 100, height: CGFloat.max))
            break
        case MessageCell._Type_Time:
            _timeLabel?.text = CoreAction._timeStr(__str)
            break
        default:
            break
        }
    }
    func _setPic(__picUrl:String){
        _profileImg?._setImage(__picUrl)
        _profileImg?._refreshView()
    }
    func _justSent(){
        _message_textView?.frame.origin = CGPoint(x: _frame!.width-5, y: _message_textView!.frame.height)
        _message_textView?.transform = CGAffineTransformMakeScale(0, 0)
        _message_textView?.backgroundColor = UIColor.clearColor()
        _message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
        _message_textView?.textColor = UIColor.whiteColor()
        _message_textView?.layer.borderWidth = 1.5
        UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._message_textView?.transform = CGAffineTransformMakeScale(1, 1)
            self._message_textView?.frame.origin = CGPoint(x: self._frame!.width-self._message_textView!.frame.width-5, y: 0)
            
            }) { (_complete) -> Void in
               self._sentOk()
        }
        
    }
    func _sentOk(){
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self._message_textView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
            // self._message_textView?.layer.borderColor = UIColor.whiteColor().CGColor
            self._message_textView?.layer.borderWidth = 0
            self._message_textView?.textColor = UIColor(red: 138/255, green: 120/255, blue: 200/255, alpha: 1)
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
       
        
        
        return _textV.frame.height+5
    }
    
}