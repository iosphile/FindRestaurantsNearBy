//
//  Constants.swift
//  FindRestaurants
//
//  Created by Rajesh Kommana on 16/6/17.
//  Copyright © 2017 Rajesh Kommana. All rights reserved.
//

import Foundation
//1.335309, 103.890919

let RESTAURANTSCELL = "RestaurantsCell"

let BASEURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

let LATITUDE = "-33.867052"

let LONGITUDE = ",151.1957362"

let LOCATION = "location=\(LATITUDE)\(LONGITUDE)"

let RADIUS = "&radius=500"

let TYPE = "&type=restaurant"

let KEYWORD = "&keyword=cruise"

let KEY = "&key=yourapikeygoeshere"

let PLACESURl = "\(BASEURL)\(LOCATION)\(RADIUS)\(TYPE)\(KEYWORD)\(KEY)"
