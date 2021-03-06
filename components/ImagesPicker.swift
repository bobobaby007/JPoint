//
//  Manage_imagePicker.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

//----弹出选择相册

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation


protocol ImagesPickerDeletegate:NSObjectProtocol{
    func imagesPickerDidSelected(images:NSArray)
    func imagesPickerCanceled()
}


// Group Model
class DKAssetGroup : NSObject {
    var groupName: String!
    var thumbnail: UIImage!
    var group: ALAssetsGroup!
}
// Asset Model
class DKAsset: NSObject {
    var _seleceted:Bool=false
//    //var thumbnailImage: UIImage?
//    lazy var fullScreenImage: UIImage? = {
//        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
//        }()
//    lazy var fullResolutionImage: UIImage? = {
//        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
//        }()
//    var url: String?
//    
//    private var originalAsset: ALAsset!
//    
//    // Compare two assets
//    override func isEqual(object: AnyObject?) -> Bool {
//        let other = object as! DKAsset!
//        return self.url!.isEqual(other.url!)
//    }
}



class ImagesPicker:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,PicsShowCellDelegate{
        
    var _btn_cancel:UIButton?
    var _btn_ok:UIButton?
    var _collectionView:UICollectionView?
    var _btn_title:UIButton?
    var _img_arrow:UIImageView?
    
    var _setuped:Bool = false
    
    var _groupPicker:groupPickerController?
    var _cameraPicker: UIImagePickerController!
    weak var _delegate:ImagesPickerDeletegate?

    lazy private var library: ALAssetsLibrary = {
        return ALAssetsLibrary()
    }()

    lazy private var _groups: NSMutableArray = {
        return NSMutableArray()
    }()


    var _images:NSMutableArray?=[]
    var _imageItems:NSMutableArray?=[]
    var _firstLoaded:Bool=true
    var _topBar:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor.whiteColor()
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: Config._barH ))
        _topBar?.backgroundColor=Config._color_black_bar
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_title=UIButton(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _btn_title?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        _btn_ok=UIButton(frame:CGRect(x: self.view.frame.width - 50, y: 12, width: 50, height: 60))
        _btn_ok?.setTitle("确定", forState: UIControlState.Normal)
        _btn_ok?.titleLabel?.font = UIFont.systemFontOfSize(14)
        _btn_ok?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_ok?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btn_ok?.hidden = true
        
        _img_arrow = UIImageView(image: UIImage(named: "arrow"))
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_title!)
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_ok!)
        //_topBar?.addSubview(_img_arrow!)
        
        
        
        
        _btn_title?.tintColor = Config._color_white_title
        _btn_title?.titleLabel?.font = Config._font_topbarTitle
        
        let layout = CustomLayout()
        _collectionView = UICollectionView(frame: CGRect(x: 0, y: Config._barH, width: self.view.frame.width, height: self.view.frame.height-Config._barH), collectionViewLayout: layout)
        _collectionView!.collectionViewLayout=layout
        _collectionView!.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        _collectionView?.delegate = self
        _collectionView?.dataSource = self
        
        self.view.addSubview(_collectionView!)
        
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {(group: ALAssetsGroup! , stop: UnsafeMutablePointer<ObjCBool>) in
            if group != nil {
                if group.numberOfAssets() != 0 {
                    let groupName = group.valueForProperty(ALAssetsGroupPropertyName) as! String
                    let assetGroup = DKAssetGroup()
                    assetGroup.groupName = groupName
                    assetGroup.thumbnail = UIImage(CGImage: group.posterImage().takeUnretainedValue())
                    assetGroup.group = group
                    self._groups.insertObject(assetGroup, atIndex: 0)
                    if self._firstLoaded{
                        self._firstLoaded=false
                    }
                    //  self._groups.addObject(assetGroup)
                }
            } else {
                self._loadImagesAt(0)
                
                //self._collectionView.reloadData()
            }
            }, failureBlock: {(error: NSError!) in
                
                //---没有相册
        })
        
        
        _setuped=true
    }
    
    func _loadImagesAt(_groupIndex:Int)->Void{
        let _group:DKAssetGroup=self._groups.objectAtIndex(_groupIndex) as! DKAssetGroup
        self._images=[]
        self._imageItems=[]
        self._btn_title?.setTitle(_group.groupName, forState: UIControlState.Normal)
        
        //---三角位置
        var size = CGRect()
        let size2 = CGSize()
        size = (_group.groupName+"").boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesFontLeading, attributes: nil, context: nil);
        _img_arrow?.frame=CGRect(x: self.view.bounds.width/2+size.width,y: 32,width: 10,height: 10)
        
        _group.group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            
            
            if result != nil {
                let asset = DKAsset()
                //asset.thumbnailImage = UIImage(CGImage:result.thumbnail().takeUnretainedValue())
                let _nsurl:NSURL = (result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL)!
                let _url:NSString=_nsurl.absoluteString
                let _dict:NSDictionary = NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])
                //asset.originalAsset = result
                self._images!.insertObject(_dict, atIndex: 0)
                self._imageItems?.insertObject(asset, atIndex: 0)
                
