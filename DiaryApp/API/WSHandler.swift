//
//  WSHandler.swift
//  TakiTaki
//
//  Created by psmacmini on 17/10/19.
//  Copyright © 2019 prompt. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    func merge(_ dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}

//---------------------------------------------------------------------
// MARK: PSRequest
//---------------------------------------------------------------------

class PSRequest: NSObject {

    var reqUrlComponent:String?
    var reqParam:Dictionary<String, Any> = [:]
    var reqParamArr:Array<Dictionary<String, Any>> = []
    var headerParam:Dictionary<String,String> = [:]

    init(reqUrlComponent:String) {
        self.reqUrlComponent = reqUrlComponent
    }
}

class PSResponse: NSObject {
    var response:URLResponse?
    var resData:Data?
    var error:Error?
    var jsonType:Int?
    var dataString: String?
}

//---------------------------------------------------------------------
// MARK: WebService Handler
//---------------------------------------------------------------------
class WSHandler: NSObject,URLSessionDelegate {
    fileprivate static var obj:WSHandler?
    let kBASEURL  = BASE_URL
    let kTimeOutValue = 60

   let sessionToken:String? = nil
    var apiUrl:URL?

    static func create() -> WSHandler{
        if(obj == nil){
            obj = WSHandler()
        }
        return obj!
    }

    static func sharedInstance() -> WSHandler{
        if(obj == nil){
            return create()
        }
        else{
            return obj!
        }
    }

    //---------------------------------------------------------------------
    // MARK: appDefaultHedaer
    //---------------------------------------------------------------------
    func appDefaultHedaer() -> Dictionary<String,String>{
        let dic:Dictionary<String,String> = ["Content-Type":"application/json"]
        return dic
    }

    //---------------------------------------------------------------------
    // MARK: POST Web Service methods
    //---------------------------------------------------------------------

    func post(_ psRequest:PSRequest,completionHandler:@escaping (PSResponse?) -> Void) -> Void {
        post(psRequest,true, completionHandler: completionHandler )
    }

    func post(_ psRequest:PSRequest,_ isShowDialog:Bool,completionHandler:@escaping (PSResponse?) -> Void) -> Void {
        let urlComponent = psRequest.reqUrlComponent

        if urlComponent == nil {return}

        var urlSTR = ""

        urlSTR = kBASEURL + urlComponent!
        urlSTR = urlSTR.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        self.apiUrl = URL(string: urlSTR)
        var request = URLRequest(url: self.apiUrl!)
        request.httpMethod = "POST"
        request.timeoutInterval =  TimeInterval(kTimeOutValue);
        request.allHTTPHeaderFields = psRequest.headerParam

        // Set request param
        // TODO: if reqParam is not available then check for reqParamArray

        let reqParam = psRequest.reqParam
        let reqParamArray = psRequest.reqParamArr
        if (reqParam.count > 0) {
            do{
                let postData = try JSONSerialization.data(withJSONObject: reqParam, options:.prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: postData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                let jsonString = String(data: postData, encoding: .utf8)
                //print(jsonString!)
                // you can now cast it with the right type
                if decoded is [String:AnyObject] {
                    // use dictFromJSON
                }
                request.httpBody = postData
            }catch {
                let res = PSResponse()
                res.error = nil
                completionHandler(nil)
            }
        } else if (reqParamArray.count > 0) {
            do {
                let postData = try JSONSerialization.data(withJSONObject: reqParamArray, options:.prettyPrinted)
                let jsonString = String(data: postData, encoding: .utf8)
                //print(jsonString!)
                request.httpBody = postData
            } catch {
                let res = PSResponse()
                res.error = nil
                completionHandler(nil)
            }
        }

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            let res = PSResponse()

            if data != nil {
                res.dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let jsonData = res.dataString?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                res.resData = jsonData

                //print("@API: RESPONCE:\(res.dataString!)")
                //print("\n@API: -----------------------------------------------")
            }

            res.response = response

            if let resError = error {
                res.error = resError
            }

             completionHandler(res)
        })
        //print("@API: -----------------------------------------------\n")
        //print("@API: URL:\(urlSTR)\n")
        //print("@API: PARAM:\(reqParam)\n")
        //print("@API: PARAMARRAY: \(psRequest.reqParamArr)")

