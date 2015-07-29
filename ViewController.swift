//
//  ViewController.swift
//  JPoint
//
//  Created by Bob Huang on 15/7/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var _mainView:MainView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _showMainView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func _showMainView(){
        if _mainView == nil{
            _mainView = MainView()
            
        }
        self.view.addSubview(_mainView!.view)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

