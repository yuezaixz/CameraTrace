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
            var traceId = 1
            if let newTraceId = WDDBService.executeQuerySql("select max(trace_id) as trace_id from trace", args: [NSObject : AnyObject]())?["trace_id"] {
                if !(newTraceId is NSNull){
                    traceId += newTraceId as! Int
                }
            }
            newValue.traceId = traceId
            
            WDDBService.executeUpdateSql("insert into  trace(trace_id,create_time,last_camera_time,photo_count,user_id) values(:trace_id,:create_time,:last_camera_time,:photo_count,:user_id)", args: ["trace_id":newValue.traceId,"create_time":newValue.createTime,"last_camera_time":newValue.lastTime,"photo_count":newValue.photoCount,"user_id":newValue.userId])
        }
    }
    var traceId = 0
    var userId = 0
    var createTime = NSDate()
    var lastTime = NSDate()
    var photoCount = 0
    var pointArray:[[String:AnyObject]]?
    
    
    class func getAllTrace() -> [AnyObject]{
        let traces = WDDBService.executeQuerySql("select trace_id,create_time from trace ", args: nil) { (resultDict) -> AnyObject? in
            guard let traceId = resultDict["trace_id"] as? Int else {
                return nil
            }
            
            let trace = Trace.init()
            trace.traceId = traceId
            
            if let createTime = resultDict["create_time"] as? Double {
                trace.createTime = NSDate.init(timeIntervalSince1970: createTime)
            }
            
            var points:[[String:AnyObject]] = []
            
            for pointObject in Point.getByTraceId(traceId) {
                if let point = pointObject as? Point {
                    points.append(point.jsonDict())
                }
            }
            trace.pointArray = points
            
            return trace
        }
        return traces
    }
    
    func jsonDict() -> [String:AnyObject]? {
        var jsonDict:[String:AnyObject] = ["dev":ObjcUtils.getDeviceInfo(),"sys_v":"iOS\(ObjcUtils.getSystemVersion())","app_v":ObjcUtils.getSoftVersion()]
        jsonDict["time"] = self.createTime.timeIntervalSince1970
        jsonDict["points"] = self.pointArray
        
        return jsonDict
    }
    
}
