//
//  TextBubble.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/4.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class TextBubble: UIView  {
    var _boxV:UIView?
    var _sayW:CGFloat = 0.0
    var _sayText:UITextView?
    var _arrowV:UIImageView?
    let _insert:CGFloat = 5
    var _mySize:CGSize?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.blueColor()
        self.clipsToBounds = false
        _boxV = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        _boxV!.layer.cornerRadius = 10
        _boxV!.backgroundColor = UIColor.whiteColor()
        
        _sayW = frame.width-2*_insert
        
        _sayText = UITextView(frame: CGRect(x: _insert, y: _insert, width: _sayW, height: frame.height))
        _sayText!.textColor = UIColor(red: 76/255, green: 83/255, blue: 126/255, alpha: 1)
        _sayText!.editable = false
        _sayText!.scrollEnabled = false
        _sayText!.font = UIFont.systemFontOfSize(14)
        _sayText!.backgroundColor = UIColor.clearColor()
        
        _boxV!.addSubview(_sayText!)
        
        
        _arrowV = UIImageView(image: UIImage(named: "arrow.png"))
        _arrowV!.frame = CGRect(x:18, y:-9, width: 12, height: 20)
        //_arrowV?.transform = CGAffineTransformMakeRotation(3.14/4)
        
        self.addSubview(_arrowV!)
        self.addSubview(_boxV!)
    }
    
    func _setSay(__set:String){
        _sayText?.text = __set
        
        let _size:CGSize = _sayText!.sizeThatFits(CGSize(width: _sayW, height: CGFloat.max))
        //_sayText?.alpha = 0
         self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self._sayW+2*self._insert, height: _size.height+2*self._insert)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
           
            self._boxV?.frame = CGRect(x: 0, y: 0, width: self._sayW+2*self._insert, height: _size.height+2*self._insert)
            self._sayText?.frame = CGRect(x: self._insert, y: self._insert, width: self._sayW, height: _size.height)
            
        })
        
        _mySize = CGSize(width: _size.width+2*_insert, height: _size.height+2*_insert)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
