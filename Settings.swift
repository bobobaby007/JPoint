//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Settings:UIViewController,UIAlertViewDelegate{
    var _setuped:Bool = false
    var _topView:UIView?
    let _barH:CGFloat = 60
    var _btn_back:UIButton?
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _nameLabel:UILabel?
    
    let _central_w:CGFloat = 250
    
    var _profile_old:NSDictionary?
    var _btn_logOut:UIButton?
    
    var _btn_contact:UIButton?
    var _btn_clearCache:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.automaticallyAdjustsScrollViewInsets = false
        _bgImg = PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        _bgImg._setPic(NSDictionary(objects: ["bg.jpg","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        //_bgImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        // _bgImg._refreshView()
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        
        
        
        
        self.view.addSubview(_bgImg)
        
        
        
        _topView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topView?.clipsToBounds = true
        _topView?.backgroundColor = UIColor.clearColor()
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        //_blurV?.alpha = 0.5
        _blurV?.frame = _topView!.bounds
        _topView?.addSubview(_blurV!)
        
        _btn_back = UIButton(frame: CGRect(x: 10, y: 20, width: 30, height: 30))
        _btn_back?.center = CGPoint(x: 30, y: _barH/2+6)
        _btn_back?.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        _btn_back?.transform = CGAffineTransformRotate((_btn_back?.transform)!, -3.14*0.5)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _topView?.addSubview(_btn_back!)
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        _nameLabel?.textAlignment = NSTextAlignment.Center
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2 , y: _barH/2+7)
        _nameLabel?.font = UIFont.boldSystemFontOfSize(20)
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.text = "设置"
        
        _topView?.addSubview(_nameLabel!)
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        _btn_clearCache = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        _btn_clearCache?.center = CGPoint(x: self.view.frame.width/2, y:160)
        _btn_clearCache?.setTitle("清空缓存", forState: UIControlState.Normal)
        _btn_clearCache?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        var _line:UIView = UIView(frame: CGRect(x: (self.view.frame.width - _central_w)/2, y: 180, width: _central_w, height: 1))
        _line.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_line)

        
        _btn_contact = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        _btn_contact?.center = CGPoint(x: self.view.frame.width/2, y:220)
        _btn_contact?.setTitle("联系我们", forState: UIControlState.Normal)
        _btn_contact?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _line = UIView(frame: CGRect(x: (self.view.frame.width - _central_w)/2, y: 240, width: _central_w, height: 1))
        _line.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_line)
        
        
        _btn_logOut = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        _btn_logOut?.center = CGPoint(x: self.view.frame.width/2, y:280)
        _btn_logOut?.setTitle("退出帐号", forState: UIControlState.Normal)
        _btn_logOut?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _line = UIView(frame: CGRect(x: (self.view.frame.width - _central_w)/2, y: 300, width: _central_w, height: 1))
        _line.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_line)
        self.view.addSubview(_btn_logOut!)
        
        
        self.view.addSubview(_btn_contact!)
        self.view.addSubview(_btn_clearCache!)
        
       
        
        let _logo:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        _logo.contentMode = UIViewContentMode.ScaleAspectFit
        _logo.image = UIImage(named: "logo_white")
        _logo.center = CGPoint(x: self.view.frame.width/2-43, y: self.view.frame.height - 100)
        
        let _label_appName:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        _label_appName.textColor = UIColor.whiteColor()
        _label_appName.center = CGPoint(x: self.view.frame.width/2+30, y: self.view.frame.height - 100)
        _label_appName.font = UIFont.boldSystemFontOfSize(20)
        _label_appName.text = "BingoMe"
        
        
        
        let _label_version:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        _label_version.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 65)
        _label_version.font = UIFont.systemFontOfSize(16)
        _label_version.textColor = UIColor(white: 0.6, alpha: 1)
        _label_version.textAlignment = NSTextAlignment.Center
        _label_version.text = "\(MainAction._versionString)版本"
        
        
        let _label_intro:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        _label_intro.font = UIFont.systemFontOfSize(12)
        _label_intro.textAlignment = NSTextAlignment.Center
        _label_intro.text = "Beijing Xuyilingdong Network Technology Co., Ltd."
        _label_intro.textColor = UIColor(white: 0.6, alpha: 1)
        _label_intro.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 20)
        
        
        self.view.addSubview(_logo)
        self.view.addSubview(_label_appName)
        self.view.addSubview(_label_version)
        self.view.addSubview(_label_intro)
        
        
        _setuped=true
    }
    
    
    
    func btnHander(sender:UIButton){
        
        switch sender{
        case _btn_back!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        case _btn_clearCache!:
            let _cache = NSCache()
            _cache.removeAllObjects()
            
            let _alertV = UIAlertController(title: "", message: "缓存清除成功", preferredStyle: UIAlertControllerStyle.Alert)
            let _canelAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Cancel, handler: { (atcion) -> Void in
                
            })
            _alertV.addAction(_canelAction)
            self.presentViewController(_alertV, animated: true, completion: { () -> Void in
                
                })
            break
        case _btn_contact!:
            let _viewC:MessageWindow = MessageWindow()
            _viewC._uid = "bingome"
            self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                _viewC._setPorofileImg("Bingome-logo")
                _viewC._setName("BingoMe")
                _viewC._getDatas()
            })
            
            break
        case _btn_logOut!:
            self._toLogOut()
        default:
            break
            
        }
    }
    func _toLogOut(){
        
        let _alert:UIAlertView = UIAlertView()
        _alert.delegate=self
        //_alert.title=""
        _alert.message = "退出帐号将清空本地聊天列表\n确定要退出吗？"
        _alert.addButtonWithTitle("确定")
        _alert.addButtonWithTitle("取消")
        _alert.show()
    }
    //-----提示按钮代理
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex==0{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                MainAction._logOut()
                ViewController._self?._showLogMain()
            })
        }
    }
    
    
    func _checkIfChanged()->Bool{
        
        
        
        return false
    }
    
    
}
