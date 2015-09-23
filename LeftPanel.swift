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
        _profileImg?.center = CGPoint(x: self.view.frame.width/2, y: 80)
        _profileImg!._setPic(NSDictionary(objects: ["profile.png","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        _profileImg!._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _profileImg!.layer.cornerRadius = 50
        
        _profileImg!.maximumZoomScale = 1
        _profileImg!.minimumZoomScale = 1
        
        
        _profileImg!._refreshView()
        
        
        let _tapG:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapHander:")
        _profileImg?.addGestureRecognizer(_tapG)
        
        
        self.view.addSubview(_profileImg!)
        
        _label_edit = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        _label_edit?.center = CGPoint(x: self.view.frame.width/2, y: 100)
        _label_edit?.text = "home"
        _label_edit?.textColor = UIColor.darkGrayColor()
        
        self.view.addSubview(_label_edit!)
        
        
        
        
        //self.view.addSubview(_uiV)
        _setuped = true
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
