//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation


protocol ImageViewerDelegate:NSObjectProtocol{
    func _imageViewer_canceled()
    func _mageViewer_saved()
}

class ImageViewer: UIViewController{
    var _picV:PicView?
    var _setuped:Bool = false
    var _imagePicker:UIImagePickerController?
    var _bg:UIView?
    weak var _parentViewController:UIViewController?
    var _imageIned:Bool = false
    
    weak var _delegate:ImageViewerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor = UIColor.clearColor()
        _bg = UIView(frame: self.view.frame)
        _bg?.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        _picV=PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _picV!._scaleType = PicView._ScaleType_Fit
        
        _setuped=true
    }
    func _setPic(__pic:NSDictionary){
        _picV?._setPic(__pic, __block: { (__dict) -> Void in
            
        })
        self.view.addSubview(_picV!)
    }
    override func viewWillDisappear(animated: Bool) {
        //_currentPic?.removeGestureRecognizer(_tapG!)
    }
}
