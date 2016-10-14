//
//  AirbnbClient.swift
//  T Capstone
//
//  Created by modelf on 10/13/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class AirbnbClient: NSObject {
    
    class func sharedInstance() -> AirbnbClient {
        struct Static {
            static var sharedInstance = AirbnbClient()
        }
        return Static.sharedInstance
    }
    
    lazy var session = {
        return URLSession.shared
    }()
    
    func getLocationForBrowse(_ quote: Quotes) -> String {
        var urlString: String!
        if let location = quote.stringName {
            let urlString = location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
        return urlString
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


    func browseAirbnbListing(_ quote: Quotes, completionHandler: @escaping (Bool?, AnyObject?, String?) -> Void) {
    
        let parameters: [String: String] = [
            ParameterKeys.client_id : API.APIKey,
            ParameterKeys.locale : ParameterValues.locale,
            ParameterKeys.currency : ParameterValues.currency,
            ParameterKeys._format : ParameterValues._format,
            ParameterKeys._limit : ParameterValues._limit,
            ParameterKeys._offset : ParameterValues._offset,
            ParameterKeys.guests : ParameterValues.guests,
            ParameterKeys.ib : ParameterValues.ib,
            ParameterKeys.ib_add_photo_flow : ParameterValues.ib_add_photo_flow,
            ParameterKeys.location : getLocationForBrowse(quote),
            ParameterKeys.min_bathrooms: ParameterValues.min_bathrooms,
            ParameterKeys.min_bedrooms: ParameterValues.min_bedrooms,
            ParameterKeys.min_beds : ParameterValues.min_beds,
            ParameterKeys.price_min : ParameterValues.price_min,
            ParameterKeys.price_max: ParameterValues.price_max,
            ParameterKeys.min_num_pic_urls: ParameterValues.min_num_pic_urls,
            ParameterKeys.sort: ParameterValues.sort,
            ParameterKeys.suppress_facets: ParameterValues.suppress_facets,
        ]
        print(parameters)
        
        let url = URL.URLBase + Method.BrowseQuotes + escapedParameters(parameters)
        
        print(url)
        
        let request = URLRequest(url: Foundation.URL(string: url)!)
        
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else {
                return
            }
            var parsedObject: AnyObject?
            do {
                parsedObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(false, nil, error.localizedDescription)
            }
            
            completionHandler(true, parsedObject!, nil)
        })
    }
}
