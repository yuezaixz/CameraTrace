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
}