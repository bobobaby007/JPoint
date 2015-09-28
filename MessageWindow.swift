//
//  MessageWindow.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/28.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class MessageWindow:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _messages:NSMutableArray?
    var _btn_back:UIButton?
    var _headerView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.whiteColor()
        //self.view.clipsToBounds = false
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 15
        
        _headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        _btn_back = UIButton(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        
        _btn_back?.setTitle("完成", forState: UIControlState.Normal)
        _btn_back?.titleLabel?.textAlignment = NSTextAlignment.Left
        _btn_back?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _headerView!.addSubview(_btn_back!)
        
        _headerView!.backgroundColor=UIColor.darkGrayColor()
        self.view.addSubview(_headerView!)
        
        
        //_tableView = UITableView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        //_tableView?.registerClass(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func _getDatas(){
        _messages = NSMutableArray()
        
        for _ in 0...13{
            _messages?.addObject(NSDictionary(objects: ["gswoeng"], forKeys: ["content"]))
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:MessageCell = _tableView?.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        return _cell
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