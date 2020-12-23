//
//  ServiceHelper.swift
//  TakiTaki
//
//  Created by psmacmini on 17/10/19.
//  Copyright © 2019 prompt. All rights reserved.
//

import Foundation
import UIKit

class ServiceHelper {
    class func getHeaderParams() -> Dictionary <String, String> {
        let headerParam =  [WebServiceCall.KContentType: WebServiceCall.KContentValue]
//        let authorizationHeader = "Bearer \(User.signedInUser().token ?? "")"
//        print("Header:-"+authorizationHeader);
//        headerParam ["X-ApiVersion"] = "1.0"
//        headerParam ["Authorization"] = authorizationHeader
        return headerParam;
    }
    
    class func handleError(response: PSResponse?, callback:@escaping (Bool, [Dictionary<String, Any>], String, Int) -> Void) -> Void {
        var responseDetails: [Dictionary<String, Any>] = [[:]]
        // stage 1
        let error = response?.error
        if (error != nil ) {
            callback(false, responseDetails, "Something went wrong", 500)
        }
        
        // stage 2
        let resData = response?.resData
        if resData != nil {
            do {
                
                let response : PSResponse = response!
                responseDetails = try JSONSerialization.jsonObject(with: response.resData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String,Any>]

                let statusCode: Int = 500
                let message = ""
                // var responseDetails: Dictionary<String, Any> = [:]

                // Get response status code
//                  if let code = responseDetails[RESPONSE_STATUSCODE] {
//                        statusCode = code as! Int
//                  }
//                   message = responseDetails[RESPONSE_MESSAGE] as? String ?? ""
                
                switch (statusCode) {
                    // 1 - Success
                    case 1, 200:
                        let mainData = responseDetails // [MAIN_DATA] as? Dictionary<String, Any> ?? [:]
                        callback(true, mainData, message, statusCode)
                    case 0:
                        callback(true, [[:]], message, statusCode)
                        
                   // case 400:// 400 Validation Message
//                        let mainData = responseDetails[MAIN_DATA] as? Dictionary<String, Any> ?? [:]
//                        let errorList:[String] = mainData["error"] as? Array ?? []
//                        if errorList.count > 0 {
//                            message = errorList.first ?? ""
//                        }
//                        callback(false, mainData, message, statusCode)
                    case 404:
                        callback(false, responseDetails, message,statusCode)
                    case 409:
                        callback(false, responseDetails, message,statusCode)
                    case 500: // 500 - Internal server error
                        callback(false, responseDetails, message,statusCode)
                    default:
                        callback(true, responseDetails, message,statusCode)
                    break
                }
            } catch {
                callback(false, responseDetails, "No Data Found", 500)
            }
        }
    }
    
}

