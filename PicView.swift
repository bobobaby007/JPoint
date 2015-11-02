//
//  PicView.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/11.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PicView: UIScrollView,UIScrollViewDelegate{
    var _imgView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumZoomScale = 2.5
        self.minimumZoomScale = 1
        self.bouncesZoom=false
        self.bounces = false
        //self.decelerationRate = UIScrollViewDecelerationRateFast
        self.scrollEnabled=true
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        _imgView=UIImageView(frame: self.bounds)
        //_imgView?.alpha = 0.3
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        self.addSubview(_imgView!)
        self.delegate=self
        
        //self.clipsToBounds = false
    }
    func _refreshView(){
        //_imgView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    func _setPic(__pic:NSDictionary,__block:(NSDictionary)->Void){
        switch __pic.objectForKey("type") as! String{
        case "alasset":
            let _al:ALAssetsLibrary=ALAssetsLibrary()
            
            _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                if asset != nil {
                    self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue()))
                }else{
                    self._setImage("entroLogo")//----用户删除时
                }
                //self._setImageByImage(UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!)
               // self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                __block(NSDictionary(objects: ["success"], forKeys: ["info"]))
                }, failureBlock: { (error:NSError!) -> Void in
                __block(NSDictionary(objects: ["failed"], forKeys: ["info"]))
            })
            
        case "file":
            let _str = __pic.objectForKey("url") as! String
            let _range = _str.rangeOfString("http")
            if _range?.count != nil{
                ImageLoader.sharedLoader.imageForUrl(__pic.objectForKey("url") as! String, completionHandler: { (image, url) -> () in
                    // _setImage(image)
                    //println("")
                    if image==nil{
                        //--加载失败
                        print("图片加载失败:",__pic.objectForKey("url"))
                        __block(NSDictionary(objects: ["failed"], forKeys: ["info"]))
                        return
                    }
                    if self._imgView != nil{
                        self._setImageByImage(image!)
                        //self._imgView?.image=image
                        __block(NSDictionary(objects: ["success"], forKeys: ["info"]))
                    }else{
                        print("out")
                    }
                    
                })
            }else{
                self._setImage(__pic.objectForKey("url") as! String)
                __block(NSDictionary())
            }
        
        default:
            print("")
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //self.contentSize = _imgView!.frame.size
        
        return _imgView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        //let _w = max(contentSize.width,self.frame.width)
        //let _h = max(contentSize.height,self.frame.height)
        
        //self.contentSize = CGSize(width: _w, height: _h)
        
        // _imgView?.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        //_imgView?.center=self.center
    }
    func _setImage(_img:String){
        
       //
       // print(UIImage(named: _img))
        if UIImage(named: _img) == nil{
            print(_img)
            return
        }
        self._setImageByImage(UIImage(named: _img)!)
        
        //self.addSubview(_imgView!)
    }
    func _setImageByImage(_img:UIImage){
        
        let _scaleW = _imgView!.frame.width/_img.size.width
        let _scaleH = _imgView!.frame.height/_img.size.height
        
        let _scale = max(_scaleW,_scaleH)
        
        
        _imgView?.frame = CGRect(x: 0, y: 0, width:_img.size.width*_scale, height: _img.size.height*_scale)
        _imgView?.image=_img
    
        //_imgView?.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.setContentOffset(CGPoint(x: (_imgView!.frame.width-self.frame.width)/2, y: (_imgView!.frame.height-self.frame.height)/2), animated: false)
        
        //print(self.frame)
        
        
        
       // print(_imgView?.frame,self.frame)
        
        //self.contentSize = _imgView!.frame.size
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}