//
//  MessageWindow.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/28.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class MessageWindow:UIViewController,UITableViewDataSource,UITableViewDelegate,Inputer_delegate{
    var _uid:String = "bingome"
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _messages:NSMutableArray? = NSMutableArray()//---需要展示的最终数据，包括时间段
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    
    
    var _datained:Bool = false
    var _topView:UIView?
    var _btn_back:UIButton?
    weak var _parentView:ViewController?

    var _inputer:Inputer?
    var _profileImg:PicView?
    var _prifileImageUrl:String = ""
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 60
    
    var _needChatsNum:Int = 100 //----需要获取的聊天记录数量
    
    var _messagesArray:NSArray = [] //---获取的聊天记录原始数据
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
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
        
        _bgImg = PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        _bgImg._setPic(NSDictionary(objects: ["bg.jpg","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        self.view.addSubview(_bgImg)
        
        
        _inputer = Inputer(frame: self.view.frame)
        _inputer?._delegate=self
        _inputer!._placeHold = "输入你想说的话"
        _inputer?.setup()
        
        
        
        _tableView = UITableView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH-_inputer!._heightOfClosed))
        _tableView?.clipsToBounds = false
        _tableView?.registerClass(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        _tableView?.dataSource = self
        _tableView?.delegate = self
        _tableView?.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5))
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
//        _tableView?.separatorColor = UIColor.whiteColor()
//        _tableView?.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 50)
        _tableView?.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(_tableView!)
         self.view.addSubview(_inputer!)
        
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
        
        _profileImg = PicView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _profileImg?.layer.cornerRadius = 15
        _profileImg?.clipsToBounds = true
        _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
        _profileImg?.layer.borderWidth = 1
        _profileImg?.center = CGPoint(x: self.view.frame.width/2, y: _barH/2+6)
        
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        _nameLabel?.textColor = UIColor.whiteColor()
        
        _topView?.addSubview(_nameLabel!)
        
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        //_setPorofileImg("profile")
        //_setName("")
        
        _setuped = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_receivedNotification:", name: MainAction._Notification_new_chat, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_receivedNotification:", name: MainAction._Notification_new_bingo, object: nil)
    }
    //--------接受到消息
    func _receivedNotification(notification: NSNotification){
        
        let __dict:NSDictionary = notification.userInfo! as NSDictionary
        
        if let __uid:String = __dict.objectForKey("uid") as? String{
            if __uid == _uid{
                _addMessage(__dict.objectForKey("type") as! String, __content: __dict.objectForKey("content") as! String)
                _tableView?.reloadData()
                _refreshView()
                let _cell:MessageCell = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0)) as! MessageCell
                //_cell._type = __dict.objectForKey("type") as? String
                _cell._justSent()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func _getDatas(){
        _messages = NSMutableArray()
        if let __array:NSArray = MainAction._getChatHistory(_uid, __num:_needChatsNum){
            _messagesArray = NSMutableArray(array: __array)
        }
        for _dict in _messagesArray{
            if let __time:String = _dict.objectForKey("time") as? String{
                _addMessage(MessageCell._Type_Time, __content:__time)//----添加时间
            }
            
            let _type:String = _dict.objectForKey("type") as! String
            switch _type{
            case MessageCell._Type_Bingo:
                break
            case MessageCell._Type_Message:
                break
            case MessageCell._Type_Message_By_Me:
                break
            default:
                break
            }
            _addMessage(_type, __content: _dict.objectForKey("content") as! String)
        }
        _tableView?.reloadData()
        _refreshView()
    }
    
    func _addMessage(__type:String,__content:String){
        var _h:CGFloat = 100
        switch __type{
        case MessageCell._Type_Time:
            _h = 30
        case MessageCell._Type_Bingo:
            _h = 200
        case MessageCell._Type_Message:
            _h = max(80,MessageCell._getHighByStr(__content))
        case MessageCell._Type_Message_By_Me:
            _h = MessageCell._getHighByStr(__content)
        default:
            break
        }
        _messages?.addObject(NSDictionary(objects: [__type,__content,_h], forKeys: ["type","content","height"]))
    }
    func _refreshView(){
        if let _h:CGFloat = _inputer!._getHeightOfBar() {
            UIView.animateWithDuration(0.35) { () -> Void in
                self._tableView!.frame = CGRect(x: 0, y: self._barH, width: self.view.frame.width, height: self.view.frame.height-self._barH-_h)
            }
        }
        //_tableView?.reloadData()
        if _messages?.count > 0 {
            _tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let _dict:NSDictionary = _messages?.objectAtIndex(indexPath.row) as! NSDictionary
        return _dict.objectForKey("height") as! CGFloat
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _cell:MessageCell = _tableView?.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let _dict:NSDictionary = _messages?.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        let _type:String = _dict.objectForKey("type") as! String
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60),__type:_type)
        switch _type{
        case MessageCell._Type_Time:
            break
        case MessageCell._Type_Bingo:
            _cell._setPic(_prifileImageUrl)
            break
        case MessageCell._Type_Bingo_By_Me:
            _cell._setPic(_prifileImageUrl)
            break
        case MessageCell._Type_Message:
            //print(_prifileImageUrl)
            _cell._setPic(_prifileImageUrl)
        case MessageCell._Type_Message_By_Me:
            break
        default:
            break
        }
        
        
        
        _cell._setContent(_dict.objectForKey("content") as! String)
        
        return _cell
    }
    func _setPorofileImg(__str:String){
        _prifileImageUrl = __str
        _profileImg?._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
          self._topView?.addSubview(self._profileImg!)
        })
    }
    func _setName(__str:String){
        _nameLabel?.text = __str
        _nameLabel?.sizeToFit()
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2+10 , y: _barH/2+6)
        _profileImg?.center = CGPoint(x: (self.view.frame.width-_nameLabel!.frame.width)/2-10, y: _barH/2+6)
    }
    
    //----输入框代理
    
    func _inputer_changed(__dict: NSDictionary) {
      _refreshView()
    }
    
    func _inputer_closed() {
        _refreshView()
    }
    func _inputer_opened() {
       _refreshView()
    }
    func _inputer_send(__dict: NSDictionary) {
        _addMessage(MessageCell._Type_Message_By_Me, __content: __dict.objectForKey("text") as! String)
        
        MainAction._sentOneChat(NSDictionary(objects: [_uid,MessageCell._Type_Message_By_Me,__dict.objectForKey("text") as! String], forKeys: ["uid","type","content"]))
        
        MainAction._addToBingoList(_uid, __type: MessageCell._Type_Message_By_Me, __content: __dict.objectForKey("text") as! String, __nickname: _nameLabel!.text!, __image:_prifileImageUrl)
        
        _tableView?.reloadData()
        _refreshView()
        let _cell:MessageCell = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0)) as! MessageCell
        _cell._justSent()
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