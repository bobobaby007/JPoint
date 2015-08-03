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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
    }
}
