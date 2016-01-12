//
//  Trace.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import UIKit

class Trace: NSObject {
    static var currentTrace:Trace!{
        willSet{
            //TODO SAVE
//            newValue
        }
    }
    var traceId = 0
    var userId = 0
    var createTime = NSDate()
    var lastTime = NSDate()
    var photoCount = 0
    var pointData:NSData?
    
}
