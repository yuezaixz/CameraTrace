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
    
    var photos:[[String:AnyObject]]?
    
    init(traceId:Int,latitude:Double,longitude:Double) {
        self.traceId = traceId
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func save(){
        
    }
    
    class func getByTraceId(traceId:Int) -> [AnyObject]{
        let points = WDDBService.executeQuerySql("select point_id,latitude,longitude,china_latitude,china_longitude,create_time from point where trace_id = :trace_id ", args: ["trace_id":traceId]) { (resultDict) -> AnyObject? in
            guard let latitude = resultDict["latitude"] as? Double, let longitude = resultDict["longitude"] as? Double else {
                return nil
            }
            let point = Point.init(traceId: traceId, latitude: latitude, longitude: longitude)
            
            if let chinaLatitude = resultDict["china_latitude"] as? Double,let chinaLongitude = resultDict["china_longitude"] as? Double {
                point.china_latitude = chinaLatitude;
                point.china_longitude = chinaLongitude;
            } else {
                point.china_latitude = latitude;
                point.china_longitude = longitude;
            }
            if let createTime = resultDict["create_time"] as? Double {
                point.createTime = NSDate.init(timeIntervalSince1970: createTime)
            }
            
            
            if let pointId = resultDict["point_id"] as? Int {
                var photos:[[String:AnyObject]] = []
                for photoObject in Photo.getByPointId(pointId) {
                    if let photo = photoObject as? Photo {
                        photos.append(photo.jsonDict())
                    }
                }
                point.photos = photos
            }
            
            return point
        }
        return points
    }
    
    
    func jsonDict() -> [String:AnyObject] {
        var jsonDict:[String:AnyObject] = [:]
        jsonDict["lat"] = self.latitude
        jsonDict["lon"] = self.longitude
        jsonDict["c_lat"] = self.china_latitude
        jsonDict["c_lon"] = self.china_longitude
        jsonDict["time"] = self.createTime.timeIntervalSince1970
        jsonDict["photos"] = self.photos
        
        return jsonDict
    }

}
