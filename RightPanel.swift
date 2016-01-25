//
//  RightPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/8.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class RightPanel: UIViewController,UITableViewDelegate,UITableViewDataSource,MessageWindow_delegate{
    var _setuped:Bool = false
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _tableView:UITableView?
    var _datained:Bool = false
    var _tableIned:Bool = false
    var _topView:UIView?
    var _btn_back:UIButton?
    weak var _parentView:ViewController?
    let _barH:CGFloat = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.blackColor()
        //self.view.clipsToBounds = false
        
        
        _bgImg = PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        _bgImg._setPic(NSDictionary(objects: ["bg.jpg","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        self.view.addSubview(_bgImg)
        
        
        
        _topView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topView?.backgroundColor = UIColor.clearColor()
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        //_blurV?.alpha = 0.5
        _blurV?.frame = _topView!.bounds
        _topView?.addSubview(_blurV!)
        
        
        _btn_back = UIButton(frame: CGRect(x: 10, y: 20, width: 30, height: 30))
        _btn_back?.center = CGPoint(x: 30, y: _barH/2+6)
        _btn_back?.setImage(UIImage(named: "icon_backToBingo"), forState: UIControlState.Normal)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _topView?.addSubview(_btn_back!)
        
        
        
        
        let _titleButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width-90)/2, height: 30))
        _titleButton.center = CGPoint(x: self.view.frame.width/2, y: _barH/2+6)
        _titleButton.setImage(UIImage(named: "icon_bingoList"), forState: UIControlState.Normal)
    
        _titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        _titleButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _titleButton.setTitle("Bingos", forState: UIControlState.Normal)
        
        //_titleButton.enabled = false
        _topView?.addSubview(_titleButton)
        
        
       // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        
        
        _setuped=true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_receivedNotification:", name: MainAction._Notification_new_chat, object: nil)
    }
    //--------接受到消息
    func _receivedNotification(notification: NSNotification){
        _datained=false
        _getDatas()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    //---刷新
    func _refresh(){
        _datained=false
        _getDatas()
    }
    func _getDatas(){
        if _datained{
            return
        }
        MainAction._getBingoChats { (array) -> Void in
            self._tabelsIn()
            self._tableView?.reloadData()
            self._datained = true
        }
        
    }
    func _tabelsIn(){
        if _tableIned{
            return
        }else{
            _tableView = UITableView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH))
            _tableView?.clipsToBounds = false
            _tableView?.registerClass(ChatCell.self, forCellReuseIdentifier: "ChatCell")
            _tableView?.dataSource = self
            _tableView?.delegate = self
            let _footV:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            _tableView?.tableFooterView = _footV
            //_tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
            _tableView?.separatorColor = UIColor.whiteColor()
            
            _tableView?.backgroundColor = UIColor.clearColor()
            self.view.insertSubview(_tableView!, belowSubview: _topView!)
            _tableIned = true
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainAction._ChatsList!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:ChatCell = _tableView?.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        
        let _dict:NSDictionary = MainAction._ChatsList!.objectAtIndex(indexPath.row) as! NSDictionary
        
        _cell._setId(_dict.objectForKey("uid") as! String)
        _cell._setPic(_dict.objectForKey("image") as! String)
        _cell._setName(_dict.objectForKey("nickname") as! String)
        _cell._setContent(_dict.objectForKey("content") as! String)
        
        if let _isNew:Bool = _dict.objectForKey("isnew") as? Bool{
            _cell._setAlert(_isNew)
        }else{
            _cell._setAlert(false)
        }
        
        
        if (indexPath.row == MainAction._ChatsList!.count-1) {
            _cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }else{
            _cell.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 50)
        }
        
        return _cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //_tableView?.cellForRowAtIndexPath(indexPath)?.didMoveToSuperview()
        _tableView?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let _dict:NSDictionary = MainAction._ChatsList!.objectAtIndex(indexPath.row) as! NSDictionary
        
        MainAction._readedAtFriend(_dict.objectForKey("uid") as! String)
        
        
        let _messageWindow:MessageWindow = MessageWindow()
        _messageWindow._uid = _dict.objectForKey("uid") as! String
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(_messageWindow, animated: true) { (complete) -> Void in
            _messageWindow._delegate = self
            _messageWindow._setPorofileImg(_dict.objectForKey("image") as! String)
            _messageWindow._setName(MainAction._nickName(_dict))
            _messageWindow._getDatas()
        }
//        let _viewC:MyImageList = MyImageList()
//        self.presentViewController(_viewC, animated: true, completion: { () -> Void in
//            
//        })
    }
    //-----聊天窗口代理
    func _messageWindow_close() {
        _refresh()
    }
    
    
    func btnHander(__sender:UIButton){
        switch __sender{
        case _btn_back!:
            _parentView?._showMainView()
            break
        default:
            break
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
