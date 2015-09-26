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
            
            inited = true
        }
    }
    func _changeToHeight(__height:CGFloat){
        _height = __height
        if __height>=_bgImg!.frame.width{
            _bgImg?.frame = CGRect(x: 5, y: 5, width: _rect!.width-10, height: _rect!.width-10)
        }else{
            _bgImg?.frame = CGRect(x: 5, y: 5, width: _rect!.width-10, height: __height-5)
        }
        
        
        _bgImg?._refreshView()
        
    }
    
    //---table delegates
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:UserCell = _usersTable?.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: _rect!.width, height: 50))
        
        return _cell
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
        _tableIn()
        self.addSubview(_usersTable!)
        
    }
    func _close(){
        if _usersTable != nil{
         _usersTable?.removeFromSuperview()
        }
    }
    
    func _setPic(__picUrl:String){
        
        _bgImg?._setImage(__picUrl)
        _bgImg?._refreshView()
    }
    
    
}
