//
//  Log_home.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit
class Log_home: UIViewController {
    var _inited:Bool = false
    
    var _btn_signin:UIButton?
    var _btn_login:UIButton?
    
    let _btnH:CGFloat = 60
    let _btnGap:CGFloat = 2
    override func viewDidLoad() {
        _init()
    }
    
    func _init(){
        if _inited{
            return
        }
        
        let _bgView = UIImageView(image: UIImage(named: "bg.jpg"))
        _bgView.contentMode = UIViewContentMode.ScaleToFill
        _bgView.frame = self.view.bounds
        self.view.addSubview(_bgView)
        
        let _logo:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        _logo.contentMode = UIViewContentMode.ScaleAspectFit
        _logo.image = UIImage(named: "logo_white")
        _logo.center = CGPoint(x: self.view.frame.width/2-43, y: self.view.frame.height/2 - 90)
        
        let _label_appName:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        _label_appName.textColor = UIColor.whiteColor()
        _label_appName.center = CGPoint(x: self.view.frame.width/2+30, y: self.view.frame.height/2 - 90)
        _label_appName.font = UIFont.boldSystemFontOfSize(20)
        _label_appName.text = "BingoMe"
        
        
        
        let _label_slogan:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 125, height: 30))
        _label_slogan.center = CGPoint(x: self.view.frame.width/2+5, y: self.view.frame.height/2 - 50)
        _label_slogan.font = UIFont.systemFontOfSize(12)
        _label_slogan.textColor = UIColor.whiteColor()
        _label_slogan.textAlignment = NSTextAlignment.Center
        
        _label_slogan.layer.borderColor = UIColor.whiteColor().CGColor
        _label_slogan.layer.borderWidth = 1
        _label_slogan.layer.cornerRadius = 15
        _label_slogan.text = "点出默契，点出惊喜"
        
       
        
        
        self.view.addSubview(_logo)
        self.view.addSubview(_label_appName)
        self.view.addSubview(_label_slogan)
        
        
        _btn_signin = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 2*_btnH - _btnGap, width: self.view.frame.width, height: _btnH))
        _btn_signin?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        //_btn_signin?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        //_btn_signin?.titleLabel?.font = Config._font_loginButton
        _btn_signin?.setTitle("注册", forState: UIControlState.Normal)
        _btn_signin?.addTarget(self, action: "_buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_login = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - _btnH, width: self.view.frame.width, height: _btnH))
        _btn_login?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        //_btn_login?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        //_btn_login?.titleLabel?.font = Config._font_loginButton
        _btn_login?.setTitle("登录", forState: UIControlState.Normal)
        _btn_login?.addTarget(self, action: "_buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_btn_signin!)
        self.view.addSubview(_btn_login!)
        
        
        _inited = true
    }
    func _buttonHander(__sender:UIButton){
        switch __sender{
        case _btn_signin!:
            let _v:Log_signin = Log_signin()
            self.navigationController?.pushViewController(_v, animated: true)
            break
        case _btn_login!:
            let _v:Log_login = Log_login()
            self.navigationController?.pushViewController(_v, animated: true)
            break
            
        default :
            break
        }
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIApplication.sharedApplication().statusBarHidden=true
        
    }
}
