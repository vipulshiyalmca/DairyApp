//
//  AppHelper.swift
//  WD
//
//  Created by prompt on 8/7/20.
//  Copyright © 2020 prompt. All rights reserved.
//

import UIKit
import SystemConfiguration

class AppHelper: NSObject {
    static func localizedtext(key:String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    //  ------- Show Alert
    static func showAlert(view: UIView, message:String) {
        if message != "" {
            view.makeToast(message)
        }
    }

    // ---------- Show Alert with OK Action
    static func showAlertWithAction(vc: UIViewController, title: String?, message: String, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in
            okAction()
        })
        alert.addAction(okayAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------
    // MARK: Check Internet Connected or Not
    //---------------------------------------------------------------------
    static func isInternetConnected() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    static func ChangeDateFormate(Fulldate strdate: String, CurrentFormate setFor : String, getFormate getFor : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = setFor
        let formateDate = dateFormatter.date(from:strdate)!
        dateFormatter.dateFormat = getFor
        let dateFromString = "\(dateFormatter.string(from: formateDate))"
        return dateFromString
    }
    
    static func ConvertTimestampTodate(strdate: String, Format : String) -> String {
        let unixTimestamp = Double(strdate)
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dateFormatter.dateFormat = Format //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        //        print(strDate)
        return strDate
    }
    
    static func ConvertDatetoTimestamp(strDate:String,formate:String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.locale = Locale(identifier: "en_US_POSIX")
        dfmatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dfmatter.dateFormat = formate

        let date = dfmatter.date(from: strDate)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let valTimestamp:Int = Int(dateStamp)
        return valTimestamp
    }
    
    static func timeAgoSinceDate(datefrom:String) -> String {

        // From Time
        let dfmatter = DateFormatter()
        dfmatter.locale = Locale(identifier: "en_US_POSIX")
        dfmatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dfmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let fromDate = dfmatter.date(from: datefrom ) ?? Date()

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }

    
    

    static func ChangeDateFormat(Fulldate strdate: String, CurrentFormate setFor : String, getFormate getFor : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = setFor
        let formateDate = dateFormatter.date(from:strdate)!
        dateFormatter.dateFormat = getFor
        let dateFromString = "\(dateFormatter.string(from: formateDate))"
        return dateFromString
    }
    
    static func getCurrentDate(Format : String) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: date)
        return result
    }

}
