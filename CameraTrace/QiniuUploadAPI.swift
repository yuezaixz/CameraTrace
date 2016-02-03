//
//  QiniuUploadAPI.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/2/3.
//  Copyright © 2016年 DNT. All rights reserved.
//

import Foundation
import Qiniu

final class QiniuAPI {
    static let sharedInstance = QiniuAPI()
    let upManager = QNUploadManager()
    
    func upload(imageData:NSData,completion: String -> Void){
        let key = ObjcUtils.generateUniqueKeyWithUserId(107, type: "camera_trace")
        let token = ObjcUtils.generateNormalUploadTokenWithKey(key)
        
        upManager.putData(
            imageData,
            key: key,
            token: token,
            complete: {
                (info, key, UIResponder) -> Void in
                completion(key)
            },
            option: QNUploadOption.defaultOptions()
        )
    }
    
}