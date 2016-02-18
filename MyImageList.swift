//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol MyImageList_delegate: NSObjectProtocol{
    func _gotoPostOnePic()
}

class MyImageList:UIViewController,UITableViewDataSource,UITableViewDelegate,BingoUserItemAtMyList_delegate,UIAlertViewDelegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _btn_back:UIButton?
    let _cellHeight:CGFloat = 140
    var _selectedIndex:NSIndexPath?
    var _imagesArray:NSArray = []
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
    
    var _btn_noImage:UIButton?
    
    var _currentIndex:NSIndexPath?
    
    weak var _delegate:MyImageList_delegate?
    
    static weak var _self:MyImageList?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
        
    }
    func setup(){
        if _setuped{
            return
        }
        
        MyImageList._self = self
        
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
        _nameLabel?.text = "我的发布"
        
        _topView?.addSubview(_nameLabel!)
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        
        _setuped=true
        
        //_getData()
        
        
    }
    
    func _getData(){
        MainAction._getMyImageList { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._imagesArray = __dict.objectForKey("info")  as! NSArray//MainAction._MyImageList
                    //self._imagesArray = []
                    self._tableView!.reloadData()
                    self._ifHasImages()
                })
            }else{
                
            }
        }
    }
    func _ifHasImages(){//--------没发布过图片
        if self._imagesArray.count == 0{
            if _btn_noImage == nil{
                _btn_noImage = UIButton(frame: CGRect(x: 0, y: 0, width: 205, height: 49))
                _btn_noImage?.center = CGPoint(x: self.view.frame.width/2, y: _barH + 70)
                _btn_noImage?.clipsToBounds = true
                _btn_noImage?.layer.cornerRadius = 5
                _btn_noImage?.titleLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
                _btn_noImage?.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_noImage?.titleLabel?.font = UIFont.systemFontOfSize(13)
                _btn_noImage?.setBackgroundImage(UIImage(named: "btn_circle.png"), forState: UIControlState.Normal)
                _btn_noImage?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
                _btn_noImage?.setTitleColor(UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5), forState: UIControlState.Normal)
                _btn_noImage?.setTitle("现在发布图片,\n看谁能猜中你的心思", forState: UIControlState.Normal)
                _btn_noImage?.backgroundColor = UIColor(white: 1, alpha: 0.5)
                self.view.addSubview(_btn_noImage!)
            }
        }else{
            if _btn_noImage != nil{
                _btn_noImage?.removeFromSuperview()
                _btn_noImage = nil
            }
        }
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
        return _imagesArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let __dict:NSDictionary = _imagesArray.objectAtIndex(indexPath.row) as! NSDictionary
        //print(__dict)
        let _cell:ImageListItem = _tableView?.dequeueReusableCellWithIdentifier("ImageListItem") as! ImageListItem
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: _cellHeight))
        _cell._indexPath = indexPath
        _cell._setDict(__dict)
        
        
        
        
        _cell._parentDelegate = self
        if indexPath .isEqual(_selectedIndex){
            _cell._changeToHeight(self.view.frame.height)
            _cell._open()
        }else{
            _cell._changeToHeight(_cellHeight)
            _cell._close()
        }
        
        
        return _cell
    }
    
    //---代理
    func _needToTalk(_dict:NSDictionary) {
        let _messageWindow:MessageWindow = MessageWindow()
        _messageWindow._uid = _dict.objectForKey("_id") as! String
        
        self.presentViewController(_messageWindow, animated: true) { (comp) -> Void in
        _messageWindow._setPorofileImg(MainAction._avatar(_dict))
        _messageWindow._setName(MainAction._nickName(_dict))
        _messageWindow._getDatas()
        }
    }
    func _showUser(__index: Int) {
        
    }
    //---左滑动作
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let _deleteAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除") { (__action, __index) -> Void in
            self._toDelete(__index)
        }
        
        _deleteAction.backgroundColor = UIColor.clearColor()
        
        return [_deleteAction]
    }
    
    
    //----删除
    
    func _toDelete(__index:NSIndexPath){
        _currentIndex = __index
        let _alert:UIAlertView = UIAlertView()
        _alert.delegate=self
        _alert.title="确定删除该图片？"
        _alert.addButtonWithTitle("确定")
        _alert.addButtonWithTitle("取消")
        _alert.show()
    }
    
    
    //-----提示按钮代理
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex==0{
            deleteCell(_currentIndex!)
        }
    }
    //----删除相册
    func deleteCell(index:NSIndexPath)->Void{
        let __dict:NSDictionary = _imagesArray.objectAtIndex(index.row) as! NSDictionary
        let _newArray:NSMutableArray = NSMutableArray(array: _imagesArray)
        _newArray.removeObjectAtIndex(index.row)
        _imagesArray = _newArray
        
        
        MainAction._removeImage(__dict.objectForKey("_id") as! String) { (__dict) -> Void in
            
        }
        
        
        _selectedIndex = NSIndexPath(forItem: -1, inSection: 0)
        
        _tableView?.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
        
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._tableView?.frame = CGRect(x: 0, y: self._barH, width: self.view.frame.width, height: self.view.frame.height-self._barH)
            self._topView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self._barH)
            }, completion: { (complete) -> Void in
                
        })
        
        
        _ifHasImages()
        if _imagesArray.count <= 0{
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
            UIApplication.sharedApplication().statusBarHidden=false
            self._tableView?.frame = CGRect(x: 0, y: self._barH, width: self.view.frame.width, height: self.view.frame.height-self._barH)
            self._topView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self._barH)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath .isEqual(_selectedIndex){ //---恢复
           _selectedIndex = nil
            //UIApplication.sharedApplication().statusBarHidden = false
            
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
            UIApplication.sharedApplication().statusBarHidden=false
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._tableView?.frame = CGRect(x: 0, y: self._barH, width: self.view.frame.width, height: self.view.frame.height-self._barH)
                self._topView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self._barH)
                }, completion: { (complete) -> Void in
                
            })
            
        }else{
          _selectedIndex = indexPath
            //UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
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
        case _btn_noImage!:
            if _delegate != nil{
                _delegate?._gotoPostOnePic()
            }
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        default:
            break
            
        }
    }
    
    
    
}
