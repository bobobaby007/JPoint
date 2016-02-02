//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation


protocol ImageViewerDelegate:NSObjectProtocol{
    func _imageViewer_canceled()
    func _mageViewer_saved()
}

class ImageViewer: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var _picV:PicView?
    var _setuped:Bool = false
    var _imagePicker:UIImagePickerController?
    var _bg:UIView?
    weak var _parentViewController:UIViewController?
    var _btn_save:UIButton?
    var _btn_cancel:UIButton?
    
    var _imageIned:Bool = false
    
    weak var _delegate:ImageViewerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor = UIColor.clearColor()
        _bg = UIView(frame: self.view.frame)
        _bg?.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        _picV=PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _picV!._scaleType = PicView._ScaleType_Fit
        
        
        _btn_save = UIButton(frame: CGRect(x: self.view.frame.width - 100 - 10, y: self.view.frame.height - 50, width: 100, height: 40))
        _btn_save?.titleLabel?.textAlignment = NSTextAlignment.Right
        _btn_save?.setTitle("确认", forState: UIControlState.Normal)
        _btn_save?.hidden = true
        
        _btn_save?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_cancel = UIButton(frame: CGRect(x: 10, y: self.view.frame.height - 50, width: 100, height: 40))
        _btn_cancel?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.titleLabel?.textAlignment = NSTextAlignment.Left
        
        _setuped=true
    }
    
    func _setPic(__pic:NSDictionary){
        _picV?._setPic(__pic, __block: { (__dict) -> Void in
            
        })
        
        self.view.addSubview(_picV!)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // var _alassetsl:ALAssetsLibrary = ALAssetsLibrary()
        let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        _picV?._setImageByImage(image)
        _picV?.setZoomScale(1, animated: false)
        _imagePicker!.view.addSubview(_bg!)
        _imagePicker!.view.addSubview(_picV!)
        
        _imagePicker!.view.addSubview(_btn_cancel!)
        _imagePicker!.view.addSubview(_btn_save!)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        _imagePicker?.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    
    func _openPhotoLibrary(){
        _imagePicker = UIImagePickerController()
        
        //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
        //_imagePicker!.allowsEditing=false
        _imagePicker!.delegate = self
        _imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        _parentViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
        
        //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
    }
    
    
    func buttonAction(__sender:UIButton){
        print(__sender)
        
        switch __sender{
        case _btn_cancel!:
            _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
            
            break
        case _btn_save!:
            _imagePicker?.dismissViewControllerAnimated(true, completion:nil)
            _delegate?._mageViewer_saved()
            break
            
        default:
            break
        }
    }
    func _originalImage()->UIImage{
        return _picV!._imgView!.image!
    }
    func _captureBgImage()->UIImage{
        //let _scale:CGFloat = 2*UIScreen.mainScreen().scale
        
        
        UIGraphicsBeginImageContextWithOptions(_picV!.contentSize, _picV!.opaque, 0.0);
        _picV!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        //_bgImageV!.layer.drawInRect(CGRect(x: 0, y:0, width: _bgImageV!.frame.size.width, height: _bgImageV!.frame.size.height))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(_picV!.frame.size, false, 0.0)
        
        img.drawInRect(CGRect(x: -_picV!.contentOffset.x, y: -_picV!.contentOffset.y, width: _picV!.contentSize.width, height: _picV!.contentSize.height))
        
        let img2:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return img2;
    }
    
    override func viewWillDisappear(animated: Bool) {
        //_currentPic?.removeGestureRecognizer(_tapG!)
    }
}
