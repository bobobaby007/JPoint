//
//  BingoView.swift
//  JPoint
//
//  Created by Bob Huang on 15/8/3.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class BingoView:UIViewController {
    var _setuped:Bool = false
    var _btn_talkNow:UIButton = UIButton()
    var _btn_notNow:UIButton = UIButton()
    var _bingoView:UIView = UIView()
    var _colorsV:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.clearColor()
        
        _colorsV.backgroundColor = UIColor.clearColor()
        
        
        _setuped = true
    }
    func _show(){
        self.view.addSubview(_bingoView)
        
        _colorsIn()
    }
    func _colorsIn(){
        println(random())
        for index in 0...10{
            var _v:UIView = UIView(frame: CGRect(x: 0, y: 0, width: random(), height: random()))
        }
    }
    func _clearColors(){
        let _array:NSArray = _colorsV.subviews
        
        for index in 0..._array.count{
            (_array.objectAtIndex(index) as? UIView)?.removeFromSuperview()
        }
        
        
    }
    
}
