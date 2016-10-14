//
//  AirbnbConstants.swift
//  T Capstone
//
//  Created by modelf on 10/13/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation

extension AirbnbClient {
    
    struct API {
        static var APIKey = "3092nxybyb0otqw18e8nh5nty"
        
    }
    
    struct URL {
        static var URLBase = "https://api.airbnb.com/v2/"
        
    }
    
    struct Method {
        static var BrowseQuotes = "search_results?"
    }
    
    struct ParameterKeys {
        static var client_id: String = "client_id"
        static var locale: String = "locale"
        static var currency: String = "currency"
        static var _format: String = "_format"
        static var _limit: String = "_limit"
        static var _offset: String = "_offset"
        static var guests: String = "guests"
        static var ib: String = "ib"
        static var ib_add_photo_flow: String = "ib_add_photo_flow"
        static var location: String = "location"
        static var min_bathrooms: String = "min_bathrooms"
        static var min_bedrooms: String = "min_bedrooms"
        static var min_beds: String = "min_beds"
        static var price_min: String = "price_min"
        static var price_max: String = "price_max"
        static var min_num_pic_urls: String = "min_num_pic_urls"
        static var sort: String = "sort"
        static var suppress_facets: String = "suppress_facets"
        static var user_lat: String = "user_lat"
        static var user_lng: String = "user_lng"
        
    }
    
    struct ParameterValues {
        static var locale: String = "en-US"
        static var currency: String = "USD"
        static var _format: String = "for_search_results_with_minimal_pricing"
        static var _limit: String = "10"
        static var _offset: String = "0"
        static var guests: String = "1"
        static var ib: String = "false"
        static var ib_add_photo_flow: String = "true"
        static var location: String = ""
        static var min_bathrooms: String = "0"
        static var min_bedrooms: String = "0"
        static var min_beds: String = "0"
        static var price_min: String = "0"
        static var price_max: String = "500"
        static var min_num_pic_urls: String = "1"
        static var sort: String = "1"
        static var suppress_facets: String = "true"
        static var user_lat: String = ""
        static var user_lng: String = ""
        
    }

}
