//
//  Restaurant.swift
//  FindRestaurants
//
//  Created by Rajesh Kommana on 16/6/17.
//  Copyright © 2017 Rajesh Kommana. All rights reserved.
//

import Foundation

class Restaurant: NSObject {
    
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var open: Bool?
    var rating: Int?
    var priceLevel: Int?
    var webUrl: URL?
    
    init(name: String, latitude: Double, longitude: Double,address: String, rating: Int, priceLevel: Int, open: Bool) {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.rating = rating
        self.priceLevel = priceLevel
        self.webUrl = URL(string: "")
        self.open = open
        
    }
    
    
    
}
