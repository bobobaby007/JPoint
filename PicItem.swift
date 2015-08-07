
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
}

class PicItem: UIView {
    var _imageV:UIImageView?
    var _tapG:UITapGestureRecognizer?
    var _delegate:PicItemDelegate?
    var _clickSign:ClickSign?
    var _cornerRadius:CGFloat = 20
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.clipsToBounds = true
        
        _imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        _imageV!.layer.masksToBounds=true
        _imageV!.layer.cornerRadius = _cornerRadius
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        _imageV?.contentMode = UIViewContentMode.ScaleAspectFill
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))        
        addSubview(_imageV!)
    }
    
    func _ready(){
        self.addGestureRecognizer(_tapG!)
    }
    
    func tapHander(__sender:UITapGestureRecognizer){
        
        let _location:CGPoint = __sender.locationInView(_imageV)
        if _location.y > _imageV?.frame.height{
            return
        }
        
        let _point:CGPoint = __sender.locationInView(self)
        
        
        
        _clickSign = ClickSign(frame: CGRect(x: _point.x, y: _point.y, width: 0, height: 0))
        addSubview(_clickSign!)
        _clickSign?._show()
        
        self.removeGestureRecognizer(_tapG!)
        
        _delegate?._clicked()
        
    }
    
    func _setPic(__set:String){
        _imageV?.image = UIImage(named: __set)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

