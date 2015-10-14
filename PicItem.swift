
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
    func _bingo()
    func _bingoFailed()
}

class PicItem: UIView {
    var _imageV:PicView?
    var _answerV:PicView?
    var _tapG:UITapGestureRecognizer?
    weak var _delegate:PicItemDelegate?
    var _clickSign:ClickSign?
    let _cornerRadius:CGFloat = 10
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
        addSubview(_answerV!)
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
//        _clickSign = ClickSign(frame: CGRect(x: __p.x, y: __p.y, width: 0, height: 0))
//        addSubview(_clickSign!)
//        _clickSign?._show()
        //let _p:CGPoint = CGPoint(x: __p.x*(_answerV!._imgView!.image!.size.width/_answerV!.frame.width), y: __p.y*(_answerV!._imgView!.image!.size.height/_answerV!.frame.height))
        //let _color:UIColor = CoreAction._getPixelColor(_p, __inImage: _answerV!._imgView!.image!)
        let _alpha = CoreAction._getPixelAlpha(__p, __inView: _answerV!)
       // let _color = CoreAction._getPixelColor(__p, __inView: _answerV!)
        //let _image:UIImage = CoreAction._captureImage(_answerV!)
       // print(_image.size,__p,_answerV!.frame.size)
        //_imageV!._setImageByImage(_image)
        //_answerV?.hidden=true
        
        print(_alpha)
        
        //print(_color)
        
        
        
        //self.removeGestureRecognizer(_tapG!)
        
        _delegate?._clicked()
        
        
        
//        if random()%2 == 1{
//            _delegate?._bingo()
//        }else{
//            _delegate?._bingoFailed()
//        }
        
        
        
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
    func _setPic(__set:String){
        _imageV?._setPic(NSDictionary(objects: [__set,"fromWeb"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            
        })
    }
    func _setAnswer(__set:String){
        _answerV?._setPic(NSDictionary(objects: [__set,"fromWeb"], forKeys: ["url","type"]), __block: { (dict) -> Void in
            
        })
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

