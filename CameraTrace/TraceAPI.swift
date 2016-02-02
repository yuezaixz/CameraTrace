//
//  TraceAPI.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/2/1.
//  Copyright © 2016年 DNT. All rights reserved.
//

import Foundation
import Alamofire

private typealias JSONObject = [String : AnyObject]

final class WDAPI {
    static let sharedInstance = WDAPI()
    
    // API base URL.
    private let apiBaseURL = "https://xxxxx.xxxx.com/service/"
    
    //GET
    private func get(endpoint: String, completion: AnyObject? -> Void) {
        request(endpoint, method: "GET", encoding: .JSON, parameters: nil, completion: completion)
    }
    
    //POST
    private func post(endpoint: String, parameters: [String: AnyObject]?, completion: AnyObject? -> Void) {
        request(endpoint, method: "POST", encoding: .JSON, parameters: parameters, completion: completion)
    }
    
    //通过Alamofire来发送网络请求
    private func request(endpoint: String, method: String, encoding: Alamofire.ParameterEncoding, parameters: [String: AnyObject]?, completion: AnyObject? -> Void) {
        let URL = NSURL(string: apiBaseURL + endpoint)!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.HTTPMethod = method
        
        let request = encoding.encode(URLRequest, parameters: parameters).0
        
        print("Starting \(method) \(URL) (\(parameters ?? [:]))")
        Alamofire.request(request).responseJSON { _, response, result in
            print("Finished \(method) \(URL): \(response?.statusCode)")
            switch result {
            case .Success(let JSON):
                completion(JSON)
            case .Failure(let data, let error):
                print("Request failed with error: \(error)")
                if let data = data {
                    print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                }
                
                completion(nil)
            }
        }
    }
}

final class AuthenticatedAPI {
    func signin(userName: String, passwd: String, completion: Bool -> ()) {
        let parameters: JSONObject = ["name": userName,"password":passwd]
        
        WDAPI.sharedInstance.post("sec/login", parameters: parameters) { response in
            let success = response != nil
            
            completion(success)
        }
    }
}

final class TraceAPI {
    func post(trace: Trace, points: [Point], photos: [Photo], completion: Bool -> ()) {
        let parameters: JSONObject = ["":""]
        
        WDAPI.sharedInstance.post("gather/route/upload", parameters: parameters) { response in
            let success = response != nil
            
            completion(success)
        }
    }
}



