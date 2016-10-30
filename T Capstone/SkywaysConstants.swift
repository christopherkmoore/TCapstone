//
//  SkywaysConstants.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation


extension SkywaysClient {
    
    struct API {
        static var APIKey = "prtl6749387986743898559646983194"
        
    }
    
    struct URL {
        static var URLBase = "http://partners.api.skyscanner.net/apiservices/"
        
    }
    
    struct Method {
        static var BrowseQuotes = "browsequotes/"
    }
    
    struct Version {
        static var Version = "v1.0/"
    }
    struct ParameterKeys {
        static var market: String = "market"
        static var currency: String = "currency"
        static var locale: String = "locale"
        static var originPlace: String = "originPlace"
        static var destinationPlace: String = "destinationPlace"
        static var outboundPartialDate: String = "outboundPartialDate"
        static var inboundPartialDate: String = "inboundPartialDate"
    }
    
    struct ParameterValues {
        static var market: String = "US/"
        static var currency: String = "USD/"
        static var locale: String = "en-US/"
        static var originPlace: String = "anywhere/"
        static var destinationPlace: String = "anywhere/"
        static var outboundPartialDate: String = "anytime/"
        static var inboundPartialDate: String = "anytime?"
        
    }
    struct HTTPReturn {
        static var json = "application/json"
    }
}
