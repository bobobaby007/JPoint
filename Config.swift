//
//  Config.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/7.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation

class Config:AnyObject {
    
    static let _barH:CGFloat = 64
    static let _gap:CGFloat = 15
    static let _gap_2:CGFloat = 11
    static let _statusBarH:CGFloat = 20
    
    
    
    static let _color_sex_female:UIColor = UIColor(red: 254/255, green: 187/255, blue: 255/255, alpha: 1)
    static let _color_sex_male:UIColor = UIColor(red: 135/255, green: 219/255, blue: 255/255, alpha: 1)
    
    static let _color_bg_gray:UIColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)//----背景灰色
    
    ///
    
    static let _color_pink:UIColor = UIColor(red: 198/255, green: 87/255, blue: 255/255, alpha: 1)
    static let _color_white_title:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)//----标题白色
    
    static let _color_yellow:UIColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)//----黄色
    
    
    static let _color_yellow_bar:UIColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)//----下导航条黄色
    static let _color_black_bar:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.98)//----黑色导航条
    
    static let _color_black_bottom:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)//----底部按钮背景黑
    static let _color_black_title:UIColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)//----黑色标题
    static let _color_gray_subTitle:UIColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)//----灰色副标题标题
    static let _color_gray_time:UIColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)//----时间灰色
    static let _color_gray_description:UIColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)//----描述性文字灰色
    
    
    
    
    
    //-----Font Names = [["PingFangSC-Ultralight", "PingFangSC-Regular", "PingFangSC-Semibold", "PingFangSC-Thin", "PingFangSC-Light", "PingFangSC-Medium"]]
    
    
    static let _font_cell_title:UIFont = UIFont.systemFontOfSize(17)// UIFont(name: "PingFangSC-Regular", size: 17)! //UIFont.systemFontOfSize(17, weight: 0)//---首页相册条标题字体
    static let _font_cell_title_normal:UIFont = UIFont.systemFontOfSize(16)//UIFont(name: "PingFangSC-Regular", size: 16)!//UIFont.systemFontOfSize(16, weight: 0)//---一般的cell标题字体
    
    
    static let _font_cell_subTitle:UIFont = UIFont.systemFontOfSize(14)//UIFont(name: "PingFangSC-Regular", size: 14)!// UIFont.systemFontOfSize(14, weight: 0)//---首页相册条副标题字体
    static let _font_cell_time:UIFont = UIFont.systemFontOfSize(12)//UIFont(name: "PingFangSC-Regular", size: 12)!// UIFont.systemFontOfSize(12, weight: 0)//---首页相册条时间字体
    static let _font_topbarTitle:UIFont = UIFont.systemFontOfSize(17)//UIFont(name: "PingFangSC-Medium", size: 17)!// UIFont.systemFontOfSize(17, weight: 1)//----标题字体
    static let _font_topbarTitle_at_one_pic:UIFont = UIFont.systemFontOfSize(15)// UIFont(name: "PingFangSC-Medium", size: 15)!//----图片详情标题字体
    static let _font_topButton:UIFont = UIFont.systemFontOfSize(16)//UIFont(name: "PingFangSC-Medium", size: 16)!//UIFont.systemFontOfSize(16, weight: 1)//----导航条按钮标题
    static let _font_input:UIFont = UIFont.systemFontOfSize(15)//UIFont(name: "PingFangSC-Regular", size: 15)!//UIFont.systemFontOfSize(15, weight: 0)//----输入字体
    
    static let _font_description_at_bottom:UIFont = UIFont.systemFontOfSize(14)//UIFont(name: "PingFangSC-Light", size: 14)!//----单张图片底部描述字体
    
    //---------------------社交
    
    static let _color_social_gray:UIColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)//----社交页面中灰色
    static let _color_social_blue:UIColor = UIColor(red: 44/255, green: 60/255, blue: 120/255, alpha: 1)//----社交页面中蓝色

     static let _color_social_gray_light:UIColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)//----社交页面中浅灰
    
    static let _color_social_albumTitle_over:UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)//----社交页面
    
    
    static let _font_social_button:UIFont = UIFont.systemFontOfSize(12)//UIFont(name: "PingFangSC-Regular", size: 12)!//社交页面按钮文字
    static let _font_social_cell_name:UIFont = UIFont.systemFontOfSize(14)//UIFont(name: "PingFangSC-Regular", size: 14)!//社交页面列表用户名
    
    static let _font_social_button_2:UIFont = UIFont.systemFontOfSize(15)//UIFont(name: "PingFangSC-Regular", size: 15)!//社交页面图册、关注、被关注按钮文字
    static let _font_social_album_title:UIFont = UIFont.systemFontOfSize(17)//UIFont(name: "PingFangSC-Regular", size: 17)!//社交页面图册标题
    static let _font_social_album_description:UIFont = UIFont.systemFontOfSize(15)//UIFont(name: "PingFangSC-Regular", size: 15)!//社交页面图册描述
    static let _font_social_sex_n_city:UIFont = UIFont.systemFontOfSize(10.5)//UIFont(name: "PingFangSC-Regular", size: 10.5)!//社交页性别和城市
    static let _font_social_time:UIFont = UIFont.systemFontOfSize(10.5)//UIFont(name: "PingFangSC-Regular", size: 10.5)!//社交页时间文字
    static let _font_social_sign:UIFont = UIFont.systemFontOfSize(14)//UIFont(name: "PingFangSC-Regular", size: 14)!//社交页签名字体
    static let _font_social_likeNum:UIFont = UIFont.systemFontOfSize(13)//UIFont(name: "PingFangSC-Regular", size: 13)!//社交点赞数
    
    
    
    
    
    //------登陆
    
    
    
    static let _font_loginButton:UIFont = UIFont.systemFontOfSize(24)//UIFont(name: "PingFangSC-Regular", size: 24)!//----登陆按钮字体
    
}
