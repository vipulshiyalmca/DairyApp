//
//  ProposalServices.swift
//  WD
//
//  Created by prompt on 8/20/20.
//  Copyright © 2020 prompt. All rights reserved.
//

import UIKit

class DiaryServices {
    class func servicesDiaryList(params: Dictionary<String, Any>, callback:@escaping (Bool, [Dictionary<String, Any>], String, Int) -> Void) -> Void {
        let header =  [WebServiceCall.KContentType: WebServiceCall.KContentValue,WebServiceCall.kAPIVerSION:WebServiceCall.kAPIVerSIONValue]
        let methodName =  GET_NOTES
        let request = PSRequest(reqUrlComponent: methodName)
        request.reqParam = params
        request.headerParam = header
        let ws = WSHandler.sharedInstance()

        ws.get(request) { (response) in
            ServiceHelper.handleError(response: response, callback: { (isSuccess, res, message,statuscode) in
                callback(isSuccess, res, message,statuscode)
            })
        }
    }
   

    
}
