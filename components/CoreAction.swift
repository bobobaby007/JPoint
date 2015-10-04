//
//  CoreAction.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/1.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
class CoreAction {
    
    static func _timeStr(__timestamp:String)->String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    
        return timestamp
    }
    
}
