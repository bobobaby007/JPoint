//
//  ImageInputer.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/30.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol ImageInputerDelegate:NSObjectProtocol{
    func _imageInputer_canceled()
    func _imageInputer_saved()
}


class ImageInputer:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImagesPickerDeletegate {
    static var _ImageType_photo:String = "photo"
    static var _ImageType_camera:String = "camera"
    static var _ImageType_multipleImages:String = "multipleImages"
    
    static var _ShowingType_fullSize:String = "fullSize"
    static var _ShowingType_cut:String = "cut"
    
    var _imageW:CGFloat = 50
    var _imageType:String = ""
    
    var _showingType:String = ""
    
    var  _btnW:CGFloat = 50
    
    var _btn_camera:UIButton?
    var _btn_photo:UIButton?
    var _setuped:Bool = false
    var _bordV:UIView?
    
    
    var _bgImageV:PicView?
    
    var _imagePicker:UIImagePickerController?
    
    var _imagesPicker:ImagesPicker?//----多图选择
    
    weak var _parentViewController:UIViewController?
    
    //var _blurV:UIVisualEffectView?
    
   
    var _btn_save:UIButton?
    var _btn_cancel:UIButton?
    
    var _bg:UIView?
    var _imageIned:Bool = false
    
    weak var _delegate:ImageInputerDelegate?
    
    var _buttonBg:UIView?
    
    
    var _imagesMultiple:ImagesMultiple?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        if _setuped{
            return
        }
    
        self.view.backgroundColor = UIColor.clearColor()
        _bg = UIView(frame: self.view.frame)
        _bg?.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        _imageW = self.view.frame.width
        
