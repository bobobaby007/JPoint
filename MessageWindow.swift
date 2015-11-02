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
    var _setuped:Bool = false
    var _tableView:UITableView?
    var _messages:NSMutableArray? = NSMutableArray()
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    
    var _users:NSMutableArray?
    var _datained:Bool = false
    var _topView:UIView?
    var _btn_back:UIButton?
    weak var _parentView:ViewController?

    var _inputer:Inputer?
    var _profileImg:PicView?
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 80
    
    
    let _messagesArray:NSArray = [["type":"match","content":"image_1.jpg||快来踩一踩，猜一猜，才车使馆时代","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"],["type":"message","content":"你好！sdg的闪光点是广东省各地时光俄根深蒂固树大根深到噶是个少女风格树大根深树大根深到噶上","time":"2222"],["type":"messageByMe","content":"hi，","time":"2222"]]
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
        
        _users = NSMutableArray()
        
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
        
        
        _btn_back = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40))
        _btn_back?.center = CGPoint(x: 30, y: 50)
        _btn_back?.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        _btn_back?.transform = CGAffineTransformRotate((_btn_back?.transform)!, -3.14*0.5)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _topView?.addSubview(_btn_back!)
        
        _profileImg = PicView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _profileImg?.layer.cornerRadius = 15
        _profileImg?.clipsToBounds = true
        _profileImg?.layer.borderColor = UIColor.whiteColor().CGColor
        _profileImg?.layer.borderWidth = 1
        _profileImg?.center = CGPoint(x: self.view.frame.width/2, y: 25)
        _topView?.addSubview(_profileImg!)
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        _nameLabel?.textColor = UIColor.whiteColor()
        
        _topView?.addSubview(_nameLabel!)
        
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        
        
        
        
        _setPorofileImg("profile")
        _setName("小kity")
        
        _setuped = true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func _getDatas(){
        _messages = NSMutableArray()
        
        for _dict in _messagesArray{
            
            _addMessage(MessageCell._Type_Time, __content:_dict.objectForKey("time") as! String)//----添加时间
            
            let _type:String = _dict.objectForKey("type") as! String
            switch _type{
            case "match":
                _addMessage(MessageCell._Type_Match, __content: _dict.objectForKey("content") as! String)
            case "message":
                _addMessage(MessageCell._Type_Message, __content: _dict.objectForKey("content") as! String)
            case "messageByMe":
                _addMessage(MessageCell._Type_Message_By_Me, __content: _dict.objectForKey("content") as! String)
            default:
                break
            }
            
            
        }
        _tableView?.reloadData()
        _tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
    }
    
    func _addMessage(__type:String,__content:String){
        var _h:CGFloat = 100
        switch __type{
        case MessageCell._Type_Time:
            _h = 30
        case MessageCell._Type_Match:
            _h = 200
        case MessageCell._Type_Message:
            _h = MessageCell._getHighByStr(__content)
        case MessageCell._Type_Message_By_Me:
            _h = MessageCell._getHighByStr(__content)
        default:
            break
        }
        
        _messages?.addObject(NSDictionary(objects: [__type,__content,_h], forKeys: ["type","content","height"]))
        
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
        _cell.initWidthFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60),__type: _dict.objectForKey("type") as! String)
        _cell._setContent(_dict.objectForKey("content") as! String)
        
        return _cell
    }
    func _setPorofileImg(__str:String){
        _profileImg?._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            
        })
    }
    func _setName(__str:String){
        _nameLabel?.text = __str
        _nameLabel?.sizeToFit()
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2+10 , y: 55)
        _profileImg?.center = CGPoint(x: (self.view.frame.width-_nameLabel!.frame.width)/2-10, y: 55)
    }
    
    //----输入框代理
    
    func _inputer_changed(__dict: NSDictionary) {
      
        let _h:CGFloat = _inputer!._getHeightOfBar()!
        
        UIView.animateWithDuration(0.35) { () -> Void in
            self._tableView?.transform = CGAffineTransformMakeTranslation(0,self._inputer!._heightOfClosed-_h)
        }
        
        
    }
    
    func _inputer_closed() {
        UIView.animateWithDuration(0.35) { () -> Void in
            self._tableView?.transform = CGAffineTransformMakeTranslation(0,0)
        }
        
        
    }
    func _inputer_opened() {
        let _h:CGFloat = _inputer!._getHeightOfBar()!
        UIView.animateWithDuration(0.35) { () -> Void in
            self._tableView?.transform = CGAffineTransformMakeTranslation(0,self._inputer!._heightOfClosed-_h)
        }
        
    }
    func _inputer_send(__dict: NSDictionary) {
        _addMessage(MessageCell._Type_Message_By_Me, __content: __dict.objectForKey("text") as! String)
        _tableView?.reloadData()
        _tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: _messages!.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
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