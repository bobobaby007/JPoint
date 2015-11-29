//
//  MainAction.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/13.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class MainAction {
    
    static var _token:String = "firstTest"
    //static let _BasicDomain:String = "http://192.168.1.108:9999" //"http://192.168.1.108:9999" // "http://bingome.giccoo.com"//---
    static let _BasicDomain:String = "http://bingome.giccoo.com"
    //static let _URL_Socket:String = "http://192.168.1.108:9999"//"http://bingome.giccoo.com"  //http://192.168.1.108:9999   http://bingome.giccoo.com
    static let _URL_Socket:String = "http://bingome.giccoo.com"
    static let _Version:String = "v1"
    static let _URL_PostBingo:String = "bingo/send/"//---发布图片地址
    static let _URL_BingoList:String = "bingo/list/"//----获取首页列表
    static let _URL_ClearReadRecord:String = "bingo/empty/"//-----清空我的阅读记录
    static let _URL_MyImageList:String = "my/list/"//－－－我的图列
    static let _URL_MyImageDetail = "my/bingo/" //--- 我的图列详情
    static let _URL_Sent_Bingo:String = "bingo/check/"//----发送bingo地址
    static let _URL_Signup:String = "sign/up/" //----注册地址
    static let _URL_Login:String = "sign/in/"//登录地址
    
    static let _URL_MyProfile:String = "my/"
    static let _URL_ChangeMyProfile:String = "my/info/"
    static let _URL_ChangeMyAvatar:String = "my/avatar/"//----修改头像
    
    static let _Post_Type_Media:String = "Media"
    static let _Post_Type_Camera:String = "Camera"
    static let _BingoType_text:String = "text"
    static let _BingoType_bingo:String = "bingo"
    static var _BingoList:NSArray = []   //首页列表
    static var _MyImageList:NSArray = [] //我的图列数组
    static var _ChatsList:NSArray?//---bingo聊天列表
    static var _profileDict:NSDictionary?
    static var _userInfo:NSMutableDictionary?
    static var _socket:SocketIOClient?
    
    static var _Prefix_Chat:String = "chatHistory_" //----聊天记录文件名前缀
    static var _Name_BingoChatsList = "BingoChatsList" //----聊天记录列表文件名
    
    static var _Notification_new_chat:String = "Notification_new_chat"//新的聊天消息
    
    
    static func _getToken()->String{
        return _token
        
    }
    //------快速注册
    static func _signupQuick(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Signup
        let postString : String = "type=quick" + "&openid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                let _info:NSDictionary = __dict.objectForKey("info") as! NSDictionary
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
    //------快速登录
    static func _loginQuick(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Login
        let postString : String = "type=quick" + "&openid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                let _info:NSDictionary = __dict.objectForKey("info") as! NSDictionary
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
                _soketConnect()
            }
            _socket!.on("login") {data, ack in
               // print(data[0])
            }
            _socket!.on("message") {data, ack in
                print(data[0])
                _receiveOneChat(data[0] as! NSDictionary)
            }
        }
        _socket!.connect()
    }
    
    //-----获取首页列表
    static func _getBingoList(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_BingoList
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            print("0000000")
            
            let recode:Int = __dict.objectForKey("recode") as! Int
            
            print("0000000000===",recode)
            
            
            if recode == 200{
                _BingoList = __dict.objectForKey("info") as! NSArray
            }else{
             
            }
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
    //-----获取我的图列
    static func _getMyImageList(__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_MyImageList
        let postString : String = "token=" + _token
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //print(__dict.objectForKey("reason"))
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                //_MyImageList = __dict.objectForKey("info") as! NSArray
                
            }else{
                
            }
            __block(__dict)
        }
    }
    //-----获取图列详情
    static func _getImageDetails(__picId:String, __block:(NSDictionary)->Void){
        __block(NSDictionary())
//        let url = _BasicDomain + "/" + _Version + "/" +  _URL_MyImageDetail
//        let postString : String = "token=" + _token + "&bingo=" + __picId
//        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
//            let recode:Int = __dict.objectForKey("recode") as! Int
//            if recode == 200{
//                //_MyImageList = __dict.objectForKey("info") as! NSArray
//            }else{
//                
//            }
//            __block(__dict)
//        }
    }
    //---提交新的图片
    static func _postNewBingo(__image:UIImage,__question:String,__answer:UIImage,__type:String,__block:(NSDictionary)->Void){
        var postString : String = "token=" + _token
        postString = postString.stringByAppendingFormat("&image=%@&question=%@&answer=%@&type=%@&lng=%d&lat=%d",CoreAction._imageToString(__image),__question,CoreAction._imageToString_PNG(__answer),__type,7,7)
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_PostBingo
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    
    //------获取bingos聊天列表
    static func _getBingoChats(__block:(NSArray)->Void){
        if _ChatsList != nil{
            __block(_ChatsList!)
            return
        }else{
            //CoreAction._deleteFile("BingoChatsList")
            CoreAction._copyDefaultFile(_Name_BingoChatsList, __toFile: _Name_BingoChatsList)
            
            //        if CoreAction._fileExistAtDocument("BingoChatsList"){
            //
            //        }else{
            //            CoreAction._copyDefaultFile("BingoChatsList", __toFile: "BingoChatsList")
            //        }
            
            let _array = CoreAction._getArrayFromFile(_Name_BingoChatsList)
            _ChatsList = _array!
            __block(_ChatsList!)
        }
    }
    //------bingo成功
    static func _sentBingo(__picId:String,__x:Int,__y:Int,__right:String,__block:(NSDictionary)->Void){
        let url = _BasicDomain + "/" + _Version + "/" +  _URL_Sent_Bingo
        let postString : String = "token=\(_token)&id=\(__picId)&x=\(__x)&y=\(__y)&right=\(__right)"
        //postString = postString.stringByAppendingFormat("&id=%@&x=%d&y=%d&right=%@",__picId,__x,__y,__right)
        CoreAction._sendToUrl(postString, __url: url) { (__dict) -> Void in
            //print(__dict.objectForKey("reason"))
            __block(__dict)
        }
    }
    //------添加到bingo列表
    static func _addBingosTo(__uid:String,__type:String,__content:String,__nickname:String,__image:String){
        _addToBingoList(__uid,__type: __type,__content: __content,__nickname: __nickname,__image: __image)
    }
    static func _addToBingoList(__uid:String,__type:String,__content:String,__nickname:String,__image:String){
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
            _array.insertObject(NSDictionary(objects: [__uid,__type,__content,__nickname,__image], forKeys: ["uid","type","content","nickname","image"]), atIndex: 0)
            _ChatsList = _array
            CoreAction._saveArrayToFile(_ChatsList!, __fileName: _Name_BingoChatsList)
        }
    }
    //-----收到一条聊天记录
    static func _receiveOneChat(__dict:NSDictionary){
        if let ___dict:NSDictionary = NSDictionary(objects: [__dict.objectForKey("from")!,MessageCell._Type_Message,__dict.objectForKey("content")!,__dict.objectForKey("date")!], forKeys: ["uid","type","content","time"]){
            
            _saveOneChat(___dict)
            
            _addToBingoList(__dict.objectForKey("from") as! String, __type: MessageCell._Type_Message, __content: __dict.objectForKey("content") as! String, __nickname: __dict.objectForKey("nickname") as! String, __image: MainAction._imageUrl(__dict.objectForKey("avatar") as! String))
            
            NSNotificationCenter.defaultCenter().postNotificationName(_Notification_new_chat, object: nil, userInfo:___dict as [NSObject : AnyObject])
        }
    }
    //-----发送一条聊天记录
    static func _sentOneChat(__dict:NSDictionary){
        print(__dict)
        if _socket != nil{
            _socket!.emit("message",NSDictionary(objects: [__dict.objectForKey("uid")!,MessageCell._Type_Message,__dict.objectForKey("content")!], forKeys: ["to","type","content"]))
            print(_socket)
        }
        _saveOneChat(NSDictionary(objects: [__dict.objectForKey("uid")!,__dict.objectForKey("type")!,__dict.objectForKey("content")!,CoreAction._timeStrOfCurrent()], forKeys: ["uid","type","content","time"]))
    }
    //－－－－保存一条记录
    static func _saveOneChat(__dict:NSDictionary){
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
    //----是否有该用户id的聊天记录
    static func _hasChatHistory(__uid:String)->Bool{
        if CoreAction._fileExistAtDocument(_Prefix_Chat + __uid){
            return true
        }else{
            return false
        }
    }
    //----删除聊天记录
    static func _deleteChatHistory(__uid:String)->Void{
        CoreAction._deleteFile(_Prefix_Chat + __uid)
    }
    //-----通过id获取一定数的聊天记录
    static func _getChatHistory(__uid:String,__num:Int)->NSArray?{
        if _hasChatHistory(__uid){
            let __array:NSArray = CoreAction._getArrayFromFile(_Prefix_Chat + __uid)!
            
            let _array = __array.subarrayWithRange(NSMakeRange(0, min(__num,__array.count)))
            return _array
            
        }else{
            return nil
        }
    }
    
    //------获取本地个人资料
    static func _getProfile(__block:(NSDictionary)->Void){
        if _profileDict != nil{
            __block(_profileDict!)
            return
        }else{
            //CoreAction._deleteFile("Profile")
            
            if CoreAction._fileExistAtDocument("Profile"){
    
            }else{
                CoreAction._copyDefaultFile("Profile", __toFile: "Profile")
            }
            _profileDict = CoreAction._getDictFromFile("Profile")
            __block(_profileDict!)
        }
    }
    
    //-----在线更新我的个人资料
    static func _getMyProfile(__block:(NSDictionary)->Void){
        let postString : String = "token=" + _token
        let _url:String = _BasicDomain + "/" + _Version + "/" +  _URL_MyProfile
        CoreAction._sendToUrl(postString, __url:_url) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                _profileDict = __dict.objectForKey("info") as? NSDictionary
                CoreAction._saveDictToFile(_profileDict!, __fileName: "Profile")
                //print("_profileDict:",_profileDict)
            }
            __block(__dict)
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
        let _url:String = _BasicDomain + "/uploadDir/" + __str
        return _url
    }
        
}



