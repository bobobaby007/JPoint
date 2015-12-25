//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol EULA_delegate:NSObjectProtocol{
   func _EULA_accepted()
}

class EULA:UIViewController{
    weak var _delegate:EULA_delegate?
    var _setuped:Bool = false
    var _topView:UIView?
    let _barH:CGFloat = 60
    var _btn_back:UIButton?
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _nameLabel:UILabel?
    
    var _btn_cancel:UIButton?
    var _btn_accept:UIButton?
    
    let _central_w:CGFloat = 250
    
    var _contentText:UITextView?
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
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2 , y: _barH/2+6)
        _nameLabel?.font = UIFont.boldSystemFontOfSize(20)
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.text = "用户协议"
        
        
        
        
        _topView?.addSubview(_nameLabel!)
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        _btn_accept = UIButton(frame: CGRect(x: self.view.frame.width-140, y: self.view.frame.height-80, width: 120, height: 40))
        _btn_cancel = UIButton(frame: CGRect(x: 20, y: self.view.frame.height-80, width: 120, height: 40))
        _btn_accept?.setBackgroundImage(UIImage(named: "btn_dark"), forState: UIControlState.Normal)
        _btn_accept?.setTitle("接受", forState: UIControlState.Normal)
        _btn_cancel?.setBackgroundImage(UIImage(named: "btn_circle"), forState: UIControlState.Normal)
        _btn_cancel?.setTitle("不接受", forState: UIControlState.Normal)
        
        
        _btn_accept?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_cancel?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        _contentText = UITextView(frame: CGRect(x: 10, y: _barH + 10, width: self.view.frame.width - 20, height: self.view.frame.height - _barH - 120))
        _contentText?.backgroundColor = UIColor.clearColor() // UIColor(white: 1, alpha: 0.4)
        _contentText?.textColor = UIColor.whiteColor()
        
        
        
        
        
        let fileURL = NSBundle.mainBundle().URLForResource("EULA", withExtension: "rtf")
        
        
        do{
           let attributedText = try NSAttributedString(fileURL: fileURL!, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes:nil)
            _contentText!.attributedText = attributedText
        }catch{
            print(error)
        }
        
        
        self.view.addSubview(_contentText!)
        self.view.addSubview(_btn_cancel!)
        self.view.addSubview(_btn_accept!)
        
        
        _setuped=true
    }
    
    func btnHander(sender:UIButton){
        
        switch sender{
        case _btn_back!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        case _btn_accept!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            _delegate!._EULA_accepted()
            break
        case _btn_cancel!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        default:
            break
            
        }
    }
    
    
}
