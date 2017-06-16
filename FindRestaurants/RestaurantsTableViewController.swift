//
//  RestaurantsTableViewController.swift
//  FindRestaurants
//
//  Created by Rajesh Kommana on 16/6/17.
//  Copyright © 2017 Rajesh Kommana. All rights reserved.
//

import UIKit
import MapKit

class RestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate  {
    
    var restaurants:[Restaurant] = [Restaurant]()
    var locationManager: CLLocationManager = CLLocationManager()
    var url:String?
    var userLocation: CLLocation?
    var distanceInKM: String?
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Restaurants"
        addGeoLocation()
        
    }
    
    
    func addGeoLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    // MARK: - CLLocationManagerDelegate view data source
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userLocation = location
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        // type = restaurant
        url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=1000&type=restaurant&keyword=cruise&key=yourapikeygoeshere"
        downloadRestaurants(url!) { (array) in
            self.restaurants = array
            self.tableView.reloadData()
            
            
        }
        
        
    }
    
    
    
    func  calculateDistance(_ lat: Double, _ lng: Double) -> String {
        
        var distanceLocationString: String?
        var distance: CLLocationDistance?
        
        let restaurantLocation = CLLocation(latitude: lat, longitude: lng)
        
        distance = userLocation?.distance(from: restaurantLocation)
        
        let distanceInKM = NSString(format: "%.2f", distance!/1000)
        
        distanceLocationString = String(distanceInKM)
        
        
        return distanceLocationString!
    }
    
    
        // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RESTAURANTSCELL, for: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name!
        //if restaurant.priceLevel! == 6 {
        //    cell.detailTextLabel!.text = ""
        //}
       //cell.detailTextLabel!.text = displayPrice(price: restaurant.priceLevel!)

        let latitude = restaurant.latitude
        let longitude = restaurant.longitude
        print(latitude!)
        print(longitude!)
        
       cell.detailTextLabel!.text = calculateDistance(latitude!, longitude!) + " km"
        
        distanceInKM = calculateDistance(latitude!, longitude!) + " km"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantDetails" {
            let restaurantDetails = segue.destination as! ViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            let index = indexPath?.row
            let selectedRestaurant = restaurants[index!]
            
            restaurantDetails.restaurant = selectedRestaurant
            restaurantDetails.distanceInKM = distanceInKM
            
            
            
        }
    }
}

extension RestaurantsTableViewController {
   
    func displayPrice(price: Int) -> String {
        
        var priceLevelString: String?
        
        switch price {
        case 0:
            priceLevelString = "Free"
        case 1:
            priceLevelString = "$"
        case 2:
            priceLevelString = "$$"
        case 3:
            priceLevelString = "$$$"
        case 4:
            priceLevelString = "$$$$"
        default:
            priceLevelString = ""
        }
        
        
        
        return priceLevelString!
    }
    
    
    func downloadRestaurants(_ url: String, completion: @escaping (_ array:[Restaurant]) -> ()) {
        
        var arrayOfRestaurants:[Restaurant] = [Restaurant]()
        var openNow: Bool = false
        if let urlString = URL(string: url) {
            
            let task = URLSession.shared.dataTask(with: urlString, completionHandler: { (data, response, error) in
                
                if error == nil {
                    
                    if let validData = data {
                        
                        do {
                            let jsonDict = try JSONSerialization.jsonObject(with: validData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            print(jsonDict)
                            
                            let list = jsonDict["results"] as! NSArray
                            
                            
                            for restaurant in list {
                                let newRestaurant = restaurant as! NSDictionary
                                
                                let geo = newRestaurant["geometry"] as! NSDictionary
                                let loc = geo["location"] as! NSDictionary
                                let lat = loc["lat"] as! Double
                                let lng = loc["lng"] as! Double
                                if let openingHours = newRestaurant["opening_hours"] as?NSDictionary {
                                    openNow = openingHours["open_now"] as! Bool
                                }
                                
                                
                                let name = newRestaurant["name"] as! String
                                let address = newRestaurant["vicinity"] as! String
                                let priceLevel = newRestaurant["price_level"] as? Int ?? 6
                                let rating = newRestaurant["rating"] as? Int ?? 0
                                
                                let firstRestaurant = Restaurant(name: name, latitude: lat, longitude: lng, address: address, rating: rating, priceLevel: priceLevel, open: openNow)
                                
                                arrayOfRestaurants.append(firstRestaurant)
                                
                                DispatchQueue.main.async {
                                    completion(arrayOfRestaurants)
                                }
                                
                                
                                
                            }
                            
                            
                            
                        } catch {
                            
                            print(error.localizedDescription)
                        }
                        
                    }
                    
                }
                
                
                
            })
            
            task.resume()
            
            
            
        }
        
      
        
        
        
    }
    
}
