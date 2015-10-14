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
    
    static func _timeStr(__timestamp:String)->String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    
        return timestamp
    }
    
    static func _getPixelColor(pos: CGPoint,__inView:UIView) -> UIColor {
        let __inImage:UIImage = _captureImage(__inView)
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(__inImage.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        //print(data)
        let pixelInfo: Int = ((Int(__inImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    static func _getPixelAlpha(pos: CGPoint,__inView:UIView) -> CGFloat {
        let __inImage:UIImage = _captureImage(__inView)
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(__inImage.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(__inImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return a
    }
    static func _captureImage(__view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(__view.bounds.size, false, 0.0);
        __view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
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