//                self._collectionView!.reloadData()
            } else {
                self._collectionView!.reloadData()
               // print("图片们:",self._images)
                self._collectionView!.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
            }
        }

    }
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _images!.count;
        }
        func collectionView(collectionView: UICollectionView,
            cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                
                    let identify:String = "PicsShowCell"
                    let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                        identify, forIndexPath: indexPath) as! PicsShowCell
                    cell._index=indexPath.item
                    let _pic:NSDictionary=_images?.objectAtIndex(indexPath.item) as! NSDictionary
                    let _asset:DKAsset=_imageItems?.objectAtIndex(indexPath.item) as! DKAsset
                    cell._selected = _asset._seleceted
//                    
//                    println(_pic.objectForKey("seleceted"))
//                    if (_pic.objectForKey("seleceted") != nil) {
//                        println(_pic)
//                        let _s:Int=_pic.objectForKey("selected") as! Int
//                        if _s == 1{
//                            cell._selected=true
//                        }
//                    }else{
//                        cell._selected=false
//                    }
                
                    
                    cell._setPic(_pic)
                    cell._delegate=self
                    cell._hasTag=true
                    return cell
                
                
        }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
        let pic:PicsShowCell = collectionView.cellForItemAtIndexPath(indexPath) as! PicsShowCell
        pic._selected = !pic._selected
        
        let _pic:NSMutableDictionary=NSMutableDictionary(dictionary: _images?.objectAtIndex(pic._index!) as! NSDictionary)
        _pic.setObject(pic._selected, forKey: "selected")
        
        
        
        _images![pic._index!]=_pic
        
        let _asset:DKAsset=_imageItems?.objectAtIndex(pic._index!) as! DKAsset
        
        _asset._seleceted=pic._selected
        
        _testForSaveBtn()
        
        
        /*
            //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
            
            if indexPath.item==0{
                
                _cameraPicker =  UIImagePickerController()
                _cameraPicker.delegate = self
                _cameraPicker.sourceType = .Camera
                //self.view.window!.rootViewController!.presentViewController(_cameraPicker, animated: true, completion: nil)
                
                presentViewController(_cameraPicker, animated: true, completion: nil)
            }else{
//                let _controller:Manage_pic = Manage_pic()
//                _controller._showIndexAtPics(indexPath.item-1, __array: _images!)
//                self.navigationController?.pushViewController(_controller, animated: true)
            }
        */
            
        }
    
    
    //-----图片单独选中☑️或取消
    func PicDidSelected(pic: PicsShowCell) {
        
        //var _ps:NSMutableArray=NSMutableArray(array: _images!)
        
        let _pic:NSMutableDictionary=NSMutableDictionary(dictionary: _images?.objectAtIndex(pic._index!) as! NSDictionary)
        _pic.setObject(pic._selected, forKey: "selected")
        
        _images![pic._index!]=_pic
        
        let _asset:DKAsset=_imageItems?.objectAtIndex(pic._index!) as! DKAsset
        
        _asset._seleceted=pic._selected
        
        _testForSaveBtn()
       
    }
    
    
    //-------弹出相册列表代理方法
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _groups.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.size.height/6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:AlbumListCell=tableView.dequeueReusableCellWithIdentifier("AlbumListCell", forIndexPath: indexPath) as! AlbumListCell
        cell.setUp(CGSize(width: self.view.frame.width, height: 91))
        let _group:DKAssetGroup=_groups[indexPath.row] as! DKAssetGroup
        cell._image?._setImageByImage(_group.thumbnail)
        cell.setTitle(_group.groupName)
        cell.setDescription(String(_group.group.numberOfAssets()))
        //cell.imageView?.image=UIImage(named: _albumArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(false, completion: nil)
        self._loadImagesAt(indexPath.row)
    }
    
    
    //----相机代理方法
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        _cameraPicker.dismissViewControllerAnimated(true, completion: nil)
       
        
        //_loadImagesAt(0)
        
        //var _alassetsl:ALAssetsLibrary = ALAssetsLibrary()
        //println(info)
        
        //let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        
        
        
        //_alassetsl.writeImageToSavedPhotosAlbum(image.CGImage, orientation: image.imageOrientation, completionBlock: cameraSaveOk)
        
        
        //_alassetsl.writeImageToSavedPhotosAlbum(image.CGImage,orientation: image.imageOrientation,completionBlock:{ (path:NSURL!, error:NSError!) -> Void in    println("\(path)")  })
        
       // _alassetsl.writeImageToSavedPhotosAlbum(image.CGImage, orientation: image.imageOrientation, completionBlock: Selector("cameraSaveOk:"))
        
       
        
        UIImageWriteToSavedPhotosAlbum((info[UIImagePickerControllerOriginalImage] as? UIImage)!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        //_cameraPicker.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func cameraSaveOk(URL:NSURL, Error:NSError)->Void{
        let _url:NSString=URL.absoluteString
        let _dict:NSDictionary = NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])
        //asset.originalAsset = result
        self._images!.insertObject(_dict, atIndex: 0)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            //println(contextInfo)
            _loadImagesAt(0)
           // println(self._images)
            self.navigationController?.popViewControllerAnimated(false)
            _delegate?.imagesPickerDidSelected([self._images!.objectAtIndex(0)])
