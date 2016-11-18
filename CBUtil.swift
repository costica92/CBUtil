//
//  File.swift
//  7Store.
//
//  Created by Zoom-Biz on 04.04.2016.
//  Copyright © 2016 Zoom-Biz. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreTelephony


/// A colleciton of util methods
class CBUtil  {
    
    
    /// Check if device is IPAD
    static let isIpad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    
    
    /// Get top view controller
    ///
    /// - returns: UIViewController
    static func topViewController() -> UIViewController?{
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            if let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            return topController
        }
        return nil
    }
    
    
    /// Check if device can make phone calls
    ///
    /// - returns: Bool
    final class func canMakePhoneCall() -> Bool {
        guard let URL = NSURL(string: "tel://") else {
            return false
        }
        
        let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
        
        let isInvalidNetworkCode = mobileNetworkCode == nil
            || mobileNetworkCode?.characters.count == 0
            || mobileNetworkCode == "65535"
        
        return UIApplication.shared.canOpenURL(URL as URL)
            && !isInvalidNetworkCode && !self.isIpad
    }
    
    
    /// Covnert html text to attributed String
    ///
    /// - parameter text: text with html tags
    ///
    /// - returns: NSAttributedString
    final class func htmlText(text: String) -> NSAttributedString {
        
        let attrStr = try! NSAttributedString(
            data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [
                NSFontAttributeName : UIFont(name: "Roboto-Medium", size: 15.0)!,
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                
            ],
            documentAttributes: nil)
        return attrStr
    }
    
    
    /// Remove html tags from text
    ///
    /// - parameter htmlString: Text with html tags
    ///
    /// - returns: String
    final class func htmlTrim(htmlString: String) -> String? {
        let htmlStringData = htmlString.data(using: String.Encoding.utf8)!
        let options: [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject]
        guard let attributedHTMLString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil) else {
            return nil
        }
        return attributedHTMLString.string
    }
    
    
    
    /// Generate a random string
    ///
    /// - parameter len: Lenght of the string
    ///
    /// - returns: Generated String
    final class func randomStringWithLength (len : Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
    
    /// Generate a random color
    ///
    /// - returns: Color
    final class func randomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
    
    /// Run code with deila
    ///
    /// - parameter seconds:    Double delay in seconds
    /// - parameter completion: code to run after delay
    final class func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    
    
    /// Compare float numbers with different precission
    ///
    /// - parameter a: Float
    /// - parameter b: Float
    ///
    /// - returns: Bool with numbers almost equal
    final class func nearlyEqual(_ a: Float, _ b: Float) -> Bool {
        let epsilon: Float = 0.000001
        
        let absA: Float = abs(a)
        let absB: Float = abs(a)
        let diff: Float = abs(a - b)
        
        if (a == b) {
            return true
        } else {
            return diff / (absA + absB) < epsilon
        }
    }
}


// MARK: - String Extension
extension String {
    
    /// Remove html tags from string
    ///
    /// - returns: String
    func htmlTrim() -> String? {
        return CBUtil.htmlTrim(htmlString: self)
    }
}
