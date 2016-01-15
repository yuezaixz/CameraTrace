//
//  ObjcUtils.m
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/15.
//  Copyright © 2016年 DNT. All rights reserved.
//

#define PI 3.14159265358979324
#define a 6378245.0
#define ee 0.00669342162296594323

#import "ObjcUtils.h"

@implementation ObjcUtils

+(CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)location{
    if([self outOfChina:location.latitude lon:location.longitude]){
        return location;
    }
    
    double wgLat=location.latitude;
    double wgLon=location.longitude;
    
    double dLat = [self transformlatitudeWithX:(wgLon - 105.0) y:(wgLat - 35.0)];
    double dLon = [self transfromLongitudeWithX:(wgLon - 105.0) y:(wgLat - 35.0)];
    double radLat = wgLat / 180.0 * PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * PI);
    
    return CLLocationCoordinate2DMake((wgLat + dLat), (wgLon + dLon));
}

+ (double)transformlatitudeWithX:(double)x y:(double)y{
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * PI) + 40.0 * sin(y / 3.0 * PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * PI) + 320 * sin(y * PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transfromLongitudeWithX:(double)x y:(double)y{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * PI) + 40.0 * sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * PI) + 300.0 * sin(x / 30.0 * PI)) * 2.0 / 3.0;
    return ret;
}

+ (BOOL)outOfChina:(double)lat lon:(double)lon{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

@end