//            let ac = UIAlertController(title: "保存成功", message: "", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
            
            
        } else {
            let ac = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_cancel!:
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                self._delegate!.imagesPickerCanceled()
            })
            //self.navigationController?.popViewControllerAnimated(true)
        case _btn_title!:
            _groupPicker=groupPickerController()
            _groupPicker!._setDelegateAndSource(self, _s: self)
            //self.navigationController?.presentViewController(_groupPicker!, animated: true, completion: nil)
            self.presentViewController(_groupPicker!, animated: true, completion: nil)
        case _btn_ok!:
            let _imgs:NSMutableArray=NSMutableArray()
            let _c:Int = _images!.count
            for var i=0; i<_c;++i{
                let _pic:NSDictionary = _images!.objectAtIndex(i) as! NSDictionary
                if (_pic.objectForKey("selected") != nil) {
                  //  println(_ak._seleceted)
                    let _s:Int=_pic.objectForKey("selected") as! Int
                    
                    if _s == 1{
                        let _img:NSDictionary=NSDictionary(objects: ["alasset",_pic.objectForKey("url")!], forKeys: ["type","url"])
                        _imgs.addObject(_img)
                    }
                    
                    
                }else{
                    
                }
                
            }
            self._delegate?.imagesPickerDidSelected(_imgs)
            
            
//            self.dismissViewControllerAnimated(false, completion: { () -> Void in
//                
//            })
            
            
            
        default:
            print("")
        }
    }
    //---判断是否已有选择的图片
    func _hasSelectedImages()->Bool{
        let _c:Int = _images!.count
        for var i=0; i<_c;++i{
            let _pic:NSDictionary = _images!.objectAtIndex(i) as! NSDictionary
            if (_pic.objectForKey("selected") != nil) {
                //  println(_ak._seleceted)
                let _s:Int=_pic.objectForKey("selected") as! Int
                if _s == 1{
                    return true
                }
            }else{
                
            }
            
        }
        return false
    }
    //
    func _testForSaveBtn(){
        if _hasSelectedImages(){
            _btn_ok?.hidden = false
        }else{
            _btn_ok?.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
}


class groupPickerController: UIViewController {
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    weak var _delegate:UITableViewDelegate?
    var _source:UITableViewDataSource?
    
    
    func _setDelegateAndSource(_d:UITableViewDelegate,_s:UITableViewDataSource){
        _tableView=UITableView()
        _tableView?.delegate=_d
        _tableView?.dataSource=_s
        
    }
    
    override func viewDidLoad() {
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        
        _topBar?.backgroundColor=Config._color_black_bar
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 10, width: 40, height: 62))
        _btn_cancel?.titleLabel?.font=Config._font_topButton
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _tableView?.frame = CGRect(x: 0, y: 62, width: self.view.frame.width, height: self.view.frame.height-62)
        _tableView?.registerClass(AlbumListCell.self, forCellReuseIdentifier: "AlbumListCell")
        
        _tableView?.tableFooterView=UIView(frame: CGRect(x: 0, y: 0, width: _tableView!.frame.width, height:10))
        
        self.view.addSubview(_tableView!)
        
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
            }
    
    func clickAction(sender:UIButton){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}








