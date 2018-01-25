//
//  PBServiceHelper.swift
//  Postablur
//
//  Created by Saraschandra on 19/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
import Alamofire

enum URLRequestError: Error
{
    case noAuthToken
    case networkUnavailable
    
    var localizedDescription: String
    {
        switch self
        {
        case .noAuthToken:
            return "Unable to complete network request.  User Auth Token not present."
        case .networkUnavailable:
            return "Unable to complete network request.  No Internet connection present."
        }
    }
}

class PBServiceHelper: NSObject
{
    typealias PBGetCompletionHandler = (AnyObject?, Error?) -> Swift.Void
    typealias PBPostCompletionHandler = (AnyObject?, Error?) -> Swift.Void

    var appdelegate : AppDelegate!
    
    
    
    
    // MARK: Upload Profile Image
    func uploadProfileImage(url: String, image: UIImage, imageName: String)
    {
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appdelegate.isNetworkReachable() == false
        {
            DispatchQueue.main.async(execute: { () -> Void in
                
            })
            return
        }
        let urlString = String(format: url)
        
        let request = NSMutableURLRequest(url: NSURL(string:urlString)! as URL)
        
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = ["content-type":"multipart/form-data",Urls.AccessToken: Urls.AccessTokenValue]
        
    }
    
    
    func post(url:String, parameters:NSDictionary, completion: @escaping PBPostCompletionHandler)
    {
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appdelegate.isNetworkReachable() == false
        {
            let error: Error = URLRequestError.networkUnavailable
            
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, error)
            })
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Urls.AccessTokenValue]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard data != nil else
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, error)
                })
                return
            }
            
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                {
                    DispatchQueue.main.async
                    {
                        completion(json, nil)
                    }
                }
                else
                {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print("Error could not parse JSON: \(jsonStr)")
                    //failed
                    completion(jsonStr, nil)
                    
                }
            }
            catch let parseError
            {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                ///print("Error could not parse JSON: '\(jsonStr)'")
                completion(jsonStr, nil)
                
            }
        }
        
        task.resume()
    }
    
    func get(url:String, completion: @escaping PBGetCompletionHandler)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = ["Content-Type":"application/json; charset=utf-8", Urls.AccessToken: Urls.AccessTokenValue]
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, error)
                })
                return
            }
            
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                {
                    DispatchQueue.main.async
                    {
                        completion(json, nil)
                    }
                }
                else
                {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //No error thrown, but not NSDictionary
                    //print("Error could not parse JSON: \(jsonStr)")
                    //failed
                    completion(jsonStr, nil)
                }
            }
            catch let parseError
            {
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Error could not parse JSON: '\(jsonStr)'")
                completion(jsonStr, nil)

            }
        }
        
        task.resume()
    }
}
