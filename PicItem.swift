
//
//  PicItem.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/30.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol PicItemDelegate:NSObjectProtocol{
    func _clicked()
    func _bingo(__x:Int,__y:Int)
    func _bingoFailed(__x:Int,__y:Int)
}

class PicItem: UIView {
    var _imageV:PicView?
    var _answerV:PicView?
    var _tapG:UITapGestureRecognizer?
    weak var _delegate:PicItemDelegate?
    var _clickSign:ClickSign?
    let _cornerRadius:CGFloat = 10
    var _dict:NSDictionary?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.clipsToBounds = true
        
        _imageV = PicView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        _imageV?.maximumZoomScale = 1
        _imageV?.minimumZoomScale = 1
        _imageV?._imgView!.layer.masksToBounds=true
        _imageV?._imgView!.layer.masksToBounds=true
        _imageV?._imgView!.contentMode = UIViewContentMode.ScaleAspectFill
        _imageV?._imgView!.layer.cornerRadius = _cornerRadius
        
        //_imageV?._setImage("noPic.jpg")
        
        _answerV = PicView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        _answerV?.maximumZoomScale = 1
        _answerV?.minimumZoomScale = 1
        _answerV?._imgView!.layer.masksToBounds=true
        _answerV?._imgView!.layer.masksToBounds=true
        _answerV?._imgView!.contentMode = UIViewContentMode.ScaleAspectFill
        _answerV?._imgView!.layer.cornerRadius = _cornerRadius
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))        
        addSubview(_imageV!)
        //addSubview(_answerV!)
    }
    func _ready(){
        self.addGestureRecognizer(_tapG!)
    }
    
    func tapHander(__sender:UITapGestureRecognizer){
        let _location:CGPoint = __sender.locationInView(_imageV)
        if _location.y > _imageV?.frame.height{
            return
        }
        _testIt(_location)
    }
    func _testIt(__p:CGPoint){
        _clickSign = ClickSign(frame: CGRect(x: __p.x, y: __p.y, width: 0, height: 0))
        addSubview(_clickSign!)
        _clickSign?._show()
        
        let _clickX =  Int(10000*__p.x/_answerV!.frame.width) //----x比例最大10000
        let _clickY =  Int(10000*__p.y/_answerV!.frame.height)
        
        if _answerV!._imgView!.image == nil{
            self.removeGestureRecognizer(_tapG!)
            _delegate?._bingoFailed(_clickX,__y: _clickY)
            return
        }
        let _p:CGPoint = CGPoint(x: __p.x*(_answerV!._imgView!.image!.size.width/_answerV!.frame.width), y: __p.y*(_answerV!._imgView!.image!.size.height/_answerV!.frame.height))
        let _alpha:CGFloat = CoreAction._getPixelAlphaFromImage(_p, __inImage: _answerV!._imgView!.image!)
       
       // print(_alpha)
        
        
        
        
        
        
        self.removeGestureRecognizer(_tapG!)
        _delegate?._clicked()
        if _alpha == 1{
            _delegate?._bingo(_clickX,__y: _clickY)
        }else{
            _showFail()
            _delegate?._bingoFailed(_clickX,__y: _clickY)
        }
        
    }
    func _showFail(){
        _imageV!._imgView!.image = CoreAction._converImageToGray(_imageV!._imgView!.image!)
    }
    func _delloc(){
        _imageV?.removeFromSuperview()
        _imageV = nil
        _clickSign?._out()
        _clickSign?.removeFromSuperview()
        _clickSign = nil
        _tapG = nil
        _delegate = nil
    }
    
    //---设置成加载状态
    func _setToLoading(){
        _imageV!._imgView!.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    //
    func _setToNone(){
        print("设为图片破裂")
        
        //_imageV!._imgView!.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
//        _imageV?._setPic(NSDictionary(objects: ["image_1","file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
//            
//        })
    }
    func _setPic(__set:String){
        _imageV?._setImage("noPic.jpg")
        _imageV?._setPic(NSDictionary(objects: [__set,"file"], forKeys: ["url","type"]), __block: { (dict:NSDictionary) -> Void in
            if dict.objectForKey("info") as! String == "failed"{
                print("底图加载失败！")
                self._setToNone()
            }
        })
        
    }
    func _setAnswer(__set:String){
        _answerV?._setPic(NSDictionary(objects: [__set,"file"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            if dict.objectForKey("info") as! String == "failed"{
                print("答案图加载失败")
            }
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

