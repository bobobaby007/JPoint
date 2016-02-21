//
//  ImageListItem.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class ImageListItem: UITableViewCell,BingoUserItemAtMyList_delegate,InfoPanel_delegate,MyAlerter_delegate{
    var _indexPath:NSIndexPath?
    var inited:Bool = false
    var _id:String = ""
    var _bgImg:PicView?
    var _rect:CGRect?
    var _height:CGFloat = 10
    var _points:NSMutableArray?//----bingo中的点
    var _hotPoints:NSArray?//----热点图的点
    
    var _pointsView:UIView?
    var _signer:UserSign?
    let _cornerRadius:CGFloat = 10
    var _infoPanel:InfoPanel?
    let _imageInset:CGFloat = 10
    var _usersScroller:UIScrollView?
    var _usersIned:Bool = false
    var _textBubble:TextBubble?
    var _overShadow:UIImageView?
    
    var _label_noUserBingo:UILabel?
    
    weak var _parentDelegate:BingoUserItemAtMyList_delegate?
    
    var _bingoUsers:NSArray = []
    
    var _maxNum:Int = 1 //----点过的范围内次数最多的点击数
    
    
    var _dict:NSDictionary?
    
    var _alerter:MyAlerter?
    
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            _rect = __frame
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = false
            
            //self.selectedBackgroundView = UIView()
//            self.layer.shadowColor = UIColor.blackColor().CGColor
//            self.layer.shadowOpacity = 0.3
//            self.layer.shadowOffset = CGSize(width: 0, height: 0)
//            self.layer.shadowRadius = 5
            
           _bgImg = PicView(frame:CGRect(x: _imageInset, y: _imageInset, width: __frame.width-2*_imageInset, height: __frame.height-_imageInset))
            _bgImg?.layer.cornerRadius = _cornerRadius
            _bgImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