        _btn_camera = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        
        _btn_camera?.layer.borderWidth = 2
        _btn_camera?.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_camera?.layer.cornerRadius = _btnW/2
        _btn_camera?.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 116/255, alpha: 1)
        _btn_camera?.center = CGPoint(x: self.view.frame.width/2-_btnW*0.75, y: self.view.frame.height/2)
        _btn_camera?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_photo = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_photo?.layer.borderWidth = 2
        _btn_photo?.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_photo?.layer.cornerRadius = _btnW/2
        _btn_photo?.backgroundColor = UIColor(red: 198/255, green: 87/255, blue: 255/255, alpha: 1)
        _btn_photo?.center = CGPoint(x: self.view.frame.width/2+_btnW*0.75, y: self.view.frame.height/2)
        _btn_photo?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        var _img:UIImage = UIImage(named: "carera_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_camera!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        _img = UIImage(named: "photo_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_photo!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        
        
        _bgImageV = PicView(frame: CGRect(x: 0, y: 0, width: _imageW, height: _imageW))
        _bgImageV?._scaleType = PicView._ScaleType_Full
        _bgImageV?.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        _bgImageV?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        
        _bordV = UIView(frame: CGRect(x: 0, y: 0, width: _imageW, height: _imageW))
        _bordV?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        _bordV?.backgroundColor = UIColor.clearColor()
        _bordV?.userInteractionEnabled = false
        _bordV?.layer.borderColor = UIColor.whiteColor().CGColor
        _bordV?.layer.borderWidth = 1
        
        _btn_save = UIButton(frame: CGRect(x: self.view.frame.width - 100 - 10, y: 0, width: 100, height: 50))
        _btn_save?.titleLabel?.textAlignment = NSTextAlignment.Right
        _btn_save?.setTitle("确认", forState: UIControlState.Normal)
        _btn_save?.hidden = true
        
        _btn_save?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_cancel = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: 50))
        _btn_cancel?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.titleLabel?.textAlignment = NSTextAlignment.Left
        
        
        _buttonBg = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        _buttonBg?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        _buttonBg?.addSubview(_btn_save!)
        _buttonBg?.addSubview(_btn_cancel!)
        
        self.view.addSubview(_bg!)
        self.view.addSubview(_buttonBg!)
        self.view.addSubview(_btn_camera!)
        self.view.addSubview(_btn_photo!)
        
        
        
        _setuped = true
        
    }
    
    func _showBtns(){
        
    }
    func _hideBtns(){
        _btn_camera?.hidden = true
        _btn_photo?.hidden = true
    }
    
    func _setType(__type:String){
        _showingType = __type
        switch _showingType{
        case ImageInputer._ShowingType_cut:
            _bgImageV?.frame = CGRect(x: 0, y: 0, width: _imageW, height: _imageW)
            _bgImageV?.backgroundColor = UIColor(white: 0, alpha: 0.3)
            _bgImageV?._scaleType = PicView._ScaleType_Full
            
            _bgImageV?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            
            _bordV?.layer.borderWidth = 1
            break
        case ImageInputer._ShowingType_fullSize:
            _bgImageV?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            _bgImageV?.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            _bgImageV?._scaleType = PicView._ScaleType_Fit
            
            
            _bordV?.layer.borderWidth = 0
            break
        case ImageInputer._ImageType_multipleImages:
            
            break
        default:
            break
            
        }
    }
    func _openCamera(){
        _bgImageV?.hidden = true
        _buttonBg?.hidden = true
        
        _imageType = ImageInputer._ImageType_camera
        _imagePicker = UIImagePickerController()
        // _imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
        
        //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
        _imagePicker!.delegate = self
        _imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
        
        
        
        _parentViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
        //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
    }
    func _openPhotoLibrary(){
        _bgImageV?.hidden = true
        _buttonBg?.hidden = true
        
        _imageType = ImageInputer._ImageType_photo
        _imagePicker = UIImagePickerController()
        
        //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
        //_imagePicker!.allowsEditing=false
        _imagePicker!.delegate = self
        _imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        _parentViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
        
        //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
    }
    
    func _openImagesPicker(){
        
        _bgImageV?.hidden = true
        _buttonBg?.hidden = true
        
        _imageType = ImageInputer._ImageType_multipleImages
        
        
        //_imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.SavedPhotosAlbum)!
        //_imagePicker!.allowsEditing=false
        
        if _imagesPicker == nil{
            _imagesPicker = ImagesPicker()
            
        }
        _imagesPicker?._delegate = self
        if _parentViewController != nil{
            _parentViewController!.presentViewController(_imagesPicker!, animated: true, completion:nil)
        }
        //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(_imagePicker!, animated: true, completion:nil)
    }
    
    //----多图选择代理
    func imagesPickerDidSelected(images: NSArray) {
        _bgImageV?.hidden = false
        _buttonBg?.hidden = false
        
        _imagesPicker!.view.addSubview(_bg!)
        _imagesPicker!.view.addSubview(_bgImageV!)
        _imagesPicker!.view.addSubview(_bordV!)
        _imagesPicker!.view.addSubview(_buttonBg!)
        _imageIned = true
    
        _btn_save?.hidden = false
        _hideBtns()

    
        if _imagesMultiple == nil{
            _imagesMultiple = ImagesMultiple(frame: CGRect(x: 0, y: 0, width: _imageW, height: _imageW))
            
        }
        _imagesMultiple?._setImages(images)
        
        _bgImageV?.addSubview(_imagesMultiple!)
    }
    func imagesPickerCanceled(){
        _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        _delegate?._imageInputer_canceled()
    }
    
    func buttonAction(__sender:UIButton){
        print(__sender)
        
        switch __sender{
        case _btn_camera!:
            _openCamera()
        
            break
        case _btn_photo!:
            _openPhotoLibrary()
            break
        case _btn_cancel!:
            
            if _imageIned{
                self.view.addSubview(_bg!)
                self.view.addSubview(_buttonBg!)
                self.view.addSubview(_btn_camera!)
                self.view.addSubview(_btn_photo!)
                _bgImageV!.removeFromSuperview()
                _imagesMultiple?.removeFromSuperview()
                _bordV?.removeFromSuperview()
                _imageIned = false
            }else{
                _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
                _delegate?._imageInputer_canceled()
            }
            
            break
        case _btn_save!:
            _imagePicker?.dismissViewControllerAnimated(true, completion:nil)
            _imagesPicker?.dismissViewControllerAnimated(true, completion:nil)
            _delegate?._imageInputer_saved()
            break
        
        default:
            break
        }
    }
    //---picker代理
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        _bgImageV?._setImageByImage(image)
//        _bgImageV?.setZoomScale(1, animated: false)
//       // _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
//        
//        _imagePicker!.view.addSubview(_bg!)
//        _imagePicker!.view.addSubview(_btn_save!)
//        _imagePicker!.view.addSubview(_btn_cancel!)
//        _imagePicker!.view.addSubview(_bgImageV!)
//        _imagePicker!.view.addSubview(_bordV!)
//        _imageIned = true
//        
//        _btn_save?.hidden = false
//        _hideBtns()
//    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // var _alassetsl:ALAssetsLibrary = ALAssetsLibrary()
        let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        _bgImageV?._setImageByImage(image)
        _bgImageV?.setZoomScale(1, animated: false)
        
        
        
        //_imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        
        _bgImageV?.hidden = false
        _buttonBg?.hidden = false
        
        if _imagePicker?.sourceType == UIImagePickerControllerSourceType.Camera{
            _imagePicker?.dismissViewControllerAnimated(true, completion: nil)
            self.view.addSubview(_bg!)
            self.view.addSubview(_bgImageV!)
            self.view.addSubview(_bordV!)
            self.view.addSubview(_buttonBg!)
        }else{
            _imagePicker!.view.addSubview(_bg!)
            _imagePicker!.view.addSubview(_bgImageV!)
            _imagePicker!.view.addSubview(_bordV!)
            _imagePicker!.view.addSubview(_buttonBg!)
            _imageIned = true
        }
        _btn_save?.hidden = false
        _hideBtns()        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        _imagePicker?.dismissViewControllerAnimated(true, completion:nil)
        _delegate?._imageInputer_canceled()
    }
    func _originalImage()->UIImage{
        return _bgImageV!._imgView!.image!
    }
    func _captureBgImage()->UIImage{
        //let _scale:CGFloat = 2*UIScreen.mainScreen().scale
        if _imageType == ImageInputer._ImageType_multipleImages{
            return CoreAction._captureImage(_imagesMultiple!)
        }
        
        UIGraphicsBeginImageContextWithOptions(_bgImageV!.contentSize, _bgImageV!.opaque, 0.0);
        _bgImageV!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        //_bgImageV!.layer.drawInRect(CGRect(x: 0, y:0, width: _bgImageV!.frame.size.width, height: _bgImageV!.frame.size.height))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(_bgImageV!.frame.size, false, 0.0)
        
        img.drawInRect(CGRect(x: -_bgImageV!.contentOffset.x, y: -_bgImageV!.contentOffset.y, width: _bgImageV!.contentSize.width, height: _bgImageV!.contentSize.height))
        
        let img2:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return img2;
    }
    
    
}
