//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class ProfilePage:UIViewController,UITableViewDataSource,UITableViewDelegate,ImageInputerDelegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _btn_back:UIButton?
    let _cellHeight:CGFloat = 140
    var _selectedIndex:NSIndexPath?
    var _messages:NSMutableArray? = NSMutableArray()
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _btn_profile:UIButton?
    var _btn_uploadProfile:UIButton?
    var _profileImg:PicView?
    
    
    var _users:NSMutableArray?
    var _datained:Bool = false
    var _topView:UIView?
    weak var _parentView:ViewController?
    
    var _inputer:Inputer?
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 80
    
    var _seg_sex:UISegmentedControl?
    
    var _imageInputer:ImageInputer?
    
    
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
        
        
        
        _btn_profile = UIButton(type: UIButtonType.Custom)
        
        _btn_profile!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        _btn_profile?.center = CGPoint(x: self.view.frame.width/2, y: 180)
        
        _btn_profile?.clipsToBounds = true
        _btn_profile!.layer.cornerRadius = 50
        _btn_profile?.layer.borderWidth = 2
        _btn_profile?.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_profile!.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        //_btn_profile?.backgroundColor = UIColor.clearColor()
        _btn_profile?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_uploadProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _btn_uploadProfile?.center = CGPoint(x: self.view.frame.width/2+30, y: 180+30)
        _btn_uploadProfile?.setImage(UIImage(named: "uploadProfileIcon"), forState: UIControlState.Normal)
        _btn_uploadProfile?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _seg_sex = UISegmentedControl(items: ["男","女"])
        
        _seg_sex?.tintColor = UIColor.whiteColor()
        _seg_sex?.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
        _seg_sex?.center = CGPoint(x: self.view.frame.width/2, y: 300)
        //_seg_sex?.selectedSegmentIndex = 0
        _seg_sex?.enabled = true
        //_seg_sex?.momentary = true
        _seg_sex?.setEnabled(true, forSegmentAtIndex: 0)
        _seg_sex?.addTarget(self, action: "segHander:", forControlEvents: UIControlEvents.TouchUpInside)
        //_seg_sex?.addTarget(self, action: "segHander:", forControlEvents: UIControlEvents.ValueChanged)
        //_seg_sex?.userInteractionEnabled = true
        
        //_seg_sex?.setEnabled(true, forSegmentAtIndex: 0)
        _seg_sex?.setEnabled(true, forSegmentAtIndex: 1)
        
        _profileImg = PicView()
        
        
        
        
        
       
        
        
        
        self.view.addSubview(_bgImg)
        self.view.addSubview(_btn_profile!)
        self.view.addSubview(_btn_uploadProfile!)
        self.view.addSubview(_seg_sex!)
        
        
        
        _topView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topView?.clipsToBounds = true
        _topView?.backgroundColor = UIColor.clearColor()
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        //_blurV?.alpha = 0.5
        _blurV?.frame = _topView!.bounds
        _topView?.addSubview(_blurV!)
        
        _btn_back = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40))
        _btn_back?.center = CGPoint(x: 30, y: 50)
        _btn_back?.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        _btn_back?.transform = CGAffineTransformRotate((_btn_back?.transform)!, -3.14*0.5)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _topView?.addSubview(_btn_back!)
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        _nameLabel?.textAlignment = NSTextAlignment.Center
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2 , y: 55)
        _nameLabel?.font = UIFont.boldSystemFontOfSize(20)
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.text = "编辑资料"
        
        _topView?.addSubview(_nameLabel!)
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        
        _setuped=true
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath .isEqual(_selectedIndex){
            return self.view.frame.height
        }
        
        return _cellHeight
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "settingsCell")
        
        return _cell
    }
    func _setProfileImg(__str:String){
        _profileImg!._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
            self._btn_profile!.setImage(self._profileImg!._imgView!.image, forState: UIControlState.Normal)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func segHander(sender:UISegmentedControl){
        
        print(sender.selectedSegmentIndex)
    }
    
    func _showInputer(){
        if _imageInputer == nil{
            _imageInputer = ImageInputer()
            _imageInputer?._parentViewController = self
            _imageInputer?._delegate = self
            self.addChildViewController(_imageInputer!)
            self.view.addSubview(_imageInputer!.view)
        }
        
    }
    
    
    //---imageInputerDelegate
    func _imageInputer_canceled() {
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
        
    }
    func _imageInputer_saved() {
        

        
        self._btn_profile!.setImage(_imageInputer?._captureBgImage(), forState: UIControlState.Normal)
        
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
    }
    
    func btnHander(sender:UIButton){
       
        switch sender{
        case _btn_back!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        case _btn_uploadProfile!:
            
            _showInputer()
            break
        case _btn_profile!:
            _showInputer()
            break
            
        default:
            break
            
        }
    }
    
    
    
}