//            _bgImg?.layer.shadowColor = UIColor.blackColor().CGColor
//            _bgImg?.layer.shadowOpacity = 0.2
//            _bgImg?.layer.shadowRadius = 5
            
            addSubview(_bgImg!)
            _bgImg?.userInteractionEnabled = false
            _overShadow = UIImageView(image: UIImage(named: "shadowOver"))
            
            let _w:CGFloat = _rect!.width-2*_imageInset
            let _h:CGFloat = 84*_w/577
            _overShadow?.frame = CGRect(x: _imageInset, y: _rect!.height-_h, width: _w, height: _h)
            _overShadow?.layer.cornerRadius = _cornerRadius
            _overShadow?.clipsToBounds = true
            addSubview(_overShadow!)
            
            _infoPanel = InfoPanel(frame: CGRect(x: _imageInset+5, y: _bgImg!.frame.height+_imageInset-30, width: _rect!.width-2*_imageInset-10, height: 30))
            //_infoPanel?.userInteractionEnabled = false
            _infoPanel?._delegate = self
            //_infoPanel?._setToMyInfo()
            addSubview(_infoPanel!)
            
            _textBubble = TextBubble(frame: CGRect(x: _imageInset, y: _bgImg!.frame.height+_imageInset+40, width: _rect!.width-2*_imageInset, height: 3))
            _textBubble?.userInteractionEnabled = false
           
            inited = true
        }
    }
    func _getDatas(){
        MainAction._getImageDetails(_id) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                //_MyImageList = __dict.objectForKey("info") as! NSArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _usrs:NSArray = __dict.objectForKey("bingos") as! NSArray
                    self._bingoUsers = self._checkUsers(_usrs)
                    self._getUsers()
                    self._getPoints()
                })
                return
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._bingoUsers = []
                    self._getUsers()
                    self._getPoints()
                })
            }
            //self._getPoints()
        }
        //------获取所有的点击数据
        MainAction._getImageAllClicks(_id) { (__dict) -> Void in
            
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                //_MyImageList = __dict.objectForKey("info") as! NSArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _points:NSArray = __dict.objectForKey("info") as! NSArray
                    self._hotPoints = self._getHotPoints(_points)
                    print(self._hotPoints)
                    self._HotPointsIn()
                })
                return
            }else{
                
            }
            //self._getPoints()
        }
    }
    
    func _changeToHeight(__height:CGFloat){
        _height = __height
        if __height>=_bgImg!.frame.width{
            _bgImg?.frame = CGRect(x: _imageInset, y: _imageInset, width: _rect!.width-2*_imageInset, height: _rect!.width-2*_imageInset)
        }else{
            _bgImg?.frame = CGRect(x: _imageInset, y: _imageInset, width: _rect!.width-2*_imageInset, height: __height-_imageInset)
            
        }
        _bgImg?._refreshView()
        
    }
    //-----载入bingo中的人的圈圈位置
    func _getPoints(){
        _points = NSMutableArray()
        for var i:Int = 0 ; i < _bingoUsers.count; ++i {
                let __dict:NSDictionary = self._bingoUsers.objectAtIndex(i) as! NSDictionary
                let _nat:NSDictionary = __dict.objectForKey("nat") as! NSDictionary
                let __p:NSDictionary = NSDictionary(objects: [(_nat.objectForKey("x") as! CGFloat)/100,(_nat.objectForKey("y") as! CGFloat)/100], forKeys: ["x","y"])
              self._points?.addObject(__p)
            
        }
    }
    
    //载入热点图的点
    func _HotPointsIn(){
        if _pointsView == nil{
            _pointsView = UIView(frame: CGRect(x: _imageInset, y: _imageInset, width: _rect!.width-2*_imageInset, height: _rect!.width-2*_imageInset))
        }
        _pointsView?.layer.cornerRadius = _cornerRadius
        _pointsView?.clipsToBounds = true
        _pointsView?.userInteractionEnabled = false
        _pointsView?.backgroundColor = UIColor.clearColor()
        //addSubview(_pointsView!)
        self.insertSubview(_pointsView!, belowSubview: _infoPanel!)
        
        for var i:Int = 0; i < _hotPoints?.count; ++i {
            let _dict:NSDictionary = _hotPoints?.objectAtIndex(i) as! NSDictionary
            //print(_dict)
           _addPointAt((_dict.objectForKey("x") as! CGFloat)/10000,__y: (_dict.objectForKey("y") as! CGFloat)/10000,__tag:i,__num:_dict.objectForKey("num") as! Int )
        }
    }
    
    
    
    //----添加一个热点圈圈
    
    func _addPointAt(__x:CGFloat,__y:CGFloat,__tag:Int,__num:Int){
        let __p:CGPoint = CGPoint(x: __x*(_rect!.width-2*_imageInset), y: __y*(_rect!.width-2*_imageInset))
        let _r:CGFloat = 10 + 20 * CGFloat(__num)/CGFloat(_maxNum)
        let _item:PointItem = PointItem()
        _item.frame = CGRect(x: __p.x, y: __p.y, width: 0, height: 0)
        _item._setupWidthFrame(__p, __width: _rect!.width-2*_imageInset, __number: __num, __r: _r)
        
        _item.userInteractionEnabled = false
        //_item.transform = CGAffineTransformMakeScale(2, 2)
        //_item.alpha = 0.6
        //_item.center = __p
        _pointsView!.addSubview(_item)
//        
//        UIView.animateWithDuration(0.4, delay:0.01+Double(0.01*Double(__tag)), options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            _item.transform = CGAffineTransformMakeScale(1, 1)
//            _item.alpha = 0.6
//            }, completion: { (stop) -> Void in
//                
//        })
        
        
        
        
        
        
        
        
    }
    func _showPoint(__dict:NSDictionary){
        let __p:CGPoint = CGPoint(x: _imageInset + (__dict.objectForKey("x") as! CGFloat)*(_rect!.width-2*_imageInset)/100, y: _imageInset+(__dict.objectForKey("y") as! CGFloat)*(_rect!.width-2*_imageInset)/100)
        
        if _signer != nil{
            
        }else{
            _signer = UserSign()
        }
        _signer!.center = __p
        
        self.addSubview(_signer!)
        _signer!._show()
        
        
    }
    
    //----判断是否有bingo用户
    func _ifHaseUsers(){
        if self._bingoUsers.count == 0{
            if _label_noUserBingo == nil{
                let _h:CGFloat = _height - _infoPanel!.frame.origin.y - _infoPanel!.frame.height - 25 - 10
                _label_noUserBingo = UILabel(frame: CGRect(x: _imageInset, y:_height-_h-10, width: _rect!.width-2*_imageInset, height: _h))
                _label_noUserBingo?.lineBreakMode = NSLineBreakMode.ByCharWrapping
                _label_noUserBingo?.text = "目前还没有人猜中您的心思\n再等等，也许是你设置的难度有点大"
                _label_noUserBingo?.textAlignment = NSTextAlignment.Center
                _label_noUserBingo?.clipsToBounds = true
                _label_noUserBingo?.layer.cornerRadius = 5
                _label_noUserBingo?.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
               // _label_noUserBingo?.textColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5)
                _label_noUserBingo?.textColor = UIColor.whiteColor()
                
            }
            self.addSubview(_label_noUserBingo!)
        }else{
            if _label_noUserBingo != nil{
                _label_noUserBingo?.removeFromSuperview()
                _label_noUserBingo = nil
            }
            self._usersIn()
            
        }
    }
    func _usersIn(){
        let _h:CGFloat = _height - _infoPanel!.frame.origin.y - _infoPanel!.frame.height - 25
        let _w:CGFloat = _h-50
        let _gap:CGFloat = 20
        _usersScroller = UIScrollView(frame: CGRect(x: _imageInset, y:_height-_h, width: _rect!.width-2*_imageInset, height: _h))
        _usersScroller?.bounces = true
        _usersScroller?.clipsToBounds = false
        _usersScroller?.showsHorizontalScrollIndicator = false
        _usersScroller?.showsVerticalScrollIndicator = false
        
        self.addSubview(_usersScroller!)
        
        for var _index:Int = 0; _index < _bingoUsers.count; ++_index {
            let _user:BingoUserItemAtMyList = BingoUserItemAtMyList()
            
            let __dict:NSDictionary = _bingoUsers.objectAtIndex(_index) as! NSDictionary
            //print("__dict",__dict)
            let _userDict:NSDictionary = __dict.objectForKey("author") as! NSDictionary
            
            _user.initWidthFrame(CGRect(x: 0, y: 0, width: _w, height: _h))
            _user.frame = CGRect(x: (_w+_gap)*CGFloat(_index), y: 0, width: _w, height: _h)
            _user._index = _index
            _user._dict = _userDict
            _user._delegate = self
            _user._setPic(MainAction._avatar(_userDict))
            _user._setName(MainAction._nickName(_userDict))
            _usersScroller?.addSubview(_user)
            
        }
        _usersScroller?.contentSize = CGSize(width: CGFloat(_bingoUsers.count)*(_w+_gap), height: _h)
    }
    //----bingo用户代理
    func _needToTalk(__dict: NSDictionary) {
        _parentDelegate?._needToTalk(__dict)
    }
    
    func _showUser(__index: Int) {
        let __dict:NSDictionary = _points!.objectAtIndex(__index) as! NSDictionary
        //print(__dict)
        _showPoint(__dict)

    }
    //-----清除用户
    func _clearUsers(){
        if _usersScroller == nil{
            return
        }
        for _subV in _usersScroller!.subviews{
            _subV.removeFromSuperview()
        }
        _usersScroller?.removeFromSuperview()
        _usersScroller = nil
    }
    
    //-----获取bingo的用户
    func _getUsers(){
        self._clearUsers()
        self._ifHaseUsers()
    }
    
    
    func _open(){
        _overShadow?.hidden=true
        _textBubble!.frame = CGRect(x: _imageInset, y: _bgImg!.frame.height+_imageInset+15, width: _rect!.width-2*_imageInset, height: _textBubble!.frame.height)
        addSubview(_textBubble!)
        addSubview(_infoPanel!)
        //_infoPanel?._btn_share?.hidden = false
        //print(_textBubble!._mySize)
         _infoPanel!.frame = CGRect(x: _imageInset+5, y: _textBubble!.frame.origin.y+_textBubble!.frame.height+10, width: _rect!.width-2*_imageInset-10, height: 30)
        _getDatas()
    }
    
    
    //----------提取热点的点用来显示
    func _getHotPoints(__array:NSArray)->NSArray{
        let _arr:NSMutableArray = []
        _maxNum = 1
        for var i:Int = 0;i<__array.count; ++i{
            let _dict:NSDictionary = __array.objectAtIndex(i) as! NSDictionary
            let _nat:NSDictionary = _dict.objectForKey("nat") as! NSDictionary
            let _p_i:CGPoint = CGPoint(x: _nat.objectForKey("x") as! CGFloat, y: _nat.objectForKey("y") as! CGFloat)
            var _has:Bool = false
            for var d:Int = 0; d<_arr.count; ++d{
                let _dict_d:NSDictionary = _arr.objectAtIndex(d) as! NSDictionary
                let _p_d:CGPoint = CGPoint(x: _dict_d.objectForKey("x") as! CGFloat, y: _dict_d.objectForKey("y") as! CGFloat)
                //print(_p_d)
                
                let xDist:CGFloat = (_p_d.x - _p_i.x); //[2]
                let yDist:CGFloat = (_p_d.y - _p_i.y); //[3]
                let _distance:CGFloat = sqrt((xDist*xDist) + (yDist*yDist))
                
                if abs(_distance)<1000{
                    let _newDict:NSMutableDictionary = NSMutableDictionary(dictionary: _dict_d)
                    let _num:Int = _newDict.objectForKey("num") as! Int
                    if _num+1>_maxNum{
                        _maxNum = _num+1
                    }
                    
                    _newDict.setObject(_num+1, forKey: "num")
                    
                    _newDict.setObject((_p_d.x*CGFloat(_num)+_p_i.x)/CGFloat(_num+1), forKey: "x")
                    _newDict.setObject((_p_d.y*CGFloat(_num)+_p_i.y)/CGFloat(_num+1), forKey: "y")
                    _has = true
                    _arr[d] = _newDict
                    break
                }else{
                    
                }
            }
            if _has{
                
            }else{
                _arr.addObject(NSDictionary(objects: [_p_i.x,_p_i.y,1.0], forKeys: ["x","y","num"]))
            }
        }
        return _arr
    }
    
    
    
    //-----用户去重
    func _checkUsers(__array:NSArray)->NSArray{
        let _all:NSArray = NSArray(array: __array)
        let _resultArray:NSMutableArray = []
        
        for var i:Int = 0; i<_all.count; ++i{
            let _dict = _all.objectAtIndex(i) as! NSDictionary
            var _hased:Bool = false
            for var d:Int = 0; d<_resultArray.count; ++d{
                let __dict = _resultArray.objectAtIndex(d) as! NSDictionary
                if _dict.isEqualToDictionary(__dict as [NSObject : AnyObject]){
                    //print("----",d,i)
                    _hased =  true
                    break
                }
                //print(d,i)
                
            }
            if _hased{
                
            }else{
               _resultArray.addObject(_dict)
            }
            //print(i)
        }
        return _resultArray
    }
    func _close(){
        
        _overShadow?.hidden = false
        
        if _usersScroller != nil{
          _usersScroller?.removeFromSuperview()
          _usersScroller = nil
        }
        if _label_noUserBingo != nil{
            _label_noUserBingo?.removeFromSuperview()
            _label_noUserBingo = nil
        }

        if _pointsView != nil{
            _pointsView?.removeFromSuperview()
            _pointsView = nil
        }
        if _signer != nil{
            _signer?.removeFromSuperview()
            _signer = nil
        }
        if _textBubble != nil{
           // _textBubble?.transform = CGAffineTransformMakeScale(0, 0)
            _textBubble?.removeFromSuperview()
        }
        
        _infoPanel!.frame = CGRect(x: _imageInset+5, y: _bgImg!.frame.height+_imageInset-30, width: _rect!.width-2*_imageInset-10, height: 30)
        
        //_infoPanel?.userInteractionEnabled = false
        
    }
    //----信息条代理
    func _moreAction(){
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        
        print("信息条代理")
        
       MyImageList._self!.addChildViewController(_alerter!)
       MyImageList._self!.view!.addSubview(_alerter!.view)
       
        _alerter?._setMenus(["分享图片给朋友","发给朋友来玩","分享到微信朋友圈","删除图片"])
        
        _alerter?._show()
    }
    //----弹出选择按钮代理
    func _myAlerterClickAtMenuId(__id: Int) {
        switch __id{
        case 0:
            sendWXImageToUser()
            break
        case 1:
            sendWXContentUser()
            break
        case 2:
            sendWXContentFriend()
            break
        case 3://
            MyImageList._self?._toDelete(_indexPath!)
            break
        default:
            break
        }
    }
    func _myAlerterDidClose(){
        
        _alerter = nil
    }
    //---微信分享
    func sendWXImageToUser() {//分享给朋友！图片！
        let _rect:CGRect = CGRect(x: 0, y: 0, width: self.frame.width-2*_imageInset, height: self.frame.width-2*_imageInset)
        
       // let _bg_img:UIImage = CoreAction._captureImage(_bgImg!)
        let _bgV:UIImageView = UIImageView(frame: _rect)
        _bgV.image = _bgImg?._imgView?.image
        
        let _stamp:UIImageView = UIImageView(frame: CGRect(x: 1, y: 1, width: 81, height: 30))
        _stamp.image=UIImage(named: "logo_stamp")
        //_stamp.alpha = 0.9
        let _points_img:UIImage = CoreAction._captureImage(_pointsView!)
        let _pointsV:UIImageView = UIImageView(frame: _rect)
        _pointsV.image = _points_img
    
        let _picV:UIView = UIView(frame: _rect)
        _picV.addSubview(_bgV)
        _picV.addSubview(_pointsV)
        _picV.addSubview(_stamp)
        
        
        let _picImage:UIImage = CoreAction._captureImage(_picV)
        
        let _thumbImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        _thumbImage.image = _picImage
        let _thumbImage_image = CoreAction._captureImage(_thumbImage)
        
        let message:WXMediaMessage = WXMediaMessage()
        message.title = "都爱点哪里"
        message.description = "哈哈，好玩，看大家都爱点哪里"
        message.setThumbImage(_thumbImage_image);
        let __img:WXImageObject = WXImageObject()
        __img.imageData = UIImageJPEGRepresentation(_picImage,0.7)
        
        message.mediaObject = __img
        let resp = GetMessageFromWXResp()
        resp.message = message
        //addSubview(_picV)
        //print(resp)
        
        WXApi.sendResp(resp);
        
//        let req = SendMessageToWXReq()
//        req.scene = 1
//        req.text = "哈哈，好玩，看大家都爱点哪里"
//        req.bText = false
//        req.message = message
//        WXApi.sendReq(req);
    }
    
    
    func sendWXContentUser() {//分享给朋友！！
        let _image:UIImage = _bgImg!._imgView!.image!
        let _thumbImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        _thumbImage.image = _image
        let _pic:UIImage = CoreAction._captureImage(_thumbImage)
        
        
        
        let message:WXMediaMessage = WXMediaMessage()
        var _str:String = _dict!.objectForKey("question") as! String
        if _str == ""{
            _str = MainAction._defaultQuestions[random()%MainAction._defaultQuestions.count] as! String
        }
        message.title = "快来 BingoMe"
        message.description = "\(_str)"
        message.setThumbImage(_pic);
        let ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "http://bingome.giccoo.com/v1/share/?bingo=\(_dict!.objectForKey("_id") as! String)&uid=\(MainAction._profileDict!.objectForKey("_id") as! String)"
        message.mediaObject = ext
        let resp = GetMessageFromWXResp()
        resp.message = message
        WXApi.sendResp(resp);
    }
    
    func sendWXContentFriend() {//分享朋友圈
        let _image:UIImage = _bgImg!._imgView!.image!
        let _thumbImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        _thumbImage.image = _image
        let _pic:UIImage = CoreAction._captureImage(_thumbImage)
        
        let message:WXMediaMessage = WXMediaMessage()
        
        
        var _str:String = _dict!.objectForKey("question") as! String
        if _str == ""{
            _str = MainAction._defaultQuestions[random()%MainAction._defaultQuestions.count] as! String
        }
        
        message.title = "快来 BingoMe"
        message.description = "\(_str)"
        message.setThumbImage(_pic);
        
        let ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "http://bingome.giccoo.com/v1/share/?bingo=\(_dict!.objectForKey("_id") as! String)&uid=\(MainAction._profileDict!.objectForKey("_id") as! String)"
        message.mediaObject = ext
        message.mediaTagName = "Bingo一下"
        let req = SendMessageToWXReq()
        req.scene = 1
        req.text = "来，点一下"
        req.bText = false
        req.message = message
        WXApi.sendReq(req);
    }
    
    
    
    func _setDict(__dict:NSDictionary){
        _dict = __dict
        _id = __dict.objectForKey("_id") as! String
        _setInfos(CoreAction._dateDiff(__dict.objectForKey("create_at") as! String), __clickNum: __dict.objectForKey("like") as! Int, __bingoNum: __dict.objectForKey("over") as! Int)
        _setText(__dict.objectForKey("question") as! String)
        _setPic(MainAction._imageUrl(__dict.objectForKey("image") as! String))
    }
    
    func _setInfos(__time:String,__clickNum:Int,__bingoNum:Int){//view 查看次数，click 点击次数，over点中次数
        _infoPanel?._setClick(__clickNum)
        _infoPanel?._setBingo(__bingoNum)//-----点中次数
        _infoPanel?._setTime(__time)
    }
    
    func _setPic(__picUrl:String){
        _bgImg?._loadImage(__picUrl)
        //_bgImg?._refreshView()
    }
    func _setText(__str:String){
        if __str==""{
           _textBubble?.alpha = 0.4
        }else{
            _textBubble?.alpha = 1
        }
        _textBubble?._setSay(__str)
    }
    override func setSelected(selected: Bool, animated: Bool) {
       
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
}
