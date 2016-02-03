//
//  ObjcUtils.h
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/15.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QiuniuInfo.h"


@interface ObjcUtils : NSObject

+(CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)location;
+ (double)transformlatitudeWithX:(double)x y:(double)y;
+ (double)transfromLongitudeWithX:(double)x y:(double)y;
+ (BOOL)outOfChina:(double)lat lon:(double)lon;

+ (NSString *)getDeviceInfo;
+ (NSString *)getSystemVersion;
+ (NSString *)getSoftVersion;

+(NSString*)generateNormalUploadTokenWithKey:(NSString*)fileKey;
+(NSString*)generateUniqueKeyWithUserId:(NSInteger)userId type:(NSString *)type;

@end
