//
//  LeftPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/23.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class LeftPanel: UIViewController,MyImageList_delegate {
    var _setuped:Bool = false
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _profileImg:PicView?
    var _label_edit:UILabel?
    var _label_name:UILabel?
    
    var _btn_profile:UIButton?
    var _btn_gingoMe:UIButton?
    var _btn_bingoList:UIButton?
    var _btn_imgList:UIButton?
    var _btn_settings:UIButton?
    weak var _parentView:ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        _refreshProfile()
    }
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor = UIColor.whiteColor()
        _bgImg = PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _bgImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _bgImg._refreshView()
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        self.view.addSubview(_bgImg)
        
        
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        _blurV?.frame = self.view.bounds
        self.view.addSubview(_blurV!)
        
        _btn_profile = UIButton(type: UIButtonType.Custom)
        
        _btn_profile!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        _btn_profile?.center = CGPoint(x: self.view.frame.width/2, y: 100)
        _btn_profile?.clipsToBounds = true
        _btn_profile!.layer.cornerRadius = 50
        _btn_profile?.layer.borderWidth = 2
        _btn_profile?.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_profile!.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        //_btn_profile?.backgroundColor = UIColor.clearColor()
        _btn_profile?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _profileImg = PicView()
        
       
        
        
        //let _tapG:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "tapHander:")
        //_profileImg?.addGestureRecognizer(_tapG)
        
        
        //self.view.addSubview(_profileImg!)
        self.view.addSubview(_btn_profile!)
        
        _label_name = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 25))
        _label_name?.textAlignment = NSTextAlignment.Center
        _label_name?.center = CGPoint(x: self.view.frame.width/2, y: 172)
        _label_name?.font = UIFont.systemFontOfSize(20)
        
        _label_name?.textColor = UIColor.whiteColor()
        self.view.addSubview(_label_name!)
        
        _label_edit = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 20))
        _label_edit?.textAlignment = NSTextAlignment.Center
        _label_edit?.center = CGPoint(x: self.view.frame.width/2, y: 200)
        _label_edit?.font = UIFont.systemFontOfSize(14)
        _label_edit?.text = "点击编辑资料"
        _label_edit?.textColor = UIColor.darkGrayColor()
        
        self.view.addSubview(_label_edit!)
        
        let _gapY = (self.view.frame.height-300)/5
        
        
        _btn_gingoMe = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 0.6*_gapY))
        _btn_gingoMe?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_gingoMe?.setImage(UIImage(named: "icon_GotoBingo"), forState: UIControlState.Normal)
        _btn_gingoMe?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-5*_gapY)
        _btn_gingoMe?.setTitle("去猜猜", forState: UIControlState.Normal)
        _btn_gingoMe?.titleLabel?.font = UIFont.systemFontOfSize(20)
        _btn_gingoMe?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_gingoMe?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.view.addSubview(_btn_gingoMe!)
        
        _btn_bingoList = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 0.6*_gapY))
        _btn_bingoList?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_bingoList?.setImage(UIImage(named: "icon_bingo"), forState: UIControlState.Normal)
        _btn_bingoList?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-4*_gapY)
        _btn_bingoList?.setTitle("Bingos", forState: UIControlState.Normal)
        _btn_bingoList?.titleLabel?.font = UIFont.systemFontOfSize(20)
        _btn_bingoList?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_bingoList?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.view.addSubview(_btn_bingoList!)
        
        _btn_imgList = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 0.6*_gapY))
        _btn_imgList?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_imgList?.setImage(UIImage(named: "icon_myList"), forState: UIControlState.Normal)
        _btn_imgList?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-3*_gapY)
        _btn_imgList?.setTitle("我的发布", forState: UIControlState.Normal)
        _btn_imgList?.titleLabel?.font = UIFont.systemFontOfSize(20)
        _btn_imgList?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_imgList?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.view.addSubview(_btn_imgList!)
        
        _btn_settings = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 0.6*_gapY))
        _btn_settings?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_settings?.setImage(UIImage(named: "icon_settings"), forState: UIControlState.Normal)
        _btn_settings?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-2*_gapY)
        _btn_settings?.setTitle("设置", forState: UIControlState.Normal)
        _btn_settings?.titleLabel?.font = UIFont.systemFontOfSize(20)
        _btn_settings?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_settings?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.view.addSubview(_btn_settings!)
        
        
        _setName("Vicky")
        
        //self.view.addSubview(_uiV)
        _setuped = true
    }
    func _refreshProfile(){
        MainAction._getProfile { (__dict) -> Void in
            self._setProfile(__dict)
        }
    }
    
    func _setProfile(__dict:NSDictionary){
        self._setProfileImg(MainAction._avatar(__dict))
        if let _nickname = __dict.objectForKey("nickname") as? String{
            self._setName(_nickname)
        }else{
            self._setName("")
        }
    }
    
    
    
    func _setProfileImg(__str:String){
        _profileImg!._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
            self._btn_profile!.setImage(self._profileImg!._imgView!.image, forState: UIControlState.Normal)
        })
        _bgImg._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        
    }
    func _setName(__str:String){
        if __str == "" {
            
            _label_name?.textColor = UIColor.grayColor()
            _label_name?.text = "呀，还没有名字！"
            
        }else{
            _label_name?.textColor = UIColor.whiteColor()
            _label_name?.text = __str
        }
        
        
    }
    
    //-----我的发布代理
    func _gotoPostOnePic() {
        _parentView?._showMainView()
        _parentView?._mainView?._showEdtingPage()
    }
    
    
    func _swapTo(__distance:CGFloat){
        
    }
    
    func tapHander(sender:UITapGestureRecognizer){
        print(sender, terminator: "")
        switch sender.state{
        case UIGestureRecognizerState.Began:
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._profileImg?.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }) { (stop) -> Void in
                    
            }

            
            break
        case UIGestureRecognizerState.Ended:
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._profileImg?.transform = CGAffineTransformMakeScale(1, 1)
                }) { (stop) -> Void in
                    let _viewC:Settings = Settings()
                    self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                        
                    })
            }
            
            break
        default:
            break
        }
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_imgList!:
            let _viewC:MyImageList = MyImageList()
            _viewC._delegate = self
            _viewC._getData()
            self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                
            })
            break
        case _btn_gingoMe!:
            _parentView?._showMainView()
            break
        case _btn_bingoList!:
            _parentView?._showRight()
            break
        case _btn_settings!:
            let _viewC:Settings = Settings()
            self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                
            })
            break
        case _btn_profile!:
            let _viewC:ProfilePage = ProfilePage()
            _viewC._parentView = self
            self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                
            })
            break
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
