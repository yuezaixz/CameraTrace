//
//  ObjcUtils.h
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/15.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// 七牛云存储
#define QINIU_BUCKET @"runmove"
#define QINIU_DBFILE_BUCKET @"runmove/dbfile"
#define QINIU_AK @"p1M5dhnOpB0rDvbV6AGGBtfuXIBy5-40_k9h7wpj"
#define QINIU_SK @"l9TD7YTZp-sNE4nNY3vSEnFpvrGrOuJM20k54Mk6"
#define QINIU_UPLOAD_TOKEN @"p1M5dhnOpB0rDvbV6AGGBtfuXIBy5-40_k9h7wpj:vNsSQgP-K8eTwHHym-LN__7_aI8=:eyJzY29wZSI6InJ1bm1vdmUiLCJyZXR1cm5Cb2R5Ijoia2V5PSQoa2V5KSZmb3JtYXQ9JChpbWFnZUluZm8uZm9ybWF0KSIsImRlYWRsaW5lIjoxNDEyNTk3NDgzLCJyZXR1cm5VcmwiOiJodHRwOi8vMTI3LjAuMC4xOjUwMDAvc2VydmljZXMvb3RoZXIvcWluaXV0b2tlbiJ9"

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
