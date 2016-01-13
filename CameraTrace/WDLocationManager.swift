//
//  WDLocationManager.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class WDLocationManager:NSObject,CLLocationManagerDelegate {
    static let locationManager:WDLocationManager = WDLocationManager()
    var locationManager:CLLocationManager
    var lastLocation:CLLocation?
    
    
    override private init() {
        locationManager = CLLocationManager()
        
        super.init()
        locationManager.delegate = self
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 50.0;
        locationManager.pausesLocationUpdatesAutomatically = false;
        locationManager.activityType = CLActivityType.Fitness
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    class func getWDLocationManager() ->WDLocationManager! {
        return locationManager
    }
    
    class func startLocationUpdate() {
        WDLocationManager.getWDLocationManager().startLocationUpdate()
    }
    
    class func stopLocationUpdate() {
        WDLocationManager.getWDLocationManager().stopLocationUpdate()
    }
    
    func startLocationUpdate(){
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == CLAuthorizationStatus.Denied {
            UIAlertView.init(title: "定位权限被拒绝", message: "定位权限被拒绝，请在设置中开启", delegate: nil, cancelButtonTitle: nil).show()
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate(){
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {
            return
        }
        lastLocation = location
        Point.lastPoint = Point(traceId: Trace.currentTrace.traceId ,latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status == CLAuthorizationStatus.Denied {
            UIAlertView.init(title: "定位权限被拒绝", message: "定位权限被拒绝，请在设置中开启", delegate: nil, cancelButtonTitle: nil).show()
        }
    }
    
}