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
    
    static var _token:String = "c4b44a6e-06d0-4c4a-88dd-b840b3311dda"
    static let _BasicDomain:String = "http://bingome.giccoo.com"
    static let _Version:String = "v1"
    static let _URL_PostBingo:String = "bingo/send/"
    static let _URL_BingoList:String = "bingo/list/"
    
    static let _Post_Type_Media:String = "Media"
    static let _Post_Type_Camera:String = "Camera"
    static var _BingoList:NSArray = []   //首页列表
    
    
    //-----获取首页列表
    static func _getBingoList(__block:(NSArray)->Void){
        let request = NSMutableURLRequest(URL: NSURL(string:_BasicDomain + "/" + _Version + "/" + _URL_BingoList)!)
        request.HTTPMethod = "POST"
        let postString : String = "token=" + _token
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            //let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(_str)
            do{
                let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
               _BingoList = _BingoList.arrayByAddingObjectsFromArray(jsonResult.objectForKey("info") as! NSArray as [AnyObject]) as NSArray
                
                __block(NSArray(array: jsonResult.objectForKey("info") as! NSArray))
                
               // print(jsonResult.objectForKey("info"))
            }catch{
                print(error)
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
            postString = postString.stringByAppendingFormat("&image=%@&question=%@&answer=%@&type=%@&lng=%d&lat=%d",string,"问题",_answerString,__type,7,7)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
                let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(_str)
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(jsonResult)
                }catch{
                    print(error)
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