        dataTask.resume()
    }


    //---------------------------------------------------------------------
    // MARK: GET Web Service methods
    //---------------------------------------------------------------------

    //==============================================================
    public func makeQueryString(values: Dictionary<String,Any>) -> String {
        var querySTR = ""
        if values.count > 0 {
            querySTR = "?"
            for item in values {
                let key = item.key
                let value = item.value as! String
                let keyValue = key + "=" + value + "&"
                querySTR = querySTR.appending(keyValue)
            }
            querySTR.removeLast()
        }
        return querySTR
    }

    func get(_ psRequest:PSRequest,completionHandler:@escaping (PSResponse?) -> Void) -> Void {
        get(psRequest,true, completionHandler: completionHandler )
    }

    func get(_ psRequest:PSRequest,_ isShowDialog:Bool,completionHandler:@escaping (PSResponse?) -> Void) -> Void {

        let urlComponent = psRequest.reqUrlComponent

        if urlComponent == nil {return}

        let param = psRequest.reqParam
        let querySTR = makeQueryString(values: param)

        var urlSTR = kBASEURL + urlComponent! + querySTR

        urlSTR = urlSTR.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlSTR)
        var request = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = psRequest.headerParam
        request.timeoutInterval =  180;


        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            let res = PSResponse()

            if data != nil {
                res.dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let jsonData = res.dataString?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                res.resData = jsonData

                //print("@API: RESPONCE:\(res.dataString!)")
                //print("\n@API: -----------------------------------------------")
            }

            res.response = response

            if let resError = error {
                res.error = resError
            }
            completionHandler(res)
        })

        //print("@API: -----------------------------------------------\n")
        //print("@API: URL:\(urlSTR)\n")
       // //print("@API: PARAM:\(reqParam)\n")
        dataTask.resume()
    }

    //---------------------------------------------------------------------
    // MARK: URL Session methods
    //---------------------------------------------------------------------
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let url = URL(string: BASE_URL)
            let domain = url?.host
            if challenge.protectionSpace.host == domain {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential,credential);
            }
        }
    }

    //---------------------------------------------------------------------
    // MARK: Form data and multipart uploads with URLRequest
    //---------------------------------------------------------------------

    //For Single Image
    func uploadImageWithFormData(_ psRequest: PSRequest, _ image: UIImage, mimeType: String, completionHandler: @escaping (PSResponse?) -> Void) -> Void{
        let urlComponent = psRequest.reqUrlComponent

        if urlComponent == nil {return}

        var urlSTR = ""

        urlSTR = kBASEURL + urlComponent!
        urlSTR = urlSTR.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        self.apiUrl = URL(string: urlSTR)
        var request = URLRequest(url: self.apiUrl!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = psRequest.headerParam
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval =  TimeInterval(kTimeOutValue);

        // Set request param
        let reqParam = psRequest.reqParam
        let dataImg: Data?  = image.jpegData(compressionQuality: 0.7)
        let  fileName = "\(Date().timeIntervalSince1970 * 1000).png"
        request.httpBody = createBody(parameters: reqParam,
                                      boundary: boundary,
                                      data: dataImg!,
                                      mimeType: "image/png",
                                      filename: fileName)

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            if data != nil{
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("@API: RESPONCE:\(datastring!)")
                //print("\n@API: -----------------------------------------------")
            }

            let res = PSResponse()
            res.response = response

            if let resError = error {
                res.error = resError
            }

            if let resData = data {
                res.resData = resData
            }
            completionHandler(res)
        })
        //print("@API: -----------------------------------------------\n")
        //print("@API: URL:\(urlSTR)\n")
        //print("@API: PARAM:\(reqParam)\n")

        dataTask.resume()
    }

    func createBody(parameters: Dictionary<String, Any>, boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        // For Parameter
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        // for Image
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
 }

