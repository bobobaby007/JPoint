//
//  RightPanel.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/8.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class RightPanel: UIViewController {
    var _setuped:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.whiteColor()
        //self.view.clipsToBounds = false
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
