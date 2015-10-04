//
//  EditingView.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/7.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

protocol EditingView_delegate:NSObjectProtocol{
    func _edingImageIn()
}

class EditingView:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let _gap:CGFloat = 10
    let _btnW:CGFloat = 100
    var _setuped:Bool = false
    var _cornerRadius:CGFloat = 20
    var _btn_camera:UIButton = UIButton()
    var _btn_photo:UIButton = UIButton()
    var _btn_reset:UIButton = UIButton()
    var _btn_send:UIButton = UIButton()
    var _imagePicker:UIImagePickerController?
    
    var _imageContainer:UIView = UIView()
    var _imageW:CGFloat = 0
    var _bgImageV:UIImageView = UIImageView()
    
    var _hasImg:Bool = false
    
    var _drawingBoard:DrawingBoard?
    
    weak var _delagate:EditingView_delegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.clearColor()
        _btn_camera.frame = CGRect(x: 0, y: 0, width: _btnW, height: _btnW)
        _btn_camera.layer.borderWidth = 1
        _btn_camera.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_camera.layer.cornerRadius = _btnW/2
        _btn_camera.backgroundColor = UIColor(white: 0, alpha: 0.3)
        _btn_camera.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        _btn_camera.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_photo.frame = CGRect(x: 0, y: 0, width: _btnW, height: _btnW)
        _btn_photo.layer.borderWidth = 1
        _btn_photo.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_photo.layer.cornerRadius = _btnW/2
        _btn_photo.backgroundColor = UIColor(white: 0, alpha: 0.3)
        _btn_photo.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        _btn_photo.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_reset.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        _btn_reset.setImage(UIImage(named: "resetIt"), forState: UIControlState.Normal)
        _btn_reset.center = CGPoint(x: 100, y: self.view.frame.height-50)
        _btn_reset.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_send.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        _btn_send.center = CGPoint(x: self.view.frame.width-100, y: self.view.frame.height-50)
        _btn_send.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_send.setImage(UIImage(named: "okgo"), forState: UIControlState.Normal)
        
        self._btn_reset.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_send.transform = CGAffineTransformMakeScale(0, 0)
        
        _btn_camera.alpha=0
        _btn_photo.alpha=0
        _btn_reset.alpha=0
        _btn_send.alpha=0
        
        var _img:UIImage = UIImage(named: "carera_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_camera.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        _img = UIImage(named: "photo_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_photo.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        
        
        _imageW = self.view.frame.width-2*_gap
        _imageContainer.frame = CGRect(x: 0, y: 0, width: _imageW, height: _imageW)
        _imageContainer.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        
        _drawingBoard = DrawingBoard()
        self.addChildViewController(_drawingBoard!)
        _drawingBoard!.view.frame = _imageContainer.frame
        _drawingBoard!.view.center = _imageContainer.center
        
        
        
        
        //_imageContainer.layer.masksToBounds = true
        _imageContainer.backgroundColor = UIColor(white: 1, alpha: 0)
        _imageContainer.layer.cornerRadius = _cornerRadius
        //_imageContainer.clipsToBounds=true
        _imageContainer.layer.shadowColor = UIColor.blackColor().CGColor
        _imageContainer.layer.shadowOpacity = 0.3
        _imageContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        _imageContainer.layer.shadowRadius = 5
        
        _bgImageV.frame = CGRect(x: 0, y: 0, width: _imageW, height: _imageW)
        _bgImageV.contentMode = UIViewContentMode.ScaleAspectFill
        _bgImageV.layer.masksToBounds=true
        _bgImageV.layer.cornerRadius = _cornerRadius
        _bgImageV.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        _imageContainer.addSubview(_bgImageV)
        
        
        
        
    
        self.view.addSubview(_imageContainer)
        self.view.addSubview(_drawingBoard!.view)
        self.view.addSubview(_btn_camera)
        self.view.addSubview(_btn_photo)
        self.view.addSubview(_btn_send)
        self.view.addSubview(_btn_reset)

        
    }
    
    func buttonAction(__sender:UIButton){
        switch __sender{
        case _btn_camera:
            _imagePicker = UIImagePickerController()
           // _imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
            
            //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
            _imagePicker!.delegate = self
            _imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
            break
        case _btn_photo:
            _imagePicker = UIImagePickerController()
            
            //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
            //_imagePicker!.allowsEditing=false
            _imagePicker!.delegate = self
            _imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
            break
        case _btn_reset:
            _drawingBoard?._clear()
            break
        case _btn_send:
            
            break
        default:
            break
        }
    }
    
    //---——展示
    
    func _show(){
        _btnsShow()
    }
    
    func _bottomBtnsIn(){
        self._btn_reset.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
        self._btn_send.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
        self._btn_reset.transform = CGAffineTransformMakeScale(1, 1)
        self._btn_send.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_reset.alpha=0
        self._btn_send.alpha=0
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_reset.center = CGPoint(x: 60, y: self.view.frame.height-50)
            self._btn_send.center = CGPoint(x: self.view.frame.width-60, y: self.view.frame.height-50)
            
             self._btn_reset.transform = CGAffineTransformMakeRotation(2*3.14)
            self._btn_reset.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_send.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_reset.alpha=1
            self._btn_send.alpha=1
            }) { (stoped) -> Void in
                
        }
    }
    func _bottomBtnsOut(){
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_reset.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
            self._btn_send.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
            self._btn_reset.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_send.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_reset.alpha=0
            self._btn_send.alpha=0
            }) { (stoped) -> Void in
                
        }
    }
    //---按钮弹出
    func _btnsShow(){
        UIView.animateWithDuration(0.6, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera.center = CGPoint(x: self.view.frame.width/2-self._btnW/2-10, y: self.view.frame.height/2)
            self._btn_photo.center = CGPoint(x: self.view.frame.width/2+self._btnW/2+10, y: self.view.frame.height/2)
            self._btn_camera.alpha=1
            self._btn_photo.alpha=1
        }) { (stoped) -> Void in
            
        }
    }
    
    func _btnsHide(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self._btn_photo.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self._btn_camera.alpha=0
            self._btn_photo.alpha=0
            }) { (stoped) -> Void in
                
        }
    }
    
    //----
    func _reset(){
        _btnsHide()
        _bottomBtnsOut()
    }
    func _shouldBeClosed()->Bool{
        if _hasImg{
            _bgImageV.image = UIImage()
            _hasImg = false
            _bottomBtnsOut()
            _btnsShow()
            _drawingBoard?._clear()
            _drawingBoard!._setEnabled(false)
            return false
        }
        return true
    }
    //---picker代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        _bgImageV.image = image
        _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        didImageIn()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       // var _alassetsl:ALAssetsLibrary = ALAssetsLibrary()
        let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        _bgImageV.image = image
        _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        didImageIn()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        _imagePicker?.dismissViewControllerAnimated(true, completion:nil)
    }
    func didImageIn(){
        _btnsHide()
        _hasImg = true
        _drawingBoard!._setEnabled(true)
        _delagate?._edingImageIn()
        _bottomBtnsIn()
    }
    
}