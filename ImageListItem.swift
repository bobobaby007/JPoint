//
//  ImageListItem.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class ImageListItem: UITableViewCell,BingoUserItemAtMyList_delegate{
    var inited:Bool = false
    var _bgImg:PicView?
    var _rect:CGRect?
    var _height:CGFloat = 10
    var _points:NSMutableArray?
    var _pointsView:UIView?
    var _signer:UserSign?
    let _cornerRadius:CGFloat = 10
    var _infoPanel:InfoPanel?
    let _imageInset:CGFloat = 10
    var _usersScroller:UIScrollView?
    var _usersIned:Bool = false
    var _textBubble:TextBubble?
    var _overShadow:UIImageView?
    weak var _parentDelegate:BingoUserItemAtMyList_delegate?
    
    func initWidthFrame(__frame:CGRect){
        if inited{
            
            
        }else{
            _rect = __frame
            self.backgroundColor = UIColor.clearColor()
            self.clipsToBounds = false
            
            //self.selectedBackgroundView = UIView()
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 5
            
           _bgImg = PicView(frame:CGRect(x: _imageInset, y: _imageInset, width: __frame.width-2*_imageInset, height: __frame.height-_imageInset))
            _bgImg?.layer.cornerRadius = _cornerRadius
            _bgImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _bgImg?.layer.shadowColor = UIColor.blackColor().CGColor
            _bgImg?.layer.shadowOpacity = 0.2
            _bgImg?.layer.shadowRadius = 5
            
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
            _infoPanel?.userInteractionEnabled = false
            addSubview(_infoPanel!)
            
            _textBubble = TextBubble(frame: CGRect(x: _imageInset, y: _bgImg!.frame.height+_imageInset+40, width: _rect!.width-2*_imageInset, height: 3))
            _textBubble?.userInteractionEnabled = false
           
            
            
            
            inited = true
        }
    }
    
    
    func _setInfos(__time:String,__clickNum:Int,__bingoNum:Int){
        _infoPanel?._setClick(__clickNum)
        _infoPanel?._setLike(__bingoNum)
        _infoPanel?._setTime(__time)
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
    func _getPoints(){
        
        if _pointsView == nil{
            _pointsView = UIView(frame: CGRect(x: _imageInset, y: _imageInset, width: _rect!.width-2*_imageInset, height: _rect!.width-2*_imageInset))
            _pointsView?.layer.cornerRadius = _cornerRadius
            _pointsView?.clipsToBounds = true
            _pointsView?.userInteractionEnabled = false
        }
        addSubview(_pointsView!)
        
        
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
        
        
       
    }
    
    func _addPointAt(__x:CGFloat,__y:CGFloat,__tag:Int){
        let __p:CGPoint = CGPoint(x: _imageInset+__x*(_rect!.width-2*_imageInset)/100, y: _imageInset+__y*(_rect!.width-2*_imageInset)/100)
        let _r:CGFloat = 5 + CGFloat(random()%50)
        
        let _item:PointItem = PointItem()
        _item._setupWidthFrame(CGRect(x: 0, y: 0, width: 2*_r, height: 2*_r), __number: 30,__r:_r)
        
        _item.transform = CGAffineTransformMakeScale(2, 2)
        _item.alpha = 0
        _item.center = __p
        
        UIView.animateWithDuration(0.4, delay:Double(0.01*CGFloat(random()%100)), options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            _item.transform = CGAffineTransformMakeScale(1, 1)
            _item.alpha = 0.6
            }, completion: { (stop) -> Void in
                
        })
        _pointsView!.addSubview(_item)
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
        
        for _index:Int in 0...12{
            let _user:BingoUserItemAtMyList = BingoUserItemAtMyList()
            _user.initWidthFrame(CGRect(x: 0, y: 0, width: _w, height: _h))
            _user.frame = CGRect(x: (_w+_gap)*CGFloat(_index), y: 0, width: _w, height: _h)
            _user._index = _index
            _user._id = String(_index)
            _user._delegate = self
            _user._setPic("profile")
            _user._setName("小甜菜")
            _usersScroller?.addSubview(_user)
            
        }
        _usersScroller?.contentSize = CGSize(width: 13*(_w+_gap), height: _h)
        
        
        
    }
    //----代理
    func _needToTalk(__id: String) {
        _parentDelegate?._needToTalk(__id)
    }
    func _showUser(__index: Int) {
        let __dict:NSDictionary = _points!.objectAtIndex(__index) as! NSDictionary
        //print(__dict)
        _showPoint(__dict)

    }
    func _clearUsers(){
        if _usersScroller == nil{
            return
        }
        for _subV in _usersScroller!.subviews{
            _subV.removeFromSuperview()
        }
    }
    func _getUsers(){
        
        _clearUsers()
        _usersIn()
    }
    
    
    func _open(){
        _overShadow?.hidden=true
        _textBubble!.frame = CGRect(x: _imageInset, y: _bgImg!.frame.height+_imageInset+15, width: _rect!.width-2*_imageInset, height: _textBubble!.frame.height)
        addSubview(_textBubble!)
        //print(_textBubble!._mySize)
         _infoPanel!.frame = CGRect(x: _imageInset+5, y: _textBubble!.frame.origin.y+_textBubble!.frame.height+10, width: _rect!.width-2*_imageInset-10, height: 30)
        _getPoints()
        _getUsers()
    }
    func _close(){
        
        _overShadow?.hidden = false
        
        if _usersScroller != nil{
          _usersScroller?.removeFromSuperview()
          _usersScroller = nil
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

    }
    
    func _setPic(__picUrl:String){
        _bgImg?._setImage(__picUrl)
        _bgImg?._refreshView()
    }
    func _setText(__str:String){
        _textBubble?._setSay(__str)
    }
    override func setSelected(selected: Bool, animated: Bool) {
       
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
}
