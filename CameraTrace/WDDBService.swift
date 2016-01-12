//
//  WDDBService.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import FMDB



class WDDBService: NSObject {
    
    static let wddbService:WDDBService = WDDBService()
    
    override private init() {
        super.init()
        let db = getDB()
        var traceSql = "create table if not exists trace (trace_id integer NOT NULL PRIMARY KEY,"
        traceSql.appendContentsOf("create_time varchar(30),last_camera_time varchar(30) ,point_data blob,photo_count integer,user_id integer)")
        
        var pointSql = "create table if not exists point (point_id integer NOT NULL PRIMARY KEY,"
        pointSql.appendContentsOf("create_time varchar(30),trace_id integer,latitude double,longitude double, china_latitude double,china_longitude double)")
        
        var photoSql = "create table if not exists photo (photo_id integer NOT NULL PRIMARY KEY,"
        photoSql.appendContentsOf("create_time varchar(30),trace_id integer,point_id integer,user_id integer)")
        
        if db.open() {
            if !db.executeStatements(traceSql) {
                print("Trace sql execute error: \(db.lastErrorMessage())")
            }
            if !db.executeStatements(pointSql) {
                print("Point sql execute error: \(db.lastErrorMessage())")
            }
            if !db.executeStatements(photoSql) {
                print("photo sql execute error: \(db.lastErrorMessage())")
            }
            
            db.close()
        } else {
            print("DB open error: \(db.lastErrorMessage())")
        }

        
    }
    
    class func getWDDBService() ->WDDBService! {
        return wddbService
    }
    
    func getDB() -> FMDatabase{
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documents = paths[0]
        documents.appendContentsOf("/cTrace.db")
        let db = FMDatabase.init(path: documents)
        return db
    }
    
}
