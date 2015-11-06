//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class MyImageList:UIViewController,UITableViewDataSource,UITableViewDelegate,BingoUserItemAtMyList_delegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _btn_back:UIButton?
    let _cellHeight:CGFloat = 140
    var _selectedIndex:NSIndexPath?
    var _messages:NSMutableArray? = NSMutableArray()
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    
    var _users:NSMutableArray?
    var _datained:Bool = false
    var _topView:UIView?
    weak var _parentView:ViewController?
    
    var _inputer:Inputer?
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 60
    
    
    
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
        _bgImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _bgImg._refreshView()
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        self.view.addSubview(_bgImg)
        
        _tableView = UITableView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH))
        _tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5))
        _tableView?.registerClass(ImageListItem.self, forCellReuseIdentifier: "ImageListItem")
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView!.separatorColor=UIColor.clearColor()
        
        self.view.addSubview(_tableView!)
        
        _topView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
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
        _nameLabel?.text = "图列"
        
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
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:ImageListItem = _tableView?.dequeueReusableCellWithIdentifier("ImageListItem") as! ImageListItem
        
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: _cellHeight))
        _cell._setInfos("3小时前", __clickNum: 3*indexPath.row, __bingoNum: indexPath.row)
        _cell._setText("快来猜的收购额无奈的说过多少个呢但是难过的很@＃％……％¥……¥＃％@＃")
        _cell._parentDelegate = self
        if indexPath .isEqual(_selectedIndex){
            _cell._changeToHeight(self.view.frame.height)
            _cell._open()
        }else{
            _cell._changeToHeight(_cellHeight)
            _cell._close()
        }

        
        _cell._setPic("profile")
        
        return _cell
    }
    
    //---代理
    func _needToTalk(__id: String) {
        let _message:MessageWindow = MessageWindow()
        self.presentViewController(_message, animated: true) { (comp) -> Void in
            _message._getDatas()
        }
    }
    func _showUser(__index: Int) {
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath .isEqual(_selectedIndex){ //---恢复
           _selectedIndex = nil
           // UIApplication.sharedApplication().statusBarHidden = false
            
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
            UIApplication.sharedApplication().statusBarHidden=false
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._tableView?.frame = CGRect(x: 0, y: self._barH, width: self.view.frame.width, height: self.view.frame.height-self._barH)
                self._topView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self._barH)
                }, completion: { (complete) -> Void in
                
            })
            
        }else{
          _selectedIndex = indexPath
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
            UIApplication.sharedApplication().statusBarHidden=true
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self._topView?.frame = CGRect(x: 0, y: -self._barH, width: self.view.frame.width, height: self._barH)
                }, completion: { (complete) -> Void in
                    
            })
           
        }
        
        
        
        _tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        _tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_back!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        default:
            break
            
        }
    }
    
    
    
}
