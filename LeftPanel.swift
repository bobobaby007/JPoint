//
//  LeftPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/23.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class LeftPanel: UIViewController {
    var _setuped:Bool = false
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _profileImg:PicView?
    var _label_edit:UILabel?
    var _label_name:UILabel?
    var _btn_gingoMe:UIButton?
    var _btn_bingoList:UIButton?
    var _btn_imgList:UIButton?
    var _btn_settings:UIButton?
    weak var _parentView:ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor = UIColor.blueColor()
        _bgImg = PicView()
        _bgImg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        _bgImg._setPic(NSDictionary(objects: ["profile.png","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        _bgImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _bgImg._refreshView()
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        self.view.addSubview(_bgImg)
        
        
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        _blurV?.frame = self.view.bounds
        self.view.addSubview(_blurV!)
        
        
        _profileImg = PicView()
        _profileImg!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        _profileImg?.center = CGPoint(x: self.view.frame.width/2, y: 100)
        _profileImg!._setPic(NSDictionary(objects: ["profile.png","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        _profileImg!._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _profileImg!.layer.cornerRadius = 50
        _profileImg?.layer.borderWidth = 2
        _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
        
        _profileImg!.maximumZoomScale = 1
        _profileImg!.minimumZoomScale = 1
        
        
        _profileImg!._refreshView()
        
        
        let _tapG:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapHander:")
        _profileImg?.addGestureRecognizer(_tapG)
        
        
        self.view.addSubview(_profileImg!)
        
        _label_name = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 25))
        _label_name?.textAlignment = NSTextAlignment.Center
        _label_name?.center = CGPoint(x: self.view.frame.width/2, y: 172)
        _label_name?.font = UIFont.systemFontOfSize(22)
        
        _label_name?.textColor = UIColor.whiteColor()
        self.view.addSubview(_label_name!)
        
        _label_edit = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 20))
        _label_edit?.textAlignment = NSTextAlignment.Center
        _label_edit?.center = CGPoint(x: self.view.frame.width/2, y: 200)
        _label_edit?.font = UIFont.systemFontOfSize(16)
        _label_edit?.text = "编辑头像"
        _label_edit?.textColor = UIColor.darkGrayColor()
        
        self.view.addSubview(_label_edit!)
        
        let _gapY = (self.view.frame.height-300)/5
        
        
        _btn_gingoMe = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 0.6*_gapY))
        _btn_gingoMe?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_gingoMe?.setImage(UIImage(named: "icon_GotoBingo"), forState: UIControlState.Normal)
        _btn_gingoMe?.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-5*_gapY)
        _btn_gingoMe?.setTitle("激点", forState: UIControlState.Normal)
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
        _btn_imgList?.setTitle("图列", forState: UIControlState.Normal)
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
    func _setName(__str:String){
        _label_name?.text = __str
    }
    
    func _swapTo(__distance:CGFloat){
        
    }
    
    func tapHander(sender:UITapGestureRecognizer){
        print(sender, terminator: "")
        switch sender.state{
        case UIGestureRecognizerState.Began:
            break
        default:
            break
        }
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_imgList!:
            let _viewC:MyImageList = MyImageList()
            self.presentViewController(_viewC, animated: true, completion: { () -> Void in
                
            })
            break
        case _btn_gingoMe!:
            _parentView?._showMainView()
            break
        case _btn_bingoList!:
            _parentView?._showRight()
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
