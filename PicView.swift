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
    var _id:Int = 0
    static var _ScaleType_Fit:String = "Fit" //----显示全部
    static var _ScaleType_Full:String = "Full"//----满屏显示
    var _scaleType:String = "Full"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumZoomScale = 5
        self.minimumZoomScale = 1
        self.bouncesZoom=false
        self.bounces = false
        //self.decelerationRate = UIScrollViewDecelerationRateFast
        self.scrollEnabled=true
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        _imgView=UIImageView(frame: self.bounds)
        //_imgView?.layer.minificationFilter = kCAFilterTrilinear
        //_imgView?.alpha = 0.3
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        
        
        
        
        self.addSubview(_imgView!)
        self.delegate=self
        
        //self.clipsToBounds = false
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
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                
                _imgView?.image = UIImage(named: "noPic.jpg")
                
                ImageLoader.sharedLoader.imageForUrl(__pic.objectForKey("url") as! String, completionHandler: { (image, url) -> () in
                    // _setImage(image)
                    //println("")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
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
    
    func _loadImage(__picUrl:String){
        
        _setPic(NSDictionary(objects: [__picUrl,"file"], forKeys: ["url","type"])) { (_dict) -> Void in
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var  _toX:CGFloat = self.contentOffset.x
        var _toY:CGFloat = self.contentOffset.y
        
        if _imgView!.frame.width<self.frame.width{
            _toX = (_imgView!.frame.width-self.frame.width)/2
        }
        if _imgView!.frame.height<self.frame.height{
            _toY = (_imgView!.frame.height-self.frame.height)/2
        }
        
        
        self.setContentOffset(CGPoint(x:_toX, y: _toY), animated: false)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //self.contentSize = _imgView!.frame.size
        
        return _imgView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.setContentOffset(CGPoint(x: (_imgView!.frame.width-self.frame.width)/2, y: (_imgView!.frame.height-self.frame.height)/2), animated: false)
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
            print(_img,"不存在")
            return
        }
        self._setImageByImage(UIImage(named: _img)!)
        
        //self.addSubview(_imgView!)
    }
    func _setImageByImage(_img:UIImage){
        
        _imgView?.image=_img
        
        _refreshView()
    }
   
    
    func _refreshView(){
        let _scaleW = self.frame.width/self._imgView!.image!.size.width
        let _scaleH = self.frame.height/self._imgView!.image!.size.width
        
        var _scale = max(_scaleW,_scaleH)
        switch self._scaleType{
        case PicView._ScaleType_Fit:
            _scale =  min(_scaleW,_scaleH)
            break
        case PicView._ScaleType_Full:
            _scale = max(_scaleW,_scaleH)
            break
        default:
            
            break
        }
        self.zoomScale = 1
        self._imgView!.frame = CGRect(x: 0, y: 0, width:self._imgView!.image!.size.width*_scale, height: self._imgView!.image!.size.height*_scale)
        
        self.contentSize = self._imgView!.frame.size
        
        self.setContentOffset(CGPoint(x: (self._imgView!.frame.width-self.frame.width)/2, y: (self._imgView!.frame.height-self.frame.height)/2), animated: false)
        //_imgView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }

    
    //------
    
    func _move(__fromView:UIView,__fromRect:CGRect,__toView:UIView,__toRect:CGRect,__then:()->Void){
        let _fromP:CGPoint = __toView.convertPoint(__fromRect.origin, fromView: __fromView)
        self.frame.origin = _fromP
        __toView.addSubview(self)
        UIImageView.animateWithDuration(0.4, animations: { () -> Void in
            self.frame = __toRect
            self._refreshView()
            }) { (Comparable) -> Void in
                self._refreshView()
                __then()
        }
    }
    func _back(__fromView:UIView,__toView:UIView,__toRect:CGRect,__then:()->Void){
        let _toP:CGPoint = __fromView.convertPoint(__toRect.origin, fromView: __toView)
        UIImageView.animateWithDuration(0.4, animations: { () -> Void in
            self.frame = CGRect(origin: _toP, size: __toRect.size)
            self._refreshView()
            }) { (Comparable) -> Void in
                self.frame = __toRect
                self._refreshView()
                __toView.addSubview(self)
                __then()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}