//
//  Photo.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/13.
//  Copyright © 2016年 DNT. All rights reserved.
//

import Foundation

class Photo:NSObject {
    var photoId:Int?
    var image:NSData
    var createTime = NSDate()
    var traceId = Trace.currentTrace.traceId
    var pointId = Point.lastPoint!.pointId
    var userId = 0
    
    init(image:NSData){
        self.image = image
        super.init()
    }
    
    func save(){
        WDDBService.executeUpdateSql("insert into  photo (image,create_time,trace_id,point_id, user_id) values(:image,:create_time,:trace_id,:point_id, :user_id)", args: ["image":image,"create_time":createTime,"trace_id":traceId,"point_id":pointId, "user_id":userId])
    }
    
    class func getByPointId(pointId:Int) -> [AnyObject]{
        let photos = WDDBService.executeQuerySql("select image,create_time from photo where point_id = :point_id ", args: ["point_id":pointId]) { (resultDict) -> AnyObject? in
            guard let image = resultDict["image"] else {
                return nil
            }
            
            guard let imageData = image as? NSData else {
                return nil
            }
            QiniuAPI.sharedInstance.post(imageData, completion: { (result) -> () in
                if let key = result {
                    print(key)
                }
            })
            let photo = Photo.init(image: imageData)
            
            if let createTime = resultDict["create_time"] as? Double {
                photo.createTime = NSDate.init(timeIntervalSince1970: createTime)
            }
            
            return photo
        }
        return photos
    }
    
    
    
    func jsonDict() -> [String:AnyObject] {
        var jsonDict:[String:AnyObject] = [:]
        jsonDict["time"] = self.createTime.timeIntervalSince1970
        //TODO url
        
        return jsonDict
    }
}