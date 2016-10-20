//
//  SkywaysClient.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class SkywaysClient {
    
    class func sharedInstance() -> SkywaysClient {
        struct Static {
            static var sharedInstance = SkywaysClient()
        }
        return Static.sharedInstance
    }
    
    lazy var session = {
        return URLSession.shared
        
    }()
    
    
    func browseCheapest (_ pin: Pin, completionHandler: @escaping (Bool, [[String:AnyObject]]?, [[String:AnyObject]]?, String?) -> Void ) {
       
        func getLatLonString(_ pin: Pin) -> String {
            let newLat = "\(pin.latitude)"
            let newLon = "\(pin.longitude)"
            return "\(newLat),\(newLon)-latlong/"
            
        }
        
        let latLon = getLatLonString(pin)
        
        var parameters = "\(ParameterValues.market)\(ParameterValues.currency)\(ParameterValues.locale)\(latLon)\(ParameterValues.destinationPlace)\(ParameterValues.outboundPartialDate)\(ParameterValues.inboundPartialDate)"
        
        parameters.append("apiKey=\(API.APIKey)")
        
        let url = URL.URLBase + Method.BrowseQuotes + Version.Version + parameters
        
        //debug
        print(url)
        
        let request = URLRequest(url: Foundation.URL(string: url)!)
        
        session.dataTask(with: request, completionHandler: {(data, response, error) in
         
            guard let data = data else {
                completionHandler(false, nil, nil, error?.localizedDescription)
                return
            }
            
            var parsedObject: AnyObject?
            do {
                parsedObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(false, nil, nil, error.localizedDescription)
            }
            
            let parsedQuotes = self.parserHelperQuotes(parsedObject)
            let parsedPlaces = self.parserHelperPlaces(parsedObject)
            completionHandler(true, parsedQuotes, parsedPlaces, nil)
            
        }).resume()
    }
    
        func parserHelperPlaces(_ data: AnyObject!) -> [[String: AnyObject]]? {
            
            if data != nil {
                guard let places = data.value(forKey: "Places") as? [[String: AnyObject]] else {
                    return nil
                }
                return places
            }
            return nil
        }
        
        func parserHelperQuotes(_ data: AnyObject!) -> [[String: AnyObject]]? {
            // I'm going to have to replace all the return statements for error handling eventually
            
            if data != nil {
                guard let quotes = data.value(forKey: "Quotes") as? [[String: AnyObject]] else {
                    return nil
                }
                
                return quotes
            }
            return nil
        }
    func escapedParameters(_ parameters: [String: String]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            if !(key.isEmpty) {
                let stringVal = "\(value)"
                
                let escapedValues = stringVal.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                urlVars += [key + "=" + "\(escapedValues!)"]
            }
        }
        return urlVars.joined(separator: "&")
    }
}
