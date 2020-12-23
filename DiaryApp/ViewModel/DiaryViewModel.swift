//
//  ProposalViewModel.swift
//  WD
//
//  Created by prompt on 8/20/20.
//  Copyright © 2020 prompt. All rights reserved.
//

import UIKit
import ObjectMapper

class DiaryViewModel {
    
    class func getDiaryList(params: Dictionary<String, Any>,callback: @escaping(Bool, String, Int, Any) -> Void) -> Void {
           if !AppHelper.isInternetConnected() {
               let message = AppHelper.localizedtext(key: "internet.alert.text")
               callback(false, message, 503, [[:]])
           } else {
            DiaryServices.servicesDiaryList(params: params) { (success, response, message, statuscode) in
                   //if success {
                       //do {
                           let data: [Dictionary<String, Any>] = response
                           //let proposalAttachmentData = data["data"] as? [Dictionary<String, Any>] ?? [[:]]
                         let arrNote = Mapper<Note>().mapArray(JSONObject: data)

                    callback(success, message, statuscode, arrNote as Any)
                       //} catch {
                        //   callback(false, message, statuscode, response)
                      // }
                  // } else {
                       //callback(false, message, statuscode, response)
                   //}
               }
           }
       }

}
