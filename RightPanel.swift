//
//  RightPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/8.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class RightPanel: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _users:NSMutableArray?
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
        
        _users = NSMutableArray()
        
        _tableView = UITableView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        _tableView?.registerClass(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func _getDatas(){
        _users = NSMutableArray()
        
        for _ in 0...12{
            _users?.addObject(NSDictionary(objects: ["profile",""], forKeys: ["image","type"]))
        }
        
        
        _tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _users!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:ChatCell = _tableView?.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        return _cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let _messageWindow:MessageWindow = MessageWindow()
        self.presentViewController(_messageWindow, animated: true) { () -> Void in
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
