//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class MyImageList:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _btn_back:UIButton?
    let _cellHeight:CGFloat = 140
    var _selectedIndex:NSIndexPath?
    var _headerView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.automaticallyAdjustsScrollViewInsets = false

        _tableView = UITableView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50))
        _tableView?.tableFooterView = UIView()
        _tableView?.registerClass(ImageListItem.self, forCellReuseIdentifier: "ImageListItem")
        _tableView?.delegate = self
        _tableView?.dataSource = self
        
        self.view.addSubview(_tableView!)
        
        _headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        _btn_back = UIButton(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        
        _btn_back?.setTitle("完成", forState: UIControlState.Normal)
        _btn_back?.titleLabel?.textAlignment = NSTextAlignment.Left
        _btn_back?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _headerView!.addSubview(_btn_back!)
        
       _headerView!.backgroundColor=UIColor.darkGrayColor()
        self.view.addSubview(_headerView!)
        
        //self.tableView.tableHeaderView = _headerView
        //self.view.backgroundColor = UIColor.redColor()
        
        _tableView!.separatorColor=UIColor.clearColor()
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath .isEqual(_selectedIndex){ //---恢复
           _selectedIndex = nil
           // UIApplication.sharedApplication().statusBarHidden = false
            
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
            UIApplication.sharedApplication().statusBarHidden=false
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._tableView?.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50)
                self._headerView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
                }, completion: { (complete) -> Void in
                
            })
            
        }else{
          _selectedIndex = indexPath
            UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
            UIApplication.sharedApplication().statusBarHidden=true
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self._tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self._headerView?.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: 50)
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
