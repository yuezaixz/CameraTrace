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
            if let dbPoint = newValue {
                var pointId = 1
                if let newPointId = WDDBService.executeQuerySql("select max(point_id) as point_id from point", args: [NSObject : AnyObject]())?["point_id"] {
                    if !(newPointId is NSNull){
                        pointId += newPointId as! Int
                    }
                }
                dbPoint.pointId = pointId
                WDDBService.executeUpdateSql("insert into  point(create_time,trace_id,latitude,longitude, china_latitude,china_longitude) values(:create_time,:trace_id,:latitude,:longitude, :china_latitude,:china_longitude)", args: ["create_time":dbPoint.createTime,"trace_id":dbPoint.traceId,"latitude":dbPoint.latitude,"longitude":dbPoint.longitude, "china_latitude":(dbPoint.china_latitude ?? 0),"china_longitude":(dbPoint.china_longitude ?? 0)])
            }
            
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
