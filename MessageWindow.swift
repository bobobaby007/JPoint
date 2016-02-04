//
//  MessageWindow.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/28.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol MessageWindow_delegate:NSObjectProtocol{
    func _messageWindow_close()
}


class MessageWindow:UIViewController,UITableViewDataSource,UITableViewDelegate,Inputer_delegate{
    var _uid:String = "bingome"//----默认给bingome发送消息
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _messages:NSMutableArray? = NSMutableArray()//---需要展示的最终数据，包括时间段
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    
    
    var _datained:Bool = false
    var _topView:UIView?
    var _btn_back:UIButton?
    weak var _delegate:MessageWindow_delegate?

    var _inputer:Inputer?
    var _profileImg:PicView?
    var _profileImageUrl:String = ""
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 60
    
    var _lastMessageId:String = ""//---获取的最早一条聊天记录的id
    
    var _needChatsNum:Int = 50 //----需要获取的聊天记录数量
    
    var _messagesArray:NSMutableArray = [] //---获取的聊天记录原始数据
    
    var _hasNewMessage:Bool = false
    
    static var _self:MessageWindow?
    
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
        
        MessageWindow._self = self
        
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
    //--------接收到消息
    func _receivedNotification(notification: NSNotification){
       // print("接收到消息")
        _getNewMessageFrom("")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func _getDatas(){
        //---获取在线数据
        
        _getNewMessageFrom(_lastMessageId)
        //_getBingos()
        //----获取本地数据
        /*
        _messages = NSMutableArray()
        if let __array:NSArray = MainAction._getChatHistory(_uid, __num:_needChatsNum){
            _messagesArray = NSMutableArray(array: __array)
        }
        _dealWithDatas()
        */
    }
    //-----获取消息，从某条消息开始
    func _getNewMessageFrom(__messId:String){
        MainAction._getChatHistoryOnline(_uid, __fromChatId: __messId, __num: 20) { (__array) -> Void in
            print("获取到消息:",__array)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._dealWithOnlineData(self._formatArray(__array))
            })
        }
    }
    //-------套入消息样式
    func _formatArray(__array:NSArray)->NSArray{
        let _allMessage:NSMutableArray = []
        for var i:Int = 0; i<__array.count; ++i{
            let _content:NSDictionary = __array.objectAtIndex(__array.count-i-1) as! NSDictionary
            let _from:NSDictionary = _content.objectForKey("author") as! NSDictionary
            var _mssageType:String = MessageCell._Type_Message
            
            
            if let _type = _content.objectForKey("type") as? String{
                _mssageType = _type
            }
            
            if _from.objectForKey("_id") as! String == MainAction._profileDict?.objectForKey("_id") as! String{
                
                if  _mssageType == MessageCell._Type_Message{
                    _mssageType = MessageCell._Type_Message_By_Me
                }
                if  _mssageType == MessageCell._Type_Bingo{
                    _mssageType = MessageCell._Type_Bingo_By_Me
                }
                
            }
            
            
            if let ___dict:NSDictionary = NSDictionary(objects: [_content.objectForKey("_id") as! String,_from.objectForKey("_id")!,_mssageType,_content,_content.objectForKey("create_at")!], forKeys: ["_id","uid","type","content","time"]){
                _allMessage.addObject(___dict)
            }
        }
        return _allMessage
    }
    
    
    //处理在线获取到的数据
    func _dealWithOnlineData(__array:NSArray){
        self._addNewMessages(__array)
        self._tableView?.reloadData()
        self._refreshView()
        
        if _hasNewMessage{
            _refreshBingoList()
            _hasNewMessage = false
        }
    }
    //----更新联系人列表的内容
    func _refreshBingoList(){
        if _messagesArray.count>0{
            if let _mess:NSDictionary = _messagesArray.objectAtIndex(_messagesArray.count-1) as? NSDictionary{
                let _content:NSDictionary = _mess.objectForKey("content") as! NSDictionary
                
                MainAction._addToBingoList(_uid, __type: _mess.objectForKey("type") as! String, __content:_content.objectForKey("message") as! String , __nickname: _nameLabel!.text!, __avatar:_profileImageUrl,__isNew: false)
            }
        }

    }
    //----处理cell数组，添加时间
    func _addNewMessages(__mess:NSArray){
        self._messagesArray.addObjectsFromArray(__mess as [AnyObject])
        for _dict in __mess{
           
            if let __time:String = _dict.objectForKey("time") as? String{
                _addMessage(MessageCell._Type_Time, __content:NSDictionary(objects: [__time], forKeys: ["time"]) )//----添加时间
            }
            
            let _type:String = _dict.objectForKey("type") as! String
            
            _addMessage(_type, __content: _dict.objectForKey("content") as! NSDictionary )
        }
        

    }
    
    func _addMessage(__type:String,__content:NSDictionary){
        var _h:CGFloat = 100
        switch __type{
        case MessageCell._Type_Time:
            _h = 30
        case MessageCell._Type_Bingo:
            _h = 200
        case MessageCell._Type_Welfare:
            _h = 200
        case MessageCell._Type_Bingo_By_Me:
            _h = 200
        case MessageCell._Type_Message:
            _h = max(80,MessageCell._getHighByStr(__content.objectForKey("message") as! String))
        case MessageCell._Type_Message_By_Me:
            _h = MessageCell._getHighByStr(__content.objectForKey("message") as! String)
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
        
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60),__type: _type)
        _cell._setDict(_dict)
        
        switch _type{
        case MessageCell._Type_Time:
            break
        case MessageCell._Type_Bingo:
            _cell._setPic(_profileImageUrl)
            break
        case MessageCell._Type_Welfare:
            _cell._setPic(_profileImageUrl)
            break
        case MessageCell._Type_Bingo_By_Me:
            _cell._setPic(_profileImageUrl)
            break
        case MessageCell._Type_Message:
            //print(_profileImageUrl)
            _cell._setPic(_profileImageUrl)
        case MessageCell._Type_Message_By_Me:
            break
        default:
            
            break
        }
        
        
        return _cell
    }
    func _setPorofileImg(__str:String){
        _profileImageUrl = __str
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
        print("_inputer_closed")
        _refreshView()
    }
    func _inputer_opened() {
       _refreshView()
    }
    
    func _inputer_send(__dict: NSDictionary) {
        if __dict.objectForKey("text") as! String == ""{
            return
        }
        _sentMessage(__dict.objectForKey("text") as! String)
    }
    
    
    //发送信息
    func _sentMessage(__str:String){
        
        let _content:NSDictionary = NSDictionary(objects: [__str], forKeys: ["message"])
        _addMessage(MessageCell._Type_Message_By_Me, __content: _content)
        let _mess:NSDictionary = NSDictionary(objects: [_uid,MessageCell._Type_Message_By_Me,_content, CoreAction._timeStrOfCurrent()], forKeys: ["uid","type","content","time"])
        
        self._messagesArray.addObjectsFromArray([_mess])
        
        MainAction._sentOneChat(_mess)
        _tableView!.reloadData()
        _refreshView()
        _refreshBingoList()
        
        
        
        let _cell:MessageCell = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0)) as! MessageCell
        _cell._justSent()
        
        
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_back!:
            
            if _delegate != nil{
                _delegate?._messageWindow_close()
            }
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        default:
            break
            
        }
    }
}