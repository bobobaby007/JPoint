//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class ProfilePage:UIViewController,ImageInputerDelegate,UITextFieldDelegate{
    var _setuped:Bool = false
    
    var _btn_back:UIButton?
    let _cellHeight:CGFloat = 140
    var _selectedIndex:NSIndexPath?
    var _messages:NSMutableArray? = NSMutableArray()
    var _bgImg:PicView!
    var _blurV:UIVisualEffectView?
    var _btn_profile:UIButton?
    var _btn_uploadProfile:UIButton?
    var _profileImg:PicView?
    var _btn_save:UIButton?
    
    var _users:NSMutableArray?
    var _datained:Bool = false
    var _topView:UIView?
    weak var _parentView:LeftPanel?
    
    var _inputer:Inputer?
    var _nameLabel:UILabel?
    
    var _latestTime:NSTimeInterval?
    let _barH:CGFloat = 60
    
    var _seg_sex:UISegmentedControl?
    
    var _label_name:UILabel?
    var _text_name:UITextField?
    
    var _imageInputer:ImageInputer?
    
    var _changed:Bool = false
    var _tap:UITapGestureRecognizer?
    
    let _central_w:CGFloat = 250
    
    var _profile_old:NSDictionary?
    
    var _imageChanged:Bool = false
    
    
    var _failPanelV:UIView?
    let _failPanelH:CGFloat = 60
    var _failLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        _getProfile()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.automaticallyAdjustsScrollViewInsets = false
        _bgImg = PicView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        _bgImg._setPic(NSDictionary(objects: ["bg.jpg","file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
        })
        //_bgImg._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
       // _bgImg._refreshView()
        //var _uiV:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        
        
        _btn_profile = UIButton(type: UIButtonType.Custom)
        
        _btn_profile!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        _btn_profile?.center = CGPoint(x: self.view.frame.width/2, y: 120)
        
        _btn_profile?.clipsToBounds = true
        _btn_profile!.layer.cornerRadius = 50
        _btn_profile?.layer.borderWidth = 2
        _btn_profile?.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_profile!.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        //_btn_profile?.backgroundColor = UIColor.clearColor()
        _btn_profile?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_uploadProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        _btn_uploadProfile?.center = CGPoint(x: self.view.frame.width/2+30, y: 120+30+10)
        _btn_uploadProfile?.setImage(UIImage(named: "uploadProfileIcon"), forState: UIControlState.Normal)
        _btn_uploadProfile?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _seg_sex = UISegmentedControl(items: ["女","男"])
        
        _seg_sex?.tintColor = UIColor.whiteColor()
        _seg_sex?.frame = CGRect(x: 0, y: 0, width: _central_w, height: 40)
        _seg_sex?.center = CGPoint(x: self.view.frame.width/2, y: 220)
        //_seg_sex?.selectedSegmentIndex = 0
        _seg_sex?.enabled = true
        //_seg_sex?.momentary = true
        _seg_sex?.setEnabled(true, forSegmentAtIndex: 0)
        _seg_sex?.addTarget(self, action: "segHander:", forControlEvents: UIControlEvents.TouchUpInside)
        //_seg_sex?.addTarget(self, action: "segHander:", forControlEvents: UIControlEvents.ValueChanged)
        //_seg_sex?.userInteractionEnabled = true
        
        //_seg_sex?.setEnabled(true, forSegmentAtIndex: 0)
        _seg_sex?.setEnabled(true, forSegmentAtIndex: 1)
        
        _profileImg = PicView()
        
        _tap = UITapGestureRecognizer(target: self, action: "tapHander:")
    
        self.view.addSubview(_bgImg)
        self.view.addSubview(_btn_profile!)
        self.view.addSubview(_btn_uploadProfile!)
        self.view.addSubview(_seg_sex!)
        
        
        
        _topView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topView?.clipsToBounds = true
        _topView?.backgroundColor = UIColor.clearColor()
        _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        //_blurV?.alpha = 0.5
        _blurV?.frame = _topView!.bounds
        _topView?.addSubview(_blurV!)
        
        _btn_back = UIButton(frame: CGRect(x: 10, y: 20, width: 30, height: 30))
        _btn_back?.center = CGPoint(x: 30, y: _barH/2+6)
        _btn_back?.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        _btn_back?.transform = CGAffineTransformRotate((_btn_back?.transform)!, -3.14*0.5)
        _btn_back?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _topView?.addSubview(_btn_back!)
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        _nameLabel?.textAlignment = NSTextAlignment.Center
        _nameLabel?.center = CGPoint(x:self.view.frame.width/2 , y: _barH/2+7)
        _nameLabel?.font = UIFont.boldSystemFontOfSize(20)
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.text = "编辑资料"
        
        
        _btn_save = UIButton(frame: CGRect(x: 10, y: 20, width: 100, height: 40))
        _btn_save?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save?.center = CGPoint(x: self.view.frame.width-30, y: _barH/2+7)
        _btn_save?.setTitle("保存", forState: UIControlState.Normal)
        
        _topView?.addSubview(_nameLabel!)
        _topView?.addSubview(_btn_save!)
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topView!)
        
        
        _label_name = UILabel(frame: CGRect(x: (self.view.frame.width - _central_w)/2, y: 260, width: 50, height: 30))
        _label_name?.text = "昵称:"
        _label_name?.textAlignment = NSTextAlignment.Left
        _label_name?.textColor = UIColor.darkGrayColor()
        
        
        _text_name = UITextField(frame: CGRect(x: (self.view.frame.width - _central_w)/2+50, y: 260, width: _central_w-50, height: 30))
        
        _text_name?.textAlignment = NSTextAlignment.Right
        _text_name?.text = "输入名字"
        _text_name?.delegate = self
        _text_name?.textColor = UIColor.whiteColor()
        
        let _line:UIView = UIView(frame: CGRect(x: (self.view.frame.width - _central_w)/2, y: 260+30, width: _central_w, height: 1))
        _line.backgroundColor = UIColor.whiteColor()
        
        
        self.view.addSubview(_label_name!)
        self.view.addSubview(_line)
        self.view.addSubview(_text_name!)
        
        let _logo:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        _logo.contentMode = UIViewContentMode.ScaleAspectFit
        _logo.image = UIImage(named: "logo_white")
        _logo.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 60)
        
        
        
        let _label_intro:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        _label_intro.font = UIFont.systemFontOfSize(12)
        _label_intro.text = "Beijing Xuyilingdong Network Technology Co., Ltd."
        _label_intro.textColor = UIColor.whiteColor()
        _label_intro.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 20)
        
        self.view.addSubview(_logo)
        self.view.addSubview(_label_intro)
        
        
        _setuped=true
    }
    
    //----文字输入代理
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.view.addGestureRecognizer(_tap!)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.removeGestureRecognizer(_tap!)
        return true
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 30
    }
    
    func _getProfile(){
        let __dict:NSDictionary = MainAction._Profile()
        
        self._profile_old = __dict
        print("用户信息：",__dict)
        if let _sex = __dict.objectForKey("sex") as? Int{
            self._seg_sex?.selectedSegmentIndex = _sex
        }else{
            self._seg_sex?.selectedSegmentIndex = -1
        }
        if let _nickname = __dict.objectForKey("nickname") as? String{
            self._text_name?.text = _nickname
        }else{
            self._text_name?.text = ""
        }
        self._setProfileImg(MainAction._avatar(__dict))
    }
    
    
    func _setProfileImg(__str:String){
        _profileImg!._setPic(NSDictionary(objects: [__str,"file"], forKeys: ["url","type"]), __block: { (_dict) -> Void in
            self._btn_profile!.setImage(self._profileImg!._imgView!.image, forState: UIControlState.Normal)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func segHander(sender:UISegmentedControl){
        
        print(sender.selectedSegmentIndex)
    }
    
    func _showInputer(){
        if _imageInputer == nil{
            _imageInputer = ImageInputer()
            _imageInputer?._parentViewController = self
            _imageInputer?._delegate = self
            self.addChildViewController(_imageInputer!)
            self.view.addSubview(_imageInputer!.view)
        }
        
    }
    //------点击关闭键盘
    func tapHander(__sender:UITapGestureRecognizer){
        self.view.removeGestureRecognizer(_tap!)
        _text_name?.resignFirstResponder()
    }
    
    
    
    //---替换图片代理
    func _imageInputer_canceled() {
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
        
    }
    func _imageInputer_saved() {
        _imageChanged = true
        let _img:UIImage = _imageInputer!._captureBgImage()
        MainAction._changeAvatar(_img) { (__dict) -> Void in
           // self._updateProfielOnline()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._uploadAvatarAsBingo(_img)
            })
        }
        self._btn_profile!.setImage(self._imageInputer!._captureBgImage(), forState: UIControlState.Normal)
        self._imageInputer!.view.removeFromSuperview()
        self._imageInputer!.removeFromParentViewController()
        self._imageInputer = nil
    }
    
    func _uploadAvatarAsBingo(__image:UIImage){
        let _answer:UIImage = UIImage(named: "avatar_answer.png")!
        MainAction._postNewBingo(__image, __question: "我新换的头像，喜欢吗", __answer: _answer, __type: MainAction._Post_Type_Media ,__block: { (__dict) -> Void in
        })
    }
    
    
    func btnHander(sender:UIButton){
       
        switch sender{
        case _btn_back!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        case _btn_uploadProfile!:
            
            _showInputer()
            break
        case _btn_profile!:
            _showInputer()
            break
        case _btn_save!:
            _saveProfile()
            
            break
        default:
            break
            
        }
    }
    func _checkIfChanged()->Bool{
        return false
    }
    func _saveProfile(){
        let _dict:NSMutableDictionary = NSMutableDictionary()
        _dict.setValue(_text_name?.text, forKey: "nickname")
        
        
        
        _dict.setValue(_seg_sex?.selectedSegmentIndex, forKey: "sex")
        
        
        MainAction._uploadProfile(_dict) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                dispatch_async(dispatch_get_main_queue(), {
                    MainAction._getMyProfile { (__dict) -> Void in
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            if self._parentView != nil{
                                self._parentView?._refreshProfile()
                            }
                        })
                    }
                })
            }else{
                if (__dict.objectForKey("recode") as? Int) < 0{
                    dispatch_async(dispatch_get_main_queue(), {
                        self._showAlert("链接失败，请检查网络",__wait: 1.5)
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self._showAlert(__dict.objectForKey("recode") as! String,__wait: 1.5)
                })
            }
        }
        
    }
    //-----提示面板普通弹出
    
    func _showAlert(__text:String,__wait:Double){
        _showAlertThen(__text, __wait: __wait) { () -> Void in
            
        }
    }
    func _showAlertThen(__text:String,__wait:Double,__then:()->Void){
        if _failPanelV == nil{
            _failPanelV = UIView(frame: CGRect(x: 0, y: -_failPanelH-20, width: self.view.frame.width, height: _failPanelH+20))
            _failPanelV?.backgroundColor = UIColor(red: 198/255, green: 1/255, blue: 255/255, alpha: 0.5)
            _failLabel = UILabel(frame: CGRect(x: 5, y: 5+20, width: _failPanelV!.frame.width-10, height: _failPanelH))
            _failLabel?.textAlignment = NSTextAlignment.Center
            _failLabel?.textColor = UIColor.whiteColor()
            _failLabel?.font = UIFont.systemFontOfSize(12)
            _failPanelV?.addSubview(_failLabel!)
            self.view.addSubview(_failPanelV!)
        }
        _failLabel?.text = __text
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self._failPanelV!.transform = CGAffineTransformMakeTranslation(0, self._failPanelH)
            }) { (comp) -> Void in
                if __wait >= 0{
                    
                    self._hideAlert(__wait, __then: { () -> Void in
                        __then()
                    })
                }
                
        }
    }
    func _hideAlert(__wait:Double,__then:()->Void){
        UIView.animateWithDuration(0.2, delay: __wait, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self._failPanelV!.transform = CGAffineTransformMakeTranslation(0, 0)
            }) { (comp) -> Void in
                __then()
                
        }
    }
    
}
