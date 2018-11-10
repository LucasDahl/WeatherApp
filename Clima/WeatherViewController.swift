//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lucas Dahl 11/9/2018.
//  Copyright (c) 2018 Lucas Dahl. All rights reserved.
//
// PODS USED Alamofire, SwiftyJSON, SVProgressHUD
// MOst likely you will need to install your own PODS

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    // Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Outlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String, parameters: [String:String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data!")
                
                // Format the data
                let weatherJSON:JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
                
            }
        }
        
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/

    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
       
        // Get the temp from the JSON file
        if let tempResult = json["main"]["temp"].double {
        
        // Get the result from temp result and convert out of K and assiagin to the weatherDataModel object
        weatherDataModel.temperature = Int(tempResult - 273.15)
        
        // Get the city name
        weatherDataModel.city = json["name"].stringValue
        
        // Get the condition
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        // Get the weather icon to set
        weatherDataModel.weatheIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        // Update the UI
        updateUIWithWeatherData()
            
        } else {
            
            cityLabel.text = "Weather Unavailable"
            
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/

    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatheIconName)
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        // Make sure the value is vaild
        if location.horizontalAccuracy > 0 {
            
            // Stop updating once a vaild result is found
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // A dictonary to send to API source
            let params: [String:String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
        
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        cityLabel.text = "Location Unavailable"
        
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


