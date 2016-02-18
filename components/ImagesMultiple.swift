//
//  PicView.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/11.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class ImagesMultiple: UIImageView{
    let _gap:CGFloat = 5
    var _imagesV:UIView?
    var _bg:UIImageView?
    var _cornerRadius:CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.clipsToBounds = false
        _imagesV = UIView()
        _bg = UIImageView(image: UIImage(named: "bg.jpg"))
    }
    
    func _setImages(__images:NSArray){
        for subV in _imagesV!.subviews{
            subV.removeFromSuperview()
        }
        
        _bg?.frame = self.bounds
        addSubview(_bg!)
        
        
        self.addSubview(_imagesV!)
        
        let _n:Int = __images.count
        
        if _n<=0{
            return
        }
        
        let _sqrtNum:Int = Int( ceil(sqrt(Double(_n))))
        let _lineNum:Int = Int(ceil(Double(_n)/Double(_sqrtNum)))
        let _w:CGFloat = (self.frame.width-_gap)/CGFloat(_sqrtNum)-_gap
        
        
        let _points:NSMutableArray = []
        
        for var i:Int = 0; i<_sqrtNum*_sqrtNum; ++i{
            
            _points.addObject(NSDictionary(objects: [_gap+CGFloat(i%_sqrtNum)*(_w+_gap),_gap+CGFloat(Int(i/_sqrtNum))*(_w+_gap)], forKeys: ["x","y"]))
            
        }
        
        if _sqrtNum>1{
            for var i:Int = 0; i<_sqrtNum*_sqrtNum; ++i{
                let _to:Int = random()%(_sqrtNum*_sqrtNum-1)
                _points.exchangeObjectAtIndex(i, withObjectAtIndex: _to)
            }
        }
        
        for var i:Int = 0; i<_n; ++i{
            let _p:NSDictionary = _points.objectAtIndex(i) as! NSDictionary
           let _pic:PicView = PicView(frame: CGRect(x: _p.objectForKey("x") as! CGFloat, y: _p.objectForKey("y") as! CGFloat, width: _w, height: _w))
            _pic.layer.borderColor = UIColor(white: 1, alpha: 0.4).CGColor
            _pic.layer.borderWidth = 3
            _pic.layer.cornerRadius = _cornerRadius
            
            _pic._setPic(__images.objectAtIndex(i) as! NSDictionary) { (__dict) -> Void in
                
            }
            _imagesV!.addSubview(_pic)
        }
        
        
    }
    func _refersh(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}