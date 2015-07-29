
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.clipsToBounds = true
        
        _imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        _imageV!.layer.masksToBounds=true
        _imageV!.layer.cornerRadius = 40
        _imageV?.contentMode = UIViewContentMode.ScaleAspectFill
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        self.addGestureRecognizer(_tapG!)
        
        addSubview(_imageV!)
    }

    func tapHander(__sender:UITapGestureRecognizer){
    
        let _location:CGPoint = __sender.locationInView(_imageV)
        if _location.y > _imageV?.frame.height{
            return
        }
        _delegate?._clicked()
        
    }
    
    func _setPic(__set:String){
        _imageV?.image = UIImage(named: __set)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

