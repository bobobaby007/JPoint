//
//  CoreAction.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/1.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class CoreAction {
    //-----当前时间转换成字符串
    static func _timeStr(__timeStr:String)->String {
        //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone.localTimeZone()
        //let _date:NSDate = formatter.dateFromString(__timeStr)!
        let timestamp = formatter.stringFromDate(NSDate())
        //print(_date,__timeStr,timestamp,dateDiff(__timeStr))
        return timestamp
    }
    //-----返回相距当前时间
    static func _dateDiff(dateStr:String) -> String {
        let f:NSDateFormatter = NSDateFormatter()
        f.timeZone = NSTimeZone.localTimeZone()
        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        
        let now = f.stringFromDate(NSDate())
        let startDate = f.dateFromString(dateStr)
        let endDate = f.dateFromString(now)
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        //let calendarUnits =
        
        let dateComponents = calendar.components([NSCalendarUnit.WeekOfMonth,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: startDate!, toDate: endDate!, options: NSCalendarOptions.init(rawValue: 0))
        
        let weeks = abs(dateComponents.weekOfMonth)
        let days = abs(dateComponents.day)
        let hours = abs(dateComponents.hour)
        let min = abs(dateComponents.minute)
        let sec = abs(dateComponents.second)
        
        var timeAgo = ""
        
        if (sec > 0){
            if (sec > 1) {
                timeAgo = "\(sec)秒前"// Seconds Ago"
            } else {
                timeAgo = "\(sec)秒前"// Seconds Ago"
            }
        }
        
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min)分钟前"// Minutes Ago"
            } else {
                timeAgo = "\(min)分钟前"// Minute Ago"
            }
        }
        
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours)小时前"// Hours Ago"
            } else {
                timeAgo = "\(hours)小时前"// Hour Ago"
            }
        }
        
        if (days > 0) {
            if (days > 1) {
                timeAgo = "\(days)天前"// Days Ago"
            } else {
                timeAgo = "\(days)天前"// Day Ago"
            }
        }
        
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = "\(weeks)周前"// Weeks Ago"
            } else {
                timeAgo = "\(weeks)周前"// Week Ago"
            }
        }
        
        return timeAgo;
    }
    //－－－－－－－把图片变成灰色
    static func _converImageToGray(__inImage:UIImage)->UIImage{
        let _rect:CGRect = CGRectMake(0, 0, __inImage.size.width, __inImage.size.height)
        let _colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        //let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        // Create bitmap content with current image size and grayscale colorspace
        let _context:CGContextRef = CGBitmapContextCreate(nil, Int(__inImage.size.width), Int(__inImage.size.height), 8, 0, _colorSpace,CGImageAlphaInfo.None.rawValue)!
        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        CGContextDrawImage(_context, _rect, __inImage.CGImage)
        // Create bitmap image info from pixel data in current context
        let _imageRef:CGImageRef = CGBitmapContextCreateImage(_context)!
        
        let img:UIImage = UIImage(CGImage: _imageRef)
        
        return img;
    }
    //－－－－获取图片像素alpha值
    static func _getPixelAlphaFromImage(pos: CGPoint,__inImage:UIImage) -> CGFloat {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(__inImage.CGImage))
        
        
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(__inImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
//        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
       // print(UIScreen.mainScreen().scale,__inImage.size.width)
        return a
    }
    //------截图
    static func _captureImage(__view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(__view.frame.size, false, 0.0);
        __view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    //-----获取版本号
    static func _version() -> String {
        let dictionary = NSBundle.mainBundle().infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    
    
    //-----保存字典到文件
    static func _saveDictToFile(__dict:NSDictionary,__fileName:String){
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        __dict.writeToFile(_path, atomically: false)
    }
    //-----从文件获取字典
    static func _getDictFromFile(__fileName:String)->NSDictionary?{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        if let _dict = NSDictionary(contentsOfFile: _path){
            return _dict
        }else{
            return nil
        }
    }
    //-----保存数组到文件
    static func _saveArrayToFile(__array:NSArray,__fileName:String){
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        __array.writeToFile(_path, atomically: false)
    }
    //-----从文件获取数组
    static func _getArrayFromFile(__fileName:String)->NSArray?{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        if let _array = NSArray(contentsOfFile: _path){
            return _array
        }else{
            return nil
        }
    }
    //-----删除文件
    static func _deleteFile(__fileName:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(__fileName)
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(path)
        }catch{
            print(error)
        }
    }
    //----复制默认文件到
    static func _copyDefaultFile(__fileName:String, __toFile:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(__fileName)
        let fileManager = NSFileManager.defaultManager()
        // If it doesn't, copy it from the default file in the Bundle
        if let bundlePath = NSBundle.mainBundle().pathForResource(__fileName, ofType: "plist") {
            
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            print("Bundle \(__fileName).plist file is --> \(resultDictionary?.description)")
            do{
              try fileManager.copyItemAtPath(bundlePath, toPath: path)
            }catch{
                print(error)
            }
        } else {
            print("\(__fileName).plist not found. Please, make sure it is part of the bundle.")
        }
        
    }
    //----判断文件是否存在于文档文件夹中   
    static func _fileExistAtDocument(__fileName:String)->Bool{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        let _fileManager = NSFileManager.defaultManager()
        return _fileManager.fileExistsAtPath(_path)
    }
    
    
    
    
    
    
    
    
    
    /*
    static func _uploadImage(){
        let imageData = UIImagePNGRepresentation(UIImage(named: "okgo.png")!)
        
        if imageData != nil{
            let request = NSMutableURLRequest(URL: NSURL(string:"http://4view.cn/interface/upfile.php")!)
            //let request = NSMutableURLRequest(URL: NSURL(string:"http://192.168.1.106:9999/v1/bingo/send/")!)
            //let session = NSURLSession.sharedSession()
            //let string = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
           // print(string)
            let string:NSString = NSString(format: "www")
            
            request.HTTPMethod = "POST"
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            // String
//            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"string\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            //body.appendData(string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
//            body.appendData("hello world".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
           
            
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            // body.appendData(NSString(format:"Content-Disposition: form-data; name=\"pic\"; filename=\"okgo.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"myForm\"; filename=\"ttttt\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
           // body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            // body.appendData(imageData!)
            body.appendData(string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            //body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            // Image
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
           // body.appendData(NSString(format:"Content-Disposition: form-data; name=\"pic\"; filename=\"okgo.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
             body.appendData(NSString(format:"Content-Disposition: form-data; name=\"pic\"; filename=\"okgo.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
           // body.appendData(imageData!)
            body.appendData(string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
           // print(body)
            request.HTTPBody = body
            
            
            
            let see = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
             // print(data)
                
                let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(_str)
                
                do{
                 let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                  print(jsonResult)
                }catch{
                    print(error)
                }
                
                
                
                
                
                
//            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//                               print("AsSynchronous\(jsonResult)")
            })
            
            see.resume()
            
            //var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//            let queue:NSOperationQueue = NSOperationQueue()
//            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response, data, error) -> Void in
//                var err: NSError
//                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//                print("AsSynchronous\(jsonResult)")
           // })
            
            
            
//            let returnString = NSString(data: returnData, encoding: NSUTF8StringEncoding)
//            
//            print("returnString \(returnString)")
            
        }
        

    }*/
    
    static func _uploadImage(){
        //let imageData = UIImagePNGRepresentation(UIImage(named: "test.png")!)
        let imageData = UIImageJPEGRepresentation(UIImage(named: "image_1.jpg")!, 1
        )
       // let imageData_jpg = UIImagePNGRepresentation(UIImage(named: "image_1.jpg")!)

        if imageData != nil{
            let request = NSMutableURLRequest(URL: NSURL(string:"http://bingome.giccoo.com/v1/bingo/send/")!)
            //let request = NSMutableURLRequest(URL: NSURL(string:"http://192.168.1.106:9999/v1/bingo/send/")!)
            //let session = NSURLSession.sharedSession()
            var string:String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
           //let data = imageData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            string = string.stringByReplacingOccurrencesOfString("+", withString: "%2B")
            //let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
            // print(string)
            //return
            //let string:String = "我说的"
            
            request.HTTPMethod = "POST"
            var postString : String = "token="
           postString = postString.stringByAppendingFormat("&image=%@&question=%@&answer=%@&type=%@&lng=%d&lat=%d",string,"问题",string,"Meida",7,7)
            
           // print(postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
            
            //return
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            
            
            let see = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
                // print(data)
                
                let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(_str)
                
//                do{
//                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
//                    print(jsonResult)
//                }catch{
//                    print(error)
//                }
            })
            see.resume()
        }
    }
    
    
}
