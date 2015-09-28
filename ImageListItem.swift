//
//  ImageListItem.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class ImageListItem: UITableViewCell, UITableViewDataSource, UITableViewDelegate{
    var inited:Bool = false
    var _bgImg:PicView?
    var _tableIned:Bool = false
    var _usersTable:UITableView?
    var _rect:CGRect?
    var _height:CGFloat = 10
    var _points:NSMutableArray?
    var _pointsView:UIView?
    var _signer:UserSign?
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            _rect = __frame
            self.clipsToBounds = true
           _bgImg = PicView(frame:CGRect(x: 5, y: 5, width: __frame.width-10, height: __frame.height-5))
            _bgImg?.layer.cornerRadius = 5
            _bgImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            addSubview(_bgImg!)
            _bgImg?.userInteractionEnabled = false
            
            
            _pointsView = UIView(frame: CGRect(x: 5, y: 5, width: __frame.width-10, height: __frame.height-5))
            _pointsView?.layer.cornerRadius = 5
            _pointsView?.clipsToBounds = true
            addSubview(_pointsView!)
            _pointsView?.userInteractionEnabled = false
            
            
            
            
            
            
            inited = true
        }
    }
    
    
    
    func _changeToHeight(__height:CGFloat){
        _height = __height
        if __height>=_bgImg!.frame.width{
            _bgImg?.frame = CGRect(x: 5, y: 5, width: _rect!.width-10, height: _rect!.width-10)
            _pointsView?.frame = CGRect(x: 5, y: 5, width: _rect!.width-10, height: _rect!.width-10)
        }else{
            _bgImg?.frame = CGRect(x: 5, y: 5, width: _rect!.width-10, height: __height-5)
        }
        
        
        _bgImg?._refreshView()
        
    }
    func _getPoints(){
        
        for subview in _pointsView!.subviews{
            subview.removeFromSuperview()
        }
        
        _points = NSMutableArray()
        for _:Int in 0...12{
            
            let __p:NSDictionary = NSDictionary(objects: [CGFloat(random()%100),CGFloat(random()%100)], forKeys: ["x","y"])
            _points?.addObject(__p)
            
            
        }
        
        
        for _index:Int in 0...3{
            _addPointAt(CGFloat(random()%100),__y: CGFloat(random()%100),__tag:_index)
            
        }
        
        
        
        addSubview(_pointsView!)
        
        _usersTable?.reloadData()
    }
    func _addPointAt(__x:CGFloat,__y:CGFloat,__tag:Int){
        let __p:CGPoint = CGPoint(x: 5+__x*(_rect!.width-10)/100, y: 5+__y*(_rect!.width-10)/100)
        let _r:CGFloat = 5 + CGFloat(random()%50)
        let _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2*_r, height: 2*_r))
        _v.tag = __tag
        
        if _r > 30{
            
            let _lable:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
            _lable.textAlignment = NSTextAlignment.Center
            _lable.center = CGPoint(x: 25, y: 15)
            _lable.textColor = UIColor.orangeColor()
            //_lable.alpha = 0.5
            _lable.text = "♡1.3万"
            _lable.font = UIFont.boldSystemFontOfSize(13)
            
            
            let _rectView:UIView = UIView(frame: CGRect(x:0, y: 0, width: 50, height: 30))
            _rectView.layer.cornerRadius = 2
            _rectView.backgroundColor = UIColor.yellowColor()
            //_rectView.alpha = 0.7
            //let _rectPoint:CGPoint = CGPoint(x: __p.x - _r - 40 - 5, y: __p.y - 15)
            let _rectPoint:CGPoint = CGPoint(x:  -50 - 0.5, y:  _r-15)
            _rectView.frame.origin = _rectPoint
            _rectView.addSubview(_lable)
            
            let _circleV:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            _circleV.center = CGPoint(x:0.5, y: _r)
            _circleV.layer.cornerRadius = 2.5
            _circleV.backgroundColor = UIColor.yellowColor()
            //_circleV.alpha = 0.7
            
            _v.addSubview(_rectView)
            _v.addSubview(_circleV)
            
        }
        
        
        
        
        _v.layer.cornerRadius = _r
        _v.backgroundColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0)
        _v.center = __p
        _v.layer.borderColor = UIColor.whiteColor().CGColor
        _v.layer.borderWidth = 1
        _v.transform = CGAffineTransformMakeScale(2, 2)
        _v.alpha = 0
        //            _v.layer.shadowColor = UIColor.blackColor().CGColor
        //            _v.layer.shadowOffset = CGSizeMake(20, 20)
        //            _v.layer.shadowRadius = 20
        //            _v.layer.shadowOpacity = 0.4
        
        
        
        UIView.animateWithDuration(0.4, delay:Double(0.01*CGFloat(random()%100)), options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            _v.transform = CGAffineTransformMakeScale(1, 1)
            _v.alpha = 0.6
            }, completion: { (stop) -> Void in
                
        })
        _pointsView!.addSubview(_v)
    }
    func _showPoint(__dict:NSDictionary){
        
        
        let __p:CGPoint = CGPoint(x: 5 + (__dict.objectForKey("x") as! CGFloat)*(_rect!.width-10)/100, y: 5+(__dict.objectForKey("y") as! CGFloat)*(_rect!.width-10)/100)
        
        if _signer != nil{
            
        }else{
            _signer = UserSign()
        }
        _signer!.center = __p
        
        self.addSubview(_signer!)
        _signer!._show()
        
        
    }
    
    
    //---table delegates
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _points!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:UserCell = _usersTable?.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: _rect!.width, height: 50))
        
        return _cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let __dict:NSDictionary = _points!.objectAtIndex(indexPath.row) as! NSDictionary
        //print(__dict)
        _showPoint(__dict)
        
    }
    
    
    
    func _tableIn(){
        if _tableIned{
            return
        }
        _usersTable = UITableView(frame: CGRect(x: 0, y: _rect!.width-5, width: _rect!.width, height: _height - _rect!.width))
        _usersTable?.delegate = self
        _usersTable?.dataSource = self
        _usersTable?.registerClass(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        _tableIned = true
    }
    
    func _open(){
        _getPoints()
        _tableIn()
        self.addSubview(_usersTable!)
        
        
       //
        
    }
    func _close(){
        if _usersTable != nil{
         _usersTable?.removeFromSuperview()
        }
        if _pointsView != nil{
            _pointsView?.removeFromSuperview()
        }
        if _signer != nil{
            _signer?.removeFromSuperview()
        }
    }
    
    func _setPic(__picUrl:String){
        
        _bgImg?._setImage(__picUrl)
        _bgImg?._refreshView()
    }
    
    
}
