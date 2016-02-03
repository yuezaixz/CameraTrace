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
    
    private let token = ""
    
    private let key = ""
    
    func upload(imageData:NSData,completion: String -> Void){
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