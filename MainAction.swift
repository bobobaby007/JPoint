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
    
    static var _token:String = "first"//"546e6653-8aa8-4416-bd72-66639e3a421c"
    static let _BasicDomain:String = "http://bingome.giccoo.com"//---
    static let _Version:String = "v1"
    static let _URL_PostBingo:String = "bingo/send/"//---发布图片地址
    static let _URL_BingoList:String = "bingo/list/"//----获取首页列表
    
    static let _URL_Signup:String = "sign/up/" //----注册地址
    static let _URL_Login:String = "sign/in/"//登录地址
    static let _URL_Socket:String = "http://bingome.giccoo.com"  //http://192.168.1.108:9999   http://bingome.giccoo.com
    static let _URL_MyProfile:String = "my/"
    static let _URL_ChangeMyProfile:String = "my/info/"
    static let _URL_ChangeMyAvatar:String = "my/avatar/"//----修改头像
    
    static let _Post_Type_Media:String = "Media"
    static let _Post_Type_Camera:String = "Camera"
    static let _BingoType_text:String = "text"
    static let _BingoType_bingo:String = "bingo"
    static var _BingoList:NSArray = []   //首页列表
    static var _ChatsList:NSArray?//---bingo聊天列表
    static var _profileDict:NSDictionary?
    
    static var _userInfo:NSMutableDictionary?
    
    static var _socket:SocketIOClient?
    
    static func _getToken()->String{
        
        return _token
        
    }
    //------快速注册
    static func _signupQuick(__block:(NSDictionary)->Void){
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" +  _URL_Signup)!)
        request.HTTPMethod = "POST"
        var postString : String = "type=quick"
        print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
        postString = postString.stringByAppendingFormat("&openid=%@",UIDevice.currentDevice().identifierForVendor!.UUIDString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("_signupQuick:",_str)
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                  print(jsonResult)
                if jsonResult.objectForKey("recode") as! Int == 200{
                    let _info:NSDictionary = jsonResult.objectForKey("info") as! NSDictionary
                    _token = _info.objectForKey("token") as! String
                    __block(jsonResult as! NSDictionary)
                }else{
                    //__block(jsonResult as! NSDictionary)
                }
                //__block(jsonResult as! NSDictionary)
                
            }catch{
                print(error)
            }
        })
        task.resume()
    }
    //------快速登录
    static func _loginQuick(__block:(NSDictionary)->Void){
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" +  _URL_Login)!)
        request.HTTPMethod = "POST"
        var postString : String = "type=quick"
        print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
        postString = postString.stringByAppendingFormat("&openid=%@",UIDevice.currentDevice().identifierForVendor!.UUIDString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        print(request)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("_loginQuick:",_str)
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                print(jsonResult)
                if jsonResult.objectForKey("recode") as! Int == 200{
                    let _info:NSDictionary = jsonResult.objectForKey("info") as! NSDictionary
                    _token = _info.objectForKey("token") as! String
                    __block(jsonResult as! NSDictionary)
                }else{
                    _signupQuick({ (__dict) -> Void in
                        __block(__dict)
                    })
                }
                //__block(jsonResult as! NSDictionary)
                
            }catch{
                _signupQuick({ (__dict) -> Void in
                    __block(__dict)
                })
                print(error)
            }
        })
        task.resume()
    }
    
    //-----socket
    
    static func _soketConnect(){
        if _socket == nil{
            _socket = SocketIOClient(socketURL: _URL_Socket, options: [.Log(true), .ForcePolling(true)])
        }
        _socket!.on("connect") {data, ack in
            print("socket connected")
            _socket!.emit("login", NSDictionary(objects: [MainAction._token], forKeys: ["token"]))
        }
        _socket!.on("login") {data, ack in
            print("====================:",data[0])
        }
        
        _socket!.connect()
    }
    
    //-----获取首页列表
    static func _getBingoList(__block:(NSDictionary)->Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" + _URL_BingoList)!)
        request.HTTPMethod = "POST"
        let postString : String = "token=" + _token
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(_str)
            
            do{
                let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if jsonResult.objectForKey("recode") as! Int == 200{
                    _BingoList = jsonResult.objectForKey("info") as! NSArray
                    __block(NSDictionary(objects: [200,NSArray(array: jsonResult.objectForKey("info") as! NSArray)],forKeys: ["recode","array"]))
                }else{
                    __block(NSDictionary(objects: [jsonResult.objectForKey("recode") as! Int],forKeys: ["recode"]))
                }
               //_BingoList = _BingoList.arrayByAddingObjectsFromArray(jsonResult.objectForKey("info") as! NSArray as [AnyObject]) as NSArray
                
                
               // print(jsonResult.objectForKey("info"))
            }catch{
                __block(NSDictionary(objects: [0], forKeys: ["recode"]))
            }
        })
        task.resume()
    }
    //---提交新的图片
    static func _postNewBingo(__image:UIImage,__question:String,__answer:UIImage,__type:String){
        //let imageData = UIImagePNGRepresentation(UIImage(named: "test.png")!)
        let imageData = UIImageJPEGRepresentation(__image, 0.7)
        let _answerData = UIImagePNGRepresentation(__answer)
        // let imageData_jpg = UIImagePNGRepresentation(UIImage(named: "image_1.jpg")!)
        
        if imageData != nil{
            let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" +  _URL_PostBingo)!)
            request.HTTPMethod = "POST"
            var string:String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
            //let data = imageData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            string = string.stringByReplacingOccurrencesOfString("+", withString: "%2B")
            
            var _answerString = (_answerData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
            _answerString = _answerString.stringByReplacingOccurrencesOfString("+", withString: "%2B")
            
            var postString : String = "token=" + _token
            postString = postString.stringByAppendingFormat("&image=%@&question=%@&answer=%@&type=%@&lng=%d&lat=%d",string,__question,_answerString,__type,7,7)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
                let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //print(_str)
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                  //  print(jsonResult)
                }catch{
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    //------获取bingos聊天列表
    static func _getBingoChats(__block:(NSArray)->Void){
        if _ChatsList != nil{
            __block(_ChatsList!)
            return
        }else{
            CoreAction._deleteFile("BingoChatsList")
            CoreAction._copyDefaultFile("BingoChatsList", __toFile: "BingoChatsList")
            
            //        if CoreAction._fileExistAtDocument("BingoChatsList"){
            //
            //        }else{
            //            CoreAction._copyDefaultFile("BingoChatsList", __toFile: "BingoChatsList")
            //        }
            
            let _array = CoreAction._getArrayFromFile("BingoChatsList")
            _ChatsList = _array!
            __block(_ChatsList!)
        }
        
    }
    //------添加到bingo列表
    static func _addBingosTo(__uid:String,__type:String,__content:String,__nickname:String,__image:String){
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
            //print(_ChatsList,_array)
        }
        
    }
    
    //-----添加一条聊天记录
    static func _addChat(__dict:NSDictionary){
        
        
        
        
//
//        <?xml version="1.0" encoding="UTF-8"?>
//        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//        <plist version="1.0">
//        <dict>
//        <key>type</key>
//        <string>bingo</string>
//        <key>image</key>
//        <string>profile</string>
//        <key>uid</key>
//        <string>bingome</string>
//        <key>nickname</key>
//        <string>BingoMe</string>
//        <key>content</key>
//        <string>[match]</string>
//        </dict>
//        </plist>

        
        
                if CoreAction._fileExistAtDocument("chatHistory_" + (__dict.objectForKey("toid") as! String)){
        
                }else{
                    
                    
                }
                
    }
    static func _hasChatHistory(__uid:String)->Bool{
        if CoreAction._fileExistAtDocument("chatHistory_"+__uid){
            return true
        }else{
            return false
        }
    }
    static func _getChatHistory(__uid:String,__num:Int,__block:(NSArray)->Void){
        
    }
    
    
    //------获取本地个人资料
    static func _getProfile(__block:(NSDictionary)->Void){
        if _profileDict != nil{
            __block(_profileDict!)
            return
        }else{
            CoreAction._deleteFile("Profile")
            
            if CoreAction._fileExistAtDocument("Profile"){
    
            }else{
                CoreAction._copyDefaultFile("Profile", __toFile: "Profile")
            }
            _profileDict = CoreAction._getDictFromFile("Profile")
            __block(_profileDict!)
        }
    }
    
    //-----获取在线我的个人设置
    static func _getMyProfile(__block:(NSDictionary)->Void){
        __block(NSDictionary(objects: [-1], forKeys: ["recode"]))
        return
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/33" + _Version + "/" +  _URL_MyProfile)!)
        request.HTTPMethod = "POST"
        let postString : String = "token="+_token
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(_str)
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                if (jsonResult as! NSDictionary).objectForKey("recode") as! Int == 200{
                    _profileDict = (jsonResult as! NSDictionary).objectForKey("info") as? NSDictionary
                    
                }else{
                    
                }
                __block(jsonResult as! NSDictionary)
                print(jsonResult)
            }catch{
                __block(NSDictionary(objects: [0], forKeys: ["recode"]))
                print(error)
            }
        })
        task.resume()
    }
    //------提交个人资料
    static func _uploadProfile(__dict:NSDictionary,__block:(NSDictionary)->Void){
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" +  _URL_ChangeMyProfile)!)
        request.HTTPMethod = "POST"
        var postString : String = "token="+_token
        postString = postString.stringByAppendingFormat("&nickname=%@&sex=%d",__dict.objectForKey("nickname") as! String, __dict.objectForKey("sex") as! Int)
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(_str)
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                if (jsonResult as! NSDictionary).objectForKey("recode") as! Int == 200{
                    _profileDict = (jsonResult as! NSDictionary).objectForKey("info") as? NSDictionary
                    CoreAction._saveDictToFile(_profileDict!, __fileName: "Profile")
                }else{
                    
                }
                __block(jsonResult as! NSDictionary)
                
            }catch{
                
                print(error)
            }
        })
        task.resume()
        
        
        
    }
    //---提交个人头像照片
    static func _changeAvatar(__image:UIImage,__block:(NSDictionary)->Void){
        //let imageData = UIImagePNGRepresentation(UIImage(named: "test.png")!)
        let imageData = UIImageJPEGRepresentation(__image, 0.7)
        // let imageData_jpg = UIImagePNGRepresentation(UIImage(named: "image_1.jpg")!)
        
        if imageData != nil{
            let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" +  _URL_ChangeMyAvatar)!)
            request.HTTPMethod = "POST"
            var string:String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
            //let data = imageData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            string = string.stringByReplacingOccurrencesOfString("+", withString: "%2B")
            
            var postString : String = "token=" + _token
            postString = postString.stringByAppendingFormat("&avatar=%@&order=1",string)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
                let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(_str)
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    //  print(jsonResult)
                    __block(jsonResult as! NSDictionary)
                }catch{
                    __block(NSDictionary(objects: [0], forKeys: ["recode"]))
                }
            })
            task.resume()
        }
    }
    //-----获取图片完整url
    static func _imageUrl(__str:String)->String{
        let _url:String = _BasicDomain + "/uploadDir/" + __str
        
        return _url
    }
        
}



