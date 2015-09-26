//
//  MyImageShower.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/26.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class MyImageShower:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    
    func setup(){
        if _setuped{
            return
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        _tableView = UITableView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: self.view.frame.height-150))
        _tableView?.registerClass(UserCell.self, forHeaderFooterViewReuseIdentifier: "UserCell")
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    
    //---table delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:UserCell = _tableView!.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))
        
        return _cell
    }
    
    
    func _setPic(){
        
    }
    func _pointsIn(){
        
    }
    func _usersIn(){
        
    }
    func _showPoint(__x:CGFloat,__y:CGFloat){
        
    }
    
}
