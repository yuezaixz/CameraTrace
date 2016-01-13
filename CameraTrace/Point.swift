//
//  Point.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import UIKit

class Point: NSObject {
    static var lastPoint:Point?{
        willSet{
            //TODO SAVE
//            if var point = newValue {
//                
//            }
        }
    }
    var pointId:Int = 0
    var latitude:Double
    var longitude:Double
    var traceId:Int
    var china_latitude:Double?
    var china_longitude:Double?
    var createTime = NSDate()
    init(traceId:Int,latitude:Double,longitude:Double) {
        self.traceId = traceId
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func save(){
        
    }

}
