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

class EditingView:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageInputerDelegate{
    let _gap:CGFloat = 10
    let _btnW:CGFloat = 60
    var _setuped:Bool = false
    var _cornerRadius:CGFloat = 20
    var _btn_camera:UIButton?
    var _btn_photo:UIButton?
    var _btn_clear:UIButton?
    var _btn_send:UIButton?
    var _btn_closeH:CGFloat?
    var _imagePicker:UIImagePickerController?
    
    var _imageContainer:UIView?
    var _imageW:CGFloat = 0
    var _bgImageV:UIImageView?
    
    var _hasImg:Bool = false
    
    var _drawingBoard:DrawingBoard?
    
    var _label_clear:UILabel?
    var _label_sent:UILabel?
    var _label_cancel:UILabel?
    
    weak var _mainView:MainView?
    weak var _delagate:EditingView_delegate?
    
    var _imageInputer:ImageInputer?
    
    var _infoForImage:InfoForImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.clearColor()
        _btn_camera = UIButton(frame: CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        
        _btn_camera?.layer.borderWidth = 2
        _btn_camera?.layer.borderColor = UIColor(white: 1, alpha: 0.9).CGColor
        _btn_camera?.layer.cornerRadius = _btnW/2
        //_btn_camera?.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 116/255, alpha: 1)
        _btn_camera?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        _btn_camera?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
        _btn_camera?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_photo = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_photo?.layer.borderWidth = 2
        _btn_photo?.layer.borderColor = UIColor(white: 1, alpha: 0.9).CGColor
        _btn_photo?.layer.cornerRadius = _btnW/2
        //_btn_photo?.backgroundColor = UIColor(red: 198/255, green: 87/255, blue: 255/255, alpha: 1)
        _btn_photo?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        _btn_photo?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
        _btn_photo?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_clear = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        //_btn_clear?.setImage(UIImage(named: "resetIt"), forState: UIControlState.Normal)
        _btn_clear?.layer.cornerRadius = _btnW/2
        _btn_clear?.backgroundColor = UIColor(red: 95/255, green: 166/255, blue: 202/255, alpha: 1)
        _btn_clear?.center = CGPoint(x: 100, y: self.view.frame.height-100)
        _btn_clear?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_send = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_send?.center = CGPoint(x: self.view.frame.width-100, y: self.view.frame.height-100)
        _btn_send?.layer.cornerRadius = _btnW/2
        _btn_send?.backgroundColor = UIColor(red: 198/255, green: 87/255, blue: 255/255, alpha: 1)
        _btn_send?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self._btn_clear!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_send!.transform = CGAffineTransformMakeScale(0, 0)
        
        _btn_camera!.alpha=0
        _btn_photo!.alpha=0
        _btn_clear!.alpha=0
        _btn_send!.alpha=0
        
        var _img:UIImage = UIImage(named: "carera_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_camera!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        _img = UIImage(named: "photo_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_photo!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        
        _img = UIImage(named: "okgo")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_send!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        _img = UIImage(named: "resetIt")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_clear!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
        UIGraphicsEndImageContext()
        
        
        _imageW = self.view.frame.width-2*_gap
        _imageContainer = UIView(frame:CGRect(x: 0, y: 0, width: _imageW, height: _imageW))
        _imageContainer?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
        
        
        _drawingBoard = DrawingBoard()
        _drawingBoard?.view.layer.cornerRadius = _cornerRadius
        _drawingBoard?.view.clipsToBounds = true
        
        self.addChildViewController(_drawingBoard!)
        _drawingBoard!.view.frame = _imageContainer!.frame
        _drawingBoard?.setup()
        _drawingBoard!.view.center = _imageContainer!.center
        _drawingBoard?.view.alpha = 0.6
        
        
        
        
        //_imageContainer.layer.masksToBounds = true
        _imageContainer!.backgroundColor = UIColor(white: 1, alpha: 0)
        _imageContainer!.layer.cornerRadius = _cornerRadius
        _imageContainer!.clipsToBounds=true
//        _imageContainer!.layer.shadowColor = UIColor.blackColor().CGColor
//        _imageContainer!.layer.shadowOpacity = 0.3
//        _imageContainer!.layer.shadowOffset = CGSize(width: 0, height: 0)
//        _imageContainer!.layer.shadowRadius = 5
        
        _bgImageV = UIImageView(frame:CGRect(x: 0, y: 0, width: _imageW, height: _imageW))
        _bgImageV?.contentMode = UIViewContentMode.ScaleAspectFill
        _bgImageV?.layer.masksToBounds=true
        //_bgImageV?.layer.cornerRadius = _cornerRadius
        _bgImageV?.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        _imageContainer!.addSubview(_bgImageV!)
        
        _infoForImage = InfoForImage(frame: CGRect(x: 10, y: 0, width: _imageW, height: 110))
        _infoForImage?.center = CGPoint(x: self.view.frame.width/2, y: (self.view.frame.height-_imageW)/4+_infoForImage!.frame.height/2)
        
        
        
    
        self.view.addSubview(_imageContainer!)
        self.view.addSubview(_drawingBoard!.view)
        self.view.addSubview(_btn_camera!)
        self.view.addSubview(_btn_photo!)
        self.view.addSubview(_btn_send!)
        self.view.addSubview(_btn_clear!)
        self.view.addSubview(_infoForImage!)
        
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.2
        self.view.layer.shadowRadius = 5

        _setProfilePic("profile")
    }
    
    func buttonAction(__sender:UIButton){
        switch __sender{
        case _btn_camera!:
            _openImageInputer()
            _imageInputer?._hideBtns()
            _imageInputer?._openCamera()
            break
        case _btn_photo!:
            _openImageInputer()
            _imageInputer?._hideBtns()
            _imageInputer?._openPhotoLibrary()
            
            break
        case _btn_clear!:
            _drawingBoard?._clear()
            break
        case _btn_send!:
            let _img:UIImage = _captureBgImage()
            let _answerImg:UIImage = _drawingBoard!._captureImage()
            MainAction._postNewBingo(_img, __question: _infoForImage!._getQuestion(), __answer: _answerImg, __type: MainAction._Post_Type_Media)
            _mainView?._showAlert("图片已经提交，可以再来一张!",__wait: 0.5)
            if _shouldBeClosed(){
                
            }else{
                
            }
            
            break
        default:
            break
        }
    }
    
    func _setProfilePic(__str:String){
        _infoForImage?._setPic(__str)
    }
    
    
    //---——展示
    
    func _show(){
        _btnsShow()
    }
    
    func _bottomBtnsIn(){
        self._btn_clear!.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!)
        self._btn_send!.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!)
        self._btn_clear!.transform = CGAffineTransformMakeScale(1, 1)
        self._btn_send!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_clear!.alpha=0
        self._btn_send!.alpha=0
        
        
        if _label_clear == nil{
            _label_clear = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: self.view.frame.height - self._btn_closeH! - self._btnW/2))
            _label_clear?.center = CGPoint(x: 60, y: self.view.frame.height)
            _label_clear?.text = "清除"
            _label_clear?.textAlignment = NSTextAlignment.Center
            _label_clear?.font = UIFont.systemFontOfSize(12)
            _label_clear?.textColor = UIColor.whiteColor()
        }
        
        self.view.addSubview(_label_clear!)
        
        if _label_sent == nil{
            _label_sent = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: self.view.frame.height - self._btn_closeH! - self._btnW/2))
            _label_sent?.center = CGPoint(x: self.view.frame.width-60, y: self.view.frame.height)
            _label_sent?.text = "立即发布"
            _label_sent?.textAlignment = NSTextAlignment.Center
            _label_sent?.font = UIFont.systemFontOfSize(12)
            _label_sent?.textColor = UIColor.whiteColor()
        }
        self.view.addSubview(_label_sent!)
        
        
        self._label_clear?.center = CGPoint(x: 60, y: self._btn_closeH!+self._btnW)
        _label_clear?.alpha = 0
        
        _label_cancel?.text = "换一张图片"
        self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW)
        self._label_cancel?.alpha = 0
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_clear!.center = CGPoint(x: 60, y: self._btn_closeH!)
            self._btn_send!.center = CGPoint(x: self.view.frame.width-60, y: self._btn_closeH!)
            
            
            self._label_clear?.center = CGPoint(x: 60, y: self._btn_closeH!+self._btnW/2+15)
            self._label_clear?.alpha = 1
            
            self._label_sent?.center = CGPoint(x: self.view.frame.width-60, y: self._btn_closeH!+self._btnW/2+15)
            self._label_sent?.alpha = 1
            
            self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW/2+15)
            self._label_cancel?.alpha = 1
             self._btn_clear!.transform = CGAffineTransformMakeRotation(2*3.14)
            self._btn_clear!.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_send!.transform = CGAffineTransformMakeScale(1, 1)
            self._btn_clear!.alpha=1
            self._btn_send!.alpha=1
            }) { (stoped) -> Void in
                
        }
    }
    //---底部两个按钮移出
    func _bottomBtnsOut(){
        
        if _label_clear != nil{
            _label_clear!.removeFromSuperview()
            _label_clear = nil
        }
        if _label_sent != nil{
            _label_sent!.removeFromSuperview()
            _label_sent = nil
        }
        
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_clear!.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
            self._btn_send!.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
            self._btn_clear!.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_send!.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_clear!.alpha=0
            self._btn_send!.alpha=0
            
            }) { (stoped) -> Void in
                

                
        }
    }
    //---按钮弹出
    func _btnsShow(){
        if _label_cancel == nil{
            _label_cancel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: self.view.frame.height - self._btn_closeH! - self._btnW/2))
            _label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height)
            
            _label_cancel?.textAlignment = NSTextAlignment.Center
            _label_cancel?.font = UIFont.systemFontOfSize(12)
            _label_cancel?.textColor = UIColor.whiteColor()
        }
        self.view.addSubview(_label_cancel!)
        
        _label_cancel?.text = "返回"
        self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW)
        self._label_cancel?.alpha = 0
        
        UIView.animateWithDuration(0.6, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera!.center = CGPoint(x: self.view.frame.width/2-self._btnW/2-20, y: self.view.frame.height/2+20)
            self._btn_photo!.center = CGPoint(x: self.view.frame.width/2+self._btnW/2+20, y: self.view.frame.height/2+20)
            self._btn_camera!.alpha=1
            self._btn_photo!.alpha=1
            
            self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW/2+15)
            self._label_cancel?.alpha = 1
        }) { (stoped) -> Void in
            
        }
    }
    
    func _btnsHide(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera!.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
            self._btn_photo!.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
            self._btn_camera!.alpha=0
            self._btn_photo!.alpha=0
            }) { (stoped) -> Void in
                
        }
    }
    
    func _openImageInputer(){
        if _imageInputer == nil{
            _imageInputer = ImageInputer()
            _imageInputer?._parentViewController = self
            _imageInputer?._delegate = self
            _mainView!.addChildViewController(_imageInputer!)
            _mainView!.view.addSubview(_imageInputer!.view)
            _mainView?._shouldReceivePan = false
        }
    }
    
    //-----imageinputer 代理
    func _imageInputer_canceled() {
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
        _mainView?._shouldReceivePan = true
    }
    
    func _imageInputer_saved() {
        _bgImageV!.image = _imageInputer!._captureBgImage()
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
        
        didImageIn()
    }
    
    //----
    func _reset(){
        _btnsHide()
        _bottomBtnsOut()
        self._label_cancel?.alpha = 0
    }
    func _shouldBeClosed()->Bool{
        if _hasImg{
            _bgImageV!.image = UIImage()
            _hasImg = false
            _bottomBtnsOut()
            _btnsShow()
            _drawingBoard?._clear()
            _drawingBoard!._setEnabled(false)
            return false
        }
        return true
    }
    //---截取背景图
    func _captureBgImage()->UIImage{
        UIGraphicsBeginImageContextWithOptions(_bgImageV!.bounds.size, view.opaque, 0.0);
        _bgImageV!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    
    func didImageIn(){
        _btnsHide()
        _hasImg = true
        _drawingBoard!._setEnabled(true)
        _delagate?._edingImageIn()
        _bottomBtnsIn()
    }
    
}