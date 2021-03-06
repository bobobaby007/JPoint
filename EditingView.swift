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
    func _editingImageIn()
    func _editingClearImage()
    func _editingSent(__dict:NSDictionary)
}

class EditingView:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageInputerDelegate,DrawingBoard_delagate,EULA_delegate,MyAlerter_delegate{
    
    var _imageAction:String = "setPic" //----setPic/setWelfare
    var _alerter:MyAlerter?
    
    let _gap:CGFloat = 10
    let _btnW:CGFloat = 60
    var _setuped:Bool = false
    var _cornerRadius:CGFloat = 10
    var _btn_camera:UIButton?
    var _btn_photo:UIButton?
    var _btn_more:UIButton?
    var _btn_welfare:UIButton?//----福利按钮
    var _welfare_icon:UIImageView?//---福利icon
    
    var _hasWelfare:Bool = false
    
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
    
    var _infoForImage:InfoForImage?//----用户信息
    
    var _isSending:Bool = false
    var _tipsV:UIButton?
    
    var _sentDict:NSDictionary? //----刚刚发送成功后返回的
    
    var _welfareImg:UIImage?
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
        _btn_camera?.center = CGPoint(x: self.view.frame.width/2-_gap-_btnW, y: self.view.frame.height/2+20)
        _btn_camera?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_photo = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_photo?.layer.borderWidth = 2
        _btn_photo?.layer.borderColor = UIColor(white: 1, alpha: 0.9).CGColor
        _btn_photo?.layer.cornerRadius = _btnW/2
        //_btn_photo?.backgroundColor = UIColor(red: 198/255, green: 87/255, blue: 255/255, alpha: 1)
        _btn_photo?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        _btn_photo?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2+20)
        _btn_photo?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_more = UIButton(frame:CGRect(x: 0, y: 0, width: _btnW, height: _btnW))
        _btn_more?.layer.borderWidth = 2
        _btn_more?.layer.borderColor = UIColor(white: 1, alpha: 0.9).CGColor
        _btn_more?.layer.cornerRadius = _btnW/2
        _btn_more?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        _btn_more?.center = CGPoint(x: self.view.frame.width/2+_gap+_btnW, y: self.view.frame.height/2+20)
        _btn_more?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
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
        self._btn_camera!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_photo!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_more!.transform = CGAffineTransformMakeScale(0, 0)
        
        
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
        
        _img = UIImage(named: "morephoto_icon.png")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: _btnW*2, height: _btnW*2), false, 1)
        _img.drawInRect(CGRect(x: _btnW/2, y: _btnW/2, width: _btnW, height: _btnW))
        _btn_more!.setImage(UIGraphicsGetImageFromCurrentImageContext(), forState: UIControlState.Normal)
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
        
        
        _welfare_icon = UIImageView(frame:CGRect(x: _imageContainer!.frame.origin.x+_imageContainer!.frame.width-39+2, y: _imageContainer!.frame.origin.y-2, width: 39, height: 39))
        _welfare_icon?.image = UIImage(named: "welfare_icon_btn")
        
        
        _welfare_icon?.userInteractionEnabled = false
        
        _btn_welfare = UIButton(frame:CGRect(x: _imageContainer!.frame.origin.x+_imageContainer!.frame.width-39+2+4, y: _imageContainer!.frame.origin.y-2+4, width: 30, height: 30))
        _btn_welfare?.clipsToBounds = true
        _btn_welfare?.layer.cornerRadius = 30/2
        _btn_welfare?.backgroundColor = UIColor.clearColor()
       
        
        _btn_welfare?.contentMode = UIViewContentMode.ScaleToFill
        //_btn_welfare?.setTitle("福利", forState: UIControlState.Normal)
        _btn_welfare?.titleLabel?.font = UIFont.systemFontOfSize(10)
        _btn_welfare?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
    
        self.view.addSubview(_imageContainer!)
        
        self.view.addSubview(_btn_camera!)
        self.view.addSubview(_btn_photo!)
        self.view.addSubview(_btn_more!)
        self.view.addSubview(_btn_send!)
        self.view.addSubview(_btn_clear!)
        self.view.addSubview(_infoForImage!)
        self.view.addSubview(_welfare_icon!)
        self.view.addSubview(_btn_welfare!)
        
//        self.view.layer.shadowColor = UIColor.blackColor().CGColor
//        self.view.layer.shadowOpacity = 0.2
//        self.view.layer.shadowRadius = 5

        //_setProfilePic("profile")
    }
    
    func buttonAction(__sender:UIButton){
        switch __sender{
        case _btn_camera!:
             _imageAction = "setPic"
            _openImageInputer()
            _imageInputer?._setType(ImageInputer._ShowingType_cut)
            _imageInputer?._hideBtns()
            _imageInputer?._openCamera()
            break
        case _btn_photo!:
            _imageAction = "setPic"
            _openImageInputer()
            _imageInputer?._setType(ImageInputer._ShowingType_cut)
            _imageInputer?._hideBtns()
            _imageInputer?._openPhotoLibrary()
            break
        case _btn_more!:
            _imageAction = "setPic"
            _openImageInputer()
            _imageInputer?._setType(ImageInputer._ShowingType_cut)
            _imageInputer?._hideBtns()
            _imageInputer?._openImagesPicker()
            break
        case _btn_clear!:
            _drawingBoard?._clear()
            _btnsHide()
            _bottomBtnsOut()
            break
        case _btn_welfare!:
            _openWelfareAction()
            break
        case _btn_send!:
            
            if ViewController._self!._checkUserInfo(){
                
            }else{
                return
            }
            
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            if let _accepted:Bool = _ud.objectForKey("EULA_accepted") as? Bool{
               
                if _accepted{
                    _sentBingo()
                }else{
                    _showEULA()
                }
                
            }else{
                _showEULA()
                break
            }
            
            break
        default:
            break
        }
    }
    
    //----弹出福利选择
    func _openWelfareAction(){
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        
                 
        ViewController._self!.addChildViewController(_alerter!)
        ViewController._self!.view.addSubview(_alerter!.view)
        ViewController._self!._shouldPan = false
        if _hasWelfare{
            _alerter?._setMenus(["替换图片","清除图片"])
        }else{
            _alerter?._setMenus(["添加图片(Bingo后发送)"])
        }
        
        _alerter?._show()
    }
    //----弹出选择按钮代理
    func _myAlerterClickAtMenuId(__id: Int) {
        switch __id{
        case 0:
             _imageAction = "setWelfare"
            _openImageInputer()
            _imageInputer?._hideBtns()
            _imageInputer?._setType(ImageInputer._ShowingType_fullSize)
            _imageInputer?._openPhotoLibrary()
            break
        case 1:
            _clearWelfare()
            break
        case 2://
            
            break
        default:
            break
        }
    }
    func _myAlerterDidClose(){
        ViewController._self?._shouldPan = true
        _alerter = nil
    }
    
    
    //----展示协议
    
    func _showEULA(){
        let _controller:EULA = EULA()
        _controller._delegate = self
        self.presentViewController(_controller, animated: true) { () -> Void in
            
        }
    }
    func _EULA_accepted(){
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        _ud.setObject(true, forKey: "EULA_accepted")
        self._sentBingo()
    }
    
    
    
    func _sentBingo(){
        
        if _isSending{
            return
        }
        _isSending = true
        
        let _img:UIImage = self._captureBgImage()
        let _answerImg:UIImage = self._drawingBoard!._captureImage()
        
        MainAction._postNewBingo(_img, __question: _infoForImage!._getQuestion(), __answer: _answerImg, __type: MainAction._Post_Type_Media ,__block: { (__dict) -> Void in
            
            self._isSending = false
         
            if __dict.objectForKey("recode") as! Int == 200{
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self._sentDict = __dict.objectForKey("info") as? NSDictionary
                    
                    self._checkWelfare()
                })
            }else{
                
                if (__dict.objectForKey("recode") as? Int) < 0{
                    dispatch_async(dispatch_get_main_queue(), {
                        ViewController._self!._showAlert("链接失败，请检查网络",__wait: 3.5)
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    ViewController._self!._showAlert("上传失败，请重试",__wait: 3.5)
                    
                    print("上传失败，请重试:",__dict)
                })
            }
        })
    }
    func _checkWelfare(){
        if _hasWelfare{
            MainAction._uploadWelfareOfPic(_welfareImg!, __bingoId: _sentDict?.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                if __dict.objectForKey("recode") as! Int == 200{
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self._sentOk()
                    })
                }else{
                    
                    if (__dict.objectForKey("recode") as? Int) < 0{
                        dispatch_async(dispatch_get_main_queue(), {
                            ViewController._self!._showAlert("链接失败，请检查网络",__wait: 3.5)
                        })
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        ViewController._self!._showAlert("上传失败，请重试",__wait: 3.5)
                        print("上传失败，请重试:",__dict)
                    })
                }
            })
        }else{
            self._sentOk()
        }
        
    }
    //--发送成功
    func _sentOk(){
        ViewController._self!._showAlert("图片提交成功，可以再来一张!",__wait: 1.5)
        self._delagate?._editingSent(_sentDict!)
        //self._reset()
        self._clearImage()
        self._clearWelfare()
    }
    
    func _setProfilePic(__str:String){
        _infoForImage?._setPic(__str)
    }
    //---——展示
    func _show(){
        self._infoForImage!._setPic(MainAction._avatar( MainAction._Profile()))
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
        _label_cancel?.alpha = 0
        self.view.addSubview(_label_cancel!)
        
        _label_cancel?.text = "返回"
        self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW)
        self._label_cancel?.alpha = 0
        
        self._btn_camera!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_photo!.transform = CGAffineTransformMakeScale(0, 0)
        self._btn_more!.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera?.transform = CGAffineTransformMakeScale(1, 1)
            }) { (Comparable) -> Void in
                
        }
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_photo?.transform = CGAffineTransformMakeScale(1, 1)
            }) { (Comparable) -> Void in
                
        }
        UIView.animateWithDuration(0.3, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_more?.transform = CGAffineTransformMakeScale(1, 1)
            }) { (Comparable) -> Void in
                
        }
        
        
        UIView.animateWithDuration(0.6, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._label_cancel?.center = CGPoint(x: self.view.frame.width/2, y: self._btn_closeH!+self._btnW/2+15)
            self._label_cancel?.alpha = 1
        }) { (stoped) -> Void in
            
        }
    }
    
    func _btnsHide(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._btn_camera?.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_photo?.transform = CGAffineTransformMakeScale(0, 0)
            self._btn_more?.transform = CGAffineTransformMakeScale(0, 0)
            
            
            
            self._label_cancel?.alpha = 0
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
        switch _imageAction{
            case "setPic":
                _bgImageV!.image = _imageInputer!._captureBgImage()
                _imageInputer?.view.removeFromSuperview()
                _imageInputer?.removeFromParentViewController()
                _imageInputer = nil
                
                didImageIn()
            break
            case "setWelfare"://--------福利图片，有限定大小
                _welfareImg = CoreAction._fixImage(_imageInputer!._originalImage(), __toSize: CGSize(width: 800, height: 1000))
                _btn_welfare?.setImage(_welfareImg, forState: UIControlState.Normal)
                
                _btn_welfare?.setTitle("", forState: UIControlState.Normal)
                _imageInputer?.view.removeFromSuperview()
                _imageInputer?.removeFromParentViewController()
                _imageInputer = nil
                _hasWelfare = true
            break
        default:
            break
        }
    }
    
    //----
    func _reset(){
        _btnsHide()
        _bottomBtnsOut()
        _infoForImage?._setSay((_infoForImage?._placeHold)!)
        _hideTips()
        _removeDrawing()
        self._label_cancel?.alpha = 0
        
        
    }
    
    func _drawingBoardIn(){
        if _drawingBoard == nil{
            _drawingBoard = DrawingBoard()
            _drawingBoard?.view.layer.cornerRadius = _cornerRadius
            _drawingBoard?.view.clipsToBounds = true
            _drawingBoard?._delegate = self
            self.addChildViewController(_drawingBoard!)
            _drawingBoard!.view.frame = _imageContainer!.frame
            _drawingBoard?.setup()
            _drawingBoard!.view.center = _imageContainer!.center
            _drawingBoard?.view.alpha = 0.6
            self.view.addSubview(_drawingBoard!.view)
        }
        
    }
    func _removeDrawing(){
        if _drawingBoard != nil{
            _drawingBoard?._clear()
            _drawingBoard!._setEnabled(false)
            _drawingBoard?.view.removeFromSuperview()
            _drawingBoard?.removeFromParentViewController()
            _drawingBoard = nil
        }
    }
    
    func _shouldBeClosed()->Bool{
        if _hasImg{
            _clearImage()
            return false
        }
        if _hasWelfare{
            _clearWelfare()
        }
        return true
    }
    
    //----清除图片
    
    func _clearImage(){
        _bgImageV!.image = UIImage()
        _hasImg = false
        _bottomBtnsOut()
        _btnsShow()
        _infoForImage?._setSay((_infoForImage?._placeHold)!)
        _removeDrawing()
        _hideTips()
        _delagate!._editingClearImage()
    }
    
    //----清除福利
    func _clearWelfare(){
        
        _btn_welfare?.setImage(UIImage(), forState: UIControlState.Normal)
        if _welfareImg != nil{
            _welfareImg = nil
        }
        
        _hasWelfare = false
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
        _delagate?._editingImageIn()
        _drawingBoardIn()
        _drawingBoard!._setEnabled(true)
        
        self.view.addSubview(_welfare_icon!)
        self.view.addSubview(_btn_welfare!)
        _showTips("在图片上涂鸦你的兴趣点")
    }
    
    //---- 涂鸦板代理
    func _drawingBoardDidStartDraw() {
        _bottomBtnsIn()
        _hideTips()
    }
    
    //------展示提示
    func _showTips(__text:String){
        if _tipsV == nil{
            _tipsV = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
            _tipsV?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 + 20 + _imageContainer!.frame.height/2 - 40)
            _tipsV?.clipsToBounds = true
            _tipsV?.layer.cornerRadius = 5
            _tipsV?.titleLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
            _tipsV?.titleLabel?.textAlignment = NSTextAlignment.Center
            _tipsV?.titleLabel?.font = UIFont.systemFontOfSize(13)
            _tipsV?.setBackgroundImage(UIImage(named: "btn_circle.png"), forState: UIControlState.Normal)
            
            //_tipsV?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
            _tipsV?.setTitleColor(UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5), forState: UIControlState.Normal)
            _tipsV?.backgroundColor = UIColor(white: 1, alpha: 0.8)
            _tipsV?.userInteractionEnabled = false
            _tipsV?.alpha = 0.9
            self.view.addSubview(_tipsV!)
        }
        
        _tipsV?.setTitle(__text, forState: UIControlState.Normal)
        self._tipsV?.transform = CGAffineTransformMakeScale(0.3, 0.3)
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._tipsV?.transform = CGAffineTransformMakeScale(1, 1)
            }) { (stoped) -> Void in
                
        }
    }
    func _hideTips(){
        if _tipsV != nil{
            _tipsV?.removeFromSuperview()
            _tipsV = nil
        }
    }
    
    
}