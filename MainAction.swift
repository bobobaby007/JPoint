//
//  MainAction.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/13.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class MainAction {
    static var _tokenDefault:String?
    static var _location:String?
    static var _token:String{
        get{
            if _tokenDefault != nil{
                return _tokenDefault!
            }else{
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if let _tok:String = _ud.valueForKey("token") as? String {
                _tokenDefault = _tok
                return _tokenDefault!
                }
            }
            return ""
        }
        set{
            _tokenDefault = newValue
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_tokenDefault!, forKey: "token")
        }
    }
    
    static let _versionString:String = "1.06" //-----本地app版本号，注意更新，以便提醒用户更新
    
    //static let _BasicDomain:String = "http://192.168.1.108:9999" //"http://192.168.1.108:9999" // "http://bingome.giccoo.com"//---
    static let _BasicDomain:String = "http://bingome.giccoo.com"
    //static let _URL_Socket:String = "http://192.168.1.108:9999"//"http://bingome.giccoo.com"  //http://192.168.1.108:9999   http://bingome.giccoo.com
    static let _URL_Socket:String = "http://bingome.giccoo.com"
    static let _Version:String = "v1" //----服务器后台版本号
    
    static let _URL_GetVersion = "config/version" //---获取当前在线app版本地址
    static let _URL_PostBingo:String = "bingo/send/"//---发布图片地址
    
    static let _URL_BingoList:String = "bingo/list/"//----获取首页列表
    static let _URL_BingoInfo:String = "bingo/info/"//---Bingo详情
    static let _URL_Welfare:String = "bingo/welfare/"//---Bingo详情
    static let _URL_BingoReaded:String = "bingo/read/"//---已读图,标记为已读
    static let _URL_ClearReadRecord:String = "bingo/empty/"//-----清空我的阅读记录
    
    static let _URL_MyImageList:String = "my/list/"//－－－我的图列
    static let _URL_RemoveImage:String = "my/bingoRemove/"//－－－删除我的图
    
    
    static let _URL_MyImageDetail = "my/bingo/" //--- 我的图列详情
    static let _URL_MyImageClicks = "my/bingos/" //--- 我的图的所有点击
    static let _URL_Sent_Bingo:String = "bingo/check/"//----发送bingo地址
    static let _URL_Signup:String = "sign/up/" //----注册地址
    static let _URL_Login:String = "sign/in/"//登录地址
    static let _URL_Sms:String = "sign/sms/"//获取验证码
    static let _URL_changePassword:String = "sign/changePassword/"//修改密码
    static let _URL_CheckNewMessage:String = "message/unread/"//获取未读消息
    static let _URL_ChatHistory:String = "message/log/"//聊天记录
    static let _URL_BingoHistoryOfFriend:String = "message/bingo/"//好友对我的bingo记录
    static let _URL_MyProfile:String = "my/"
    static let _URL_ChangeMyProfile:String = "my/info/"
    static let _URL_ChangeMyAvatar:String = "my/avatar/"//----修改头像
    static let _URL_Report:String = "report/bingo/"//---举报
    static let _URL_FriendsList:String = "my/friends/"//获取好友列表
    
    
    
    static let _Post_Type_Media:String = "Media"
    static let _Post_Type_Camera:String = "Camera"
    static var _BingoList:NSArray = []   //首页列表
    static var _MyImageList:NSArray = [] //我的图列数组
    static var _ChatsList:NSArray?//---bingo聊天列表
    static var _profileDict:NSDictionary?{
        didSet{
            CoreAction._saveDictToFile(_profileDict!, __fileName: "Profile")
        }
    }
    //static var _userInfo:NSMutableDictionary?
    static var _socket:SocketIOClient?
    
    static var _Prefix_Chat:String = "chatHistory_" //----聊天记录文件名前缀
    static var _Name_BingoChatsList = "BingoChatsList" //----聊天记录列表文件名
    
    static var _Notification_new_chat:String = "Notification_new_chat"//新的聊天消息
    static var _Notification_new_bingo:String = "Notification_new_bingo"//新的bingo
    static var _Notification_chatChanged:String = "Notification_chatChanged"//---消息列表有变化
    static var _Notification_logOk:String = "Notification_logOk"//---登录成功
    static var _Notification_getProfileOk:String = "Notification_getProfileOk"//---获取在线用户信息完成
    static var _Notification_needToLog:String = "Notification_needToLog"//---需要登录
    
    static var _MyColor:UIColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 1)
    
    static var _locationPoint:CGPoint = CGPoint(x:40.0425210400253, y:116.407341003954) //--默认地理位置  loc = lng,lat
    
    //----一般处理访问链接错误相应
    static func _checkRespon(__dict:NSDictionary)->Bool{
        let recode:Int = __dict.objectForKey("recode") as! Int
        if recode == 202{
                NSNotificationCenter.defaultCenter().postNotificationName(MainAction._Notification_needToLog, object: nil)
            return false
        }
        return true
    }
    
    //----获取版本号
    static func _getVersion(__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("myVersion=\(_versionString)", __url: _BasicDomain+"/"+_Version+"/"+_URL_GetVersion) { (__dict) -> Void in
            print("在线版本号：",__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                
            }
            __block(__dict)
        }
    }
    
    //-----判断是否登录
    static func _isLogined()->Bool{
        if _token == ""{
                return false
            }else{
                return true
        }
        
    }
    //-----注册－－手机号注册
    static func _signup(__mob:String,__code:String, __pass:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("type=default&mobile=\(__mob)&password=\(__pass)&code=\(__code)", __url: _BasicDomain+"/"+_Version+"/"+_URL_Signup) { (__dict) -> Void in
            print("手机号注册:",__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _user:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                _token = _user.objectForKey("token") as! String
                 _profileDict = _user
            }
            __block(__dict)
        }
    }
    
    //-----登录
    static func _login(__mob:String, __pass:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&password=\(__pass)", __url: _BasicDomain+"/"+_Version+"/"+_URL_Login ) { (__dict) -> Void in
            print("登录成功：",__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _user:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                _token = _user.objectForKey("token") as! String
                _profileDict = _user
            }
            __block(__dict)
        }
    }
    
    //-----修改密码
    static func _changePassword(__mob:String,__code:String, __pass:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("type=default&mobile=\(__mob)&password=\(__pass)&code=\(__code)", __url: _BasicDomain+"/"+_Version+"/"+_URL_changePassword) { (__dict) -> Void in
            print("修改密码:",__dict)
            __block(__dict)
        }
    }
    
    //----退出登录
    static func _logOut(){
        _token = ""
        _ChatsList=nil
       // CoreAction._copyDefaultFile(_Name_BingoChatsList, __toFile: _Name_BingoChatsList)
    }
    //----判断用户是否OK，需要设置用户信息
    static func _checkUserOk()->String{
        var _str:String = ""
        if let nickname = _profileDict?.objectForKey("nickname") as? String{
            if nickname == ""{
                _str = _str + "你需要一个昵称"
            }
        }
        
        if let avatar = _profileDict?.objectForKey("avatar") as? String{
            if avatar == ""{
                if _str != ""{
                    _str = _str + "\n"
                }
                _str = _str + "还需要一个头像，让大家认识你"
            }
        }
        return _str
    }
    //-----获取验证码
    static func _getSms(__mob:String,__type:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&type=\(__type)", __url: _BasicDomain+"/"+_Version+"/"+_URL_Sms ) { (__dict) -> Void in
            print("获取验证码：",__dict)
            __block(__dict)
        }
    }
    
    //------快速注册---取消
    static func _signupQuick(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Signup
        let postString : String = "type=quick" + "&openid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                let _info:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                //_userInfo = NSMutableDictionary(dictionary: _info)
                _token = _info.objectForKey("token") as! String
               
                __block(__dict)
            }else{
                if recode>0{
                    _signupQuick({ (__dict) -> Void in
                        __block(__dict)
                    })
                }
            }
        }
    }
    //------快速登录－－－取消
    static func _loginQuick(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Login
        let postString : String = "type=quick" + "&openid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                let _info:NSDictionary = __dict.objectForKey("info") as! NSDictionary
               // _userInfo = NSMutableDictionary(dictionary: _info)
                _token = _info.objectForKey("token") as! String
               
                __block(__dict)
            }else{
                if recode>0{
                    _signupQuick({ (__dict) -> Void in
                        __block(__dict)
                    })
            }
          }
        }
    }
    
    
    
    //-----socket
    static func _soketConnect(){
        if _socket == nil{
            _socket = SocketIOClient(socketURL: _URL_Socket, options: [.Log(true), .ForcePolling(true)])
            _socket!.on("connect") {data, ack in
                print("socket connected")
                _socket!.emit("login", NSDictionary(objects: [MainAction._token], forKeys: ["token"]))
            }
            _socket!.on("disconnect") {data, ack in
                print("socket disconnect")
                //_soketConnect()
                _socket!.connect()
                //
            }
            _socket!.on("login") {data, ack in
                print(data[0])
            }
            _socket!.on("message") {data, ack in
                print("接收到 message:",data[0])
                _receiveOneChat(data[0] as! NSDictionary)
            }
            _socket!.on("bingo") {data, ack in
                print("接收到 bingo:",data[0])
                _receiveBingo(data[0] as! NSDictionary)
            }
        }
        _socket!.connect()
    }
    
    static func _soketLogOut(){
        if _socket != nil{
            _socket?.close()
        }
        
    }
    
    
    
    //-----获取首页列表
    static func _getBingoList(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_BingoList
        let postString : String = "token=" + _token + "&loc=\(MainAction._locationPoint.x),\(MainAction._locationPoint.y)"
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                _BingoList = __dict.objectForKey("info") as! NSArray
            }else{
             
            }
            print("首页列表:",__dict)
            __block(__dict)
        }
    }
    
    //----标记为已读
    
    static func _readedBingo(__bingoId:String,__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_BingoReaded
        let postString : String = "token=" + _token + "&reads=\(__bingoId)"
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            __block(__dict)
        }
    }
     //----bingo详情
    
    static func _getBingoInfo(__bingoId:String,__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_BingoInfo + __bingoId
        
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            __block(__dict)
        }
    }

    
    
    //----清空我的阅读记录＝＝＝＝＝＝＝＝＝＝＝＝＝正式上线需去掉调用
    static func _clearMyReadRecord(){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_ClearReadRecord
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //__block(__dict)
        }
    }
    //-----获取我的好友列表
    static func _getMyFriends(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_FriendsList
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
               MainAction._dealWidthFriendsList(__dict)
            }else{
                
            }
            __block(__dict)
        }
    }
    
    //------处理好友列表,套上固定格式
    static func _dealWidthFriendsList(__dict:NSDictionary){
        let _friends:NSArray = __dict.objectForKey("info") as! NSArray
        
        let _arr:NSMutableArray = []
        
        for var i:Int = 0; i<_friends.count; ++i{
            let _friend:NSDictionary = _friends.objectAtIndex(i) as! NSDictionary
            //_arr.addObject(_friend)
            _arr.insertObject(NSDictionary(objects: [_friend.objectForKey("_id") as! String,MessageCell._Type_Message,"",MainAction._nickName(_friend),MainAction._avatar(_friend)], forKeys: ["uid","type","content","nickname","image"]), atIndex: 0)
        }
         _ChatsList = _arr
    }
    
    //-----获取未读消息
    static func _getNewMessages(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_CheckNewMessage
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //_checkRespon(__dict)
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                 MainAction._recievedNewMessages(__dict)
            }else{
                
            }
            //__block(__dict)
        }
    }
    //------获取完新消息后处理
    static func _recievedNewMessages(__dict:NSDictionary){
        let _messages:NSArray = __dict.objectForKey("info") as! NSArray
        for var i:Int = 0; i<_messages.count; ++i{
            
            let _message:NSDictionary = _messages.objectAtIndex(_messages.count-i-1) as! NSDictionary
            let _from:NSDictionary = _message.objectForKey("author") as! NSDictionary
            
            if let ___dict:NSDictionary = NSDictionary(objects: [_from.objectForKey("_id")!,_message.objectForKey("type") as! String,_message.objectForKey("message")!,_message.objectForKey("create_at")!], forKeys: ["uid","type","content","time"]){
                //_saveOneChat(___dict)
               // print("收到消息：",__dict)
                _addToBingoList(_from.objectForKey("_id") as! String, __type: _message.objectForKey("type") as! String, __content: _message.objectForKey("message") as! String, __nickname:MainAction._nickName(_from), __avatar: MainAction._avatar(_from),__isNew: true)
                
                NSNotificationCenter.defaultCenter().postNotificationName(_Notification_new_chat, object: nil, userInfo:___dict as [NSObject : AnyObject])
            }
        }
    }
    //-----获取我的图列
    static func _getMyImageList(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_MyImageList
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //print(__dict.objectForKey("reason"))
            
            _checkRespon(__dict)
            
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                //_MyImageList = __dict.objectForKey("info") as! NSArray
                
            }else{
                
            }
            __block(__dict)
        }
    }
    
    
    
    //-----删除我的图
    static func _removeImage(__picId:String, __block:(NSDictionary)->Void){
        //__block(NSDictionary())
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_RemoveImage
        let postString : String = "token=" + _token + "&bingo=" + __picId
        // print(postString)
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            _checkRespon(__dict)
            __block(__dict)
        }
    }
    //-----获取图列详情
    static func _getImageDetails(__picId:String, __block:(NSDictionary)->Void){
        //__block(NSDictionary())
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_MyImageDetail
        let postString : String = "token=" + _token + "&bingo=" + __picId
       // print(postString)
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            __block(__dict)
        }
    }
    //-----获取我的图片的所有点击
    static func _getImageAllClicks(__picId:String, __block:(NSDictionary)->Void){
        //__block(NSDictionary())
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_MyImageClicks
        let postString : String = "token=" + _token + "&bingo=" + __picId
       // print(postString)
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            __block(__dict)
        }
    }
    //---提交新的图片
    static func _postNewBingo(__image:UIImage,__question:String,__answer:UIImage,__type:String,__block:(NSDictionary)->Void){
        let postString : String = "token=" + _token + "&image=\(CoreAction._imageToString(__image))&question=\(__question)&answer=\(CoreAction._imageToString_PNG(__answer))&type=\(__type)&lng=\(MainAction._locationPoint.x)&lat=\(MainAction._locationPoint.y)"
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_PostBingo
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    //---提交图片福利
    static func _uploadWelfareOfPic(__image:UIImage,__bingoId:String,__block:(NSDictionary)->Void){
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_Welfare
        CoreAction._sendToUrl("token=\(_token)&bingo=\(__bingoId)&type=image&welfare=\(CoreAction._imageToString(__image))", __url: _url) { (__dict) -> Void in
            print("提交图片福利:",__dict)
            __block(__dict)
        }
    }
    //---举报
    static func _report(__to:String,__bingoId:String,__description:String,__block:(NSDictionary)->Void){
        var postString : String = "token=" + _token
        postString = postString.stringByAppendingFormat("&to=%@&bingo=%@&description=%@",__to,__bingoId,__description)
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_Report
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    
    //------获取本地bingos联系人聊天列表
    static func _getBingoChats(__block:(NSArray)->Void){
        if _ChatsList != nil{
            __block(_ChatsList!)
            return
        }else{
            //CoreAction._deleteFile("BingoChatsList")
            CoreAction._copyDefaultFile(_Name_BingoChatsList, __toFile: _Name_BingoChatsList)
                        
            let _array = CoreAction._getArrayFromFile(_Name_BingoChatsList)
            _ChatsList = _array!
            __block(_ChatsList!)
        }
    }
    
    //------刷新未读消息数量－－－－目前只根据未读人数返回
    static func _unreadNum()->Int{
        var _num:Int = 0
        if _ChatsList==nil{
            return 0
        }
        
        for var i:Int = 0; i<_ChatsList!.count; ++i{
            let _dict:NSDictionary = _ChatsList!.objectAtIndex(i) as! NSDictionary
            if let _isNew:Bool = _dict.objectForKey("isnew") as? Bool{
                if _isNew{
                    _num = _num + 1
                }
            }
        }
        return _num
    }
    //-----返回最新一条未读消息
    static func _lastUnreadMessage()->NSDictionary?{
        if _ChatsList == nil{
            return nil
        }
        
        for var i:Int = 0; i<_ChatsList!.count; ++i{
            let _dict:NSDictionary = _ChatsList!.objectAtIndex(i) as! NSDictionary
            if let _isNew:Bool = _dict.objectForKey("isnew") as? Bool{
                if _isNew{
                    return _dict
                }
            }
            
        }
        return nil
    }
    //------bingo成功 发送bingo
    static func _sentBingo(__picId:String,__x:Int,__y:Int,__right:String,__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Sent_Bingo
        let postString : String = "token=\(_token)&id=\(__picId)&x=\(__x)&y=\(__y)&right=\(__right)"
        //postString = postString.stringByAppendingFormat("&id=%@&x=%d&y=%d&right=%@",__picId,__x,__y,__right)
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //print(__dict.objectForKey("reason"))
            
            __block(__dict)
        }
    }
    //------bingo列表某用户设置成已读
    static func _readedAtFriend(__uid:String){
        let _newList:NSMutableArray = NSMutableArray(array: _ChatsList!)
        for var i:Int = 0 ; i < _newList.count ; ++i {
            let _item:NSMutableDictionary = NSMutableDictionary(dictionary: _newList.objectAtIndex(i) as! NSDictionary)
            if _item.objectForKey("uid") as! String == __uid{
                _item.setValue(false, forKey: "isnew")
                _newList[i] = _item
                break
            }
        }
        _ChatsList = _newList
        
        NSNotificationCenter.defaultCenter().postNotificationName(_Notification_chatChanged, object: nil, userInfo:nil)
    }
    
    //------添加到bingo联系人列表------
    static func _addToBingoList(__uid:String,__type:String,__content:String,__nickname:String,__avatar:String,__isNew:Bool){
        
        let _dict:NSDictionary = NSDictionary(objects: [__uid,__type,__content,__nickname,__avatar,__isNew], forKeys: ["uid","type","content","nickname","image","isnew"])
        
        _getBingoChats { (array) -> Void in
            let _array:NSMutableArray = NSMutableArray(array: _ChatsList!)
            // var _has:Bool = false
            for var i:Int = 0 ; i < _array.count ; ++i {
                let _item:NSMutableDictionary = NSMutableDictionary(dictionary: _array.objectAtIndex(i) as! NSDictionary)
                if _item.objectForKey("uid") as! String == __uid{
                    _array.removeObjectAtIndex(i)
                    break
                }
            }
            //-------注意这里的字典类型，包含了头像，从列表进入对话页面时，头像会带进对话页面
            _array.insertObject(_dict, atIndex: 0)
            _ChatsList = _array
            CoreAction._saveArrayToFile(_ChatsList!, __fileName: _Name_BingoChatsList)
        }
       
        NSNotificationCenter.defaultCenter().postNotificationName(_Notification_chatChanged, object: nil, userInfo:_dict as [NSObject : AnyObject])
        
    }
    //-----收到一条聊天记录
    static func _receiveOneChat(__dict:NSDictionary){
        //
        if let ___dict:NSDictionary = NSDictionary(objects: [__dict.objectForKey("from")!,MessageCell._Type_Message,__dict.objectForKey("content")!,__dict.objectForKey("date")!], forKeys: ["uid","type","content","time"]){
            //_saveOneChat(___dict)
            print("收到消息：",__dict)
            _addToBingoList(__dict.objectForKey("from") as! String, __type: MessageCell._Type_Message, __content: __dict.objectForKey("content") as! String, __nickname:MainAction._nickName(__dict), __avatar: MainAction._avatar(__dict),__isNew: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(_Notification_new_chat, object: nil, userInfo:___dict as [NSObject : AnyObject])
        }
    }
    //-----收到一条bingo消息
    static func _receiveBingo(__dict:NSDictionary){
        print("＝＝＝收到一条bingo：",__dict)
        //return
        let _fromUser:NSDictionary = __dict.objectForKey("from") as! NSDictionary
        
       // let _bingo:NSDictionary = __dict.objectForKey("bingo") as! NSDictionary
        
       // let _content:String = _bingo.objectForKey("message") as! String
        
        let _avatar:String = MainAction._avatar(_fromUser)
        let _nickName:String = MainAction._nickName(_fromUser)
        if let ___dict:NSDictionary = NSDictionary(objects: [_fromUser.objectForKey("_id")!,MessageCell._Type_Bingo,"[bingo]",__dict.objectForKey("date")!], forKeys: ["uid","type","content","time"]){
            //_saveOneChat(___dict)
           // return
            _addToBingoList(_fromUser.objectForKey("_id") as! String, __type: MessageCell._Type_Bingo, __content:"[bingo]", __nickname: _nickName, __avatar: _avatar,__isNew: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(_Notification_new_bingo, object: nil, userInfo:___dict as [NSObject : AnyObject])
        }
    }
    
    //-----发送一条聊天记录
    static func _sentOneChat(__dict:NSDictionary){
        print(__dict)
        
        let _content:NSDictionary = __dict.objectForKey("content") as! NSDictionary
        
        if _socket != nil{
            _socket!.emit("message",NSDictionary(objects: [__dict.objectForKey("uid")!,MessageCell._Type_Message,_content.objectForKey("message")!], forKeys: ["to","type","content"]))
           // print(_socket)
        }
        //_saveOneChat(NSDictionary(objects: [__dict.objectForKey("uid")!,__dict.objectForKey("type")!,__dict.objectForKey("content")!,CoreAction._timeStrOfCurrent()], forKeys: ["uid","type","content","time"]))
    }
    //－－－－保存一条记录到本地---作废
    static func _saveOneChat(__dict:NSDictionary){
        //---字典格式 ： ["uid","type","content","time"]
        var _id:String = ""
        if let __id:String = __dict.objectForKey("uid") as? String{
            _id = __id
        }else{
            print("没有uid")
            return
        }
        if CoreAction._fileExistAtDocument(_Prefix_Chat + _id){
            let __array:NSMutableArray = NSMutableArray(array: CoreAction._getArrayFromFile(_Prefix_Chat + _id)!)
            __array.addObject(__dict)
            CoreAction._saveArrayToFile(__array, __fileName: _Prefix_Chat + _id)
            
        }else{
            CoreAction._saveArrayToFile([__dict], __fileName: _Prefix_Chat + _id)
        }
    }
    //----本地是否有该用户id的聊天记录
    static func _hasChatHistory(__uid:String)->Bool{
        if CoreAction._fileExistAtDocument(_Prefix_Chat + __uid){
            return true
        }else{
            return false
        }
    }
    //----删除本地聊天记录
    static func _deleteChatHistory(__uid:String)->Void{
        CoreAction._deleteFile(_Prefix_Chat + __uid)
    }
    
    //-----通过id获取一定数的聊天记录-----本地－－－作废了
    static func _getChatHistory(__uid:String,__num:Int)->NSArray?{
        if _hasChatHistory(__uid){
            let __array:NSArray = CoreAction._getArrayFromFile(_Prefix_Chat + __uid)!
            
            let _array = __array.subarrayWithRange(NSMakeRange(0, min(__num,__array.count)))
            return _array
            
        }else{
            return nil
        }
    }
    
    
    //------获取在线聊天记录
    static func _getChatHistoryOnline(__uid:String,__fromChatId:String, __num:Int,__block:(NSArray)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_ChatHistory
        let postString : String = "token=" + _token + "&friend=" + __uid
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                let _messages:NSArray = __dict.objectForKey("info") as! NSArray
                __block(_messages)
            }else{
                __block(NSArray())
            }
        }
    }
    //-----获取被指定好友bingo列表
    static func _getBingoListOnlineOfUser(__uid:String,__block:(NSArray)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_BingoHistoryOfFriend
        let postString : String = "token=" + _token + "&friend=" + __uid
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            print("_getBingoListOnlineOfUser：",__dict.objectForKey("reason"))
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                print(__dict)
                let _messages:NSArray = __dict.objectForKey("info") as! NSArray
                
                __block(_messages)
            }else{
                __block(NSArray())
            }
            
        }
 
    }
    
    //------本地个人资料
    static func _Profile()->NSDictionary{
        if _profileDict != nil{
            return _profileDict!
           
        }else{
            //CoreAction._deleteFile("Profile")
            if CoreAction._fileExistAtDocument("Profile"){
    
            }else{
                CoreAction._copyDefaultFile("Profile", __toFile: "Profile")
            }
            _profileDict = CoreAction._getDictFromFile("Profile")
            return  _profileDict!
        }
    }
    
    //-----在线更新我的个人资料
    static func _getMyProfile(__block:(NSDictionary)->Void){
        let postString : String = "token=" + _token
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_MyProfile
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            if !_checkRespon(__dict){
                return
            }
            if __dict.objectForKey("recode") as! Int == 200{
                _profileDict = __dict.objectForKey("info") as? NSDictionary
                CoreAction._saveDictToFile(_profileDict!, __fileName: "Profile")
                //print("_profileDict:",_profileDict)
                NSNotificationCenter.defaultCenter().postNotificationName(MainAction._Notification_getProfileOk, object: nil)
                
                
                _checkDeviceToKen()
            }
            __block(__dict)
        }
    }
    
    //-----修改app图标小圆圈数字
    
    static func _changeBageNumber(__num:Int){
        UIApplication.sharedApplication().applicationIconBadgeNumber = __num
    }
    
    //------判断提交用于推送的 设备 token
    
    static func _checkDeviceToKen(){
//        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        if let _str:String = _ud.objectForKey("deviceTokenString") as? String{
//            MainAction._changeDeviceToken(_str)
//        }else{
            let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: [UIUserNotificationType.Badge,UIUserNotificationType.Alert,UIUserNotificationType.Sound], categories: nil )
            UIApplication.sharedApplication().registerUserNotificationSettings( settings )
            UIApplication.sharedApplication().registerForRemoteNotifications()
        //}
    }
    
    //------提交用于推送的 设备 token 在 AppDelegate.swift 里侦听注册成功后发送
    static func _changeDeviceToken(__tokenString:String){
        var postString : String = "token="+_token
        postString = postString.stringByAppendingFormat("&device=ios&iOSPushToken=%@",__tokenString)
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_ChangeMyProfile
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            _checkRespon(__dict)
           print("修改推送token完成：",__dict)
        }
    }

    
    //------提交个人资料
    static func _uploadProfile(__dict:NSDictionary,__block:(NSDictionary)->Void){
        var postString : String = "token="+_token
        postString = postString.stringByAppendingFormat("&nickname=%@&sex=%d",__dict.objectForKey("nickname") as! String, __dict.objectForKey("sex") as! Int)
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_ChangeMyProfile
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
           
            __block(__dict)
        }
    }
    //---提交个人头像照片
    static func _changeAvatar(__image:UIImage,__block:(NSDictionary)->Void){
        let postString : String = "token=" + _token + "&avatar=" + CoreAction._imageToString(__image) + "&imagend=png"
        print("token=" + _token + "&imagend=png")
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_ChangeMyAvatar
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    
    
    
    //-----获取图片完整url
    static func _imageUrl(__str:String)->String{
        //let _url:String = _BasicDomain + "/uploadDir/" + __str
        
        let _url:String = "http://disk.giccoo.com/BingoMe/" + __str
        
        return _url
    }
    //-----通过用户字典返回个人头像
    static func _avatar(__dict:NSDictionary)->String {
        var _url:String = "user-icon-w.jpg"
        var _hasAvatar:Bool = false
        if let _avatar = __dict.objectForKey("avatar") as? String{
            if _avatar == ""{
            }else{
                _hasAvatar = true
                _url = MainAction._imageUrl(_avatar)
            }
        }else{
            
        }
        if !_hasAvatar{
            if let _sex = __dict.objectForKey("sex") as? Int{
                if _sex == 1{
                    _url = "user-icon-m.jpg"
                }else{
                    _url = "user-icon-w.jpg"
                }
            }else{
                _url = "user-icon-w.jpg"
            }
        }
        return _url
    }
    //-----通过用户字典返回性别
    static func _sex(__dict:NSDictionary)->Int {
            if let _sex = __dict.objectForKey("sex") as? Int{
                return _sex
            }else{
               return -1
            }
    }

    //-----通过用户字典返回昵称
    static func _nickName(__dict:NSDictionary)->String{
        if let __nickName = __dict.objectForKey("nickname") as? String{
            return __nickName
        }else{
            return "someone"
        }

    }
    
    
    static let _defaultQuestions:NSArray = ["猜猜我喜欢哪里","你喜欢哪里呢？","我们会有共同点吗？\n点点图片你就知道","找亮点","点一下，看看跟我的兴趣点一致不","点点图片，bingo me!","猜我的兴趣点在哪里","点图片就对了","我想看看你点哪里","喜欢哪里点哪里，跟我一样有奖励","你的兴趣点在哪里","大家来点点","点一下，没准就bingo上了呢","点一下图片，然后随缘了，哈"]
}



