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
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#import "Base64.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString* QN_AccessKey;
static NSString* QN_SecretKey;
static NSString* QN_Bucket;
static NSString* QN_VideoBucket;

@implementation ObjcUtils

+(void)initialize{
    if (!QN_AccessKey || !QN_SecretKey || !QN_Bucket) {
        QN_AccessKey=QINIU_AK;
        QN_SecretKey=QINIU_SK;
        QN_Bucket=QINIU_BUCKET;
        QN_VideoBucket=nil;
    }
}

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

// 获取设备型号
+ (NSString *)getDeviceInfo {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    else if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
    else if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6+";
    //iPod
    else if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    else if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    else if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    else if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    else if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    //iPad
    else if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    else if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
    else if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
    else if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
    else if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    else if ([platform isEqualToString:@"iPad4,1"]) return @"iPad air";
    else if ([platform isEqualToString:@"iPad4,2"]) return @"iPad air";
    else if ([platform isEqualToString:@"iPad4,3"]) return @"iPad air";
    else if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
    else if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
    else if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    else if ([platform isEqualToString:@"iPad5,3"]) return @"iPad air 2";
    else if ([platform isEqualToString:@"iPad5,4"]) return @"iPad air 2";
    else if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    else return platform;
}

// 系统版本
+ (NSString *)getSystemVersion {
    UIDevice *device = [UIDevice currentDevice];
    return device.systemVersion;
}

// 软件版本
+ (NSString *)getSoftVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_bundle_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@(%@)",app_Version,app_bundle_version];
}

#pragma mark - qiniu

+(NSString*)generateNormalUploadTokenWithKey:(NSString*)fileKey{
    [self initialize];
    
    NSString *putPolicy=[NSString stringWithFormat:@"{\"scope\":\"%@:%@\",\"deadline\":%d,\"returnBody\":\"{\\\"size\\\":$(fsize),\\\"w\\\":$(imageInfo.width),\\\"h\\\":$(imageInfo.height),\\\"key\\\":$(key)}\"}",QINIU_BUCKET,fileKey,(int)([[NSDate date] timeIntervalSince1970]+3600)];
    
    return [self generateUploadTokenWithPutPolicy:putPolicy];
}

+(NSString*)generateUniqueKeyWithUserId:(NSInteger)userId type:(NSString *)type{
    ;
    return [NSString stringWithFormat:@"%d-%@-%f-%d", (int)userId,[type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[NSDate date] timeIntervalSince1970],abs(arc4random())];
}

/**
  *根据putpolicy生成token
  */
+(NSString*)generateUploadTokenWithPutPolicy:(NSString *)putPolicy{
    
    NSString *putPolicyBase64=[[putPolicy dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    NSData *putPolicyBase64Data=[putPolicyBase64 dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData *secretData = [QN_SecretKey dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [putPolicyBase64Data bytes], [putPolicyBase64Data length], result);
    
    NSString *signBase64=[[NSData dataWithBytes:result length:sizeof(result)] base64EncodedString];
    
    return [NSString stringWithFormat:@"%@:%@:%@",QN_AccessKey,[self getUrlSafeStringFromBase64String:signBase64],[self getUrlSafeStringFromBase64String:putPolicyBase64]];
}

+(NSString*)getUrlSafeStringFromBase64String:(NSString*)base64{
    NSMutableString *str=[NSMutableString stringWithString:base64];
    [str replaceOccurrencesOfString:@"+" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, base64.length)];
    [str replaceOccurrencesOfString:@"/" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, base64.length)];
    
    return str;
}

@end
