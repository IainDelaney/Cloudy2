//
//  ViewModel.swift
//  Cloudy
//
//  Created by Iain Delaney on 2020-05-09.
//  Copyright © 2020 Lucerne Systems. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Combine

struct DailyWeather {
	var temperature: String = ""
	var description: String = ""
    var dateString: String = ""
	var iconName: String = ""

    init(temperature: String, description: String, dateString: String, iconName: String) {
        self.temperature = temperature
        self.description = description
        self.dateString = dateString
        self.iconName = iconName
    }
}

extension DailyWeather {
	init(_ weatherModel: WeatherModel, index: Int) {
        self.temperature = String(format: "%.0f℃",weatherModel.temp.day)
        self.description = weatherModel.weather[0].description
        self.iconName = weatherModel.weather[0].icon
        let dateFormatter = DateFormatter()
        var dateComponent = DateComponents()
        dateComponent.day = index
        let calendar = Calendar.current
        let date = calendar.date(byAdding: dateComponent, to: Date(), wrappingComponents:true )!
        switch index {
            case 0,1:
                dateFormatter.dateStyle = .short
                dateFormatter.doesRelativeDateFormatting = true
            default:
                dateFormatter.dateFormat = "EEEE"
        }

        self.dateString = dateFormatter.string(from: date)
	}
}

class ViewModel: NSObject, ObservableObject {
    @Published var city:String
    @Published var days:[DailyWeather]
    @Published var iconImages:[UIImage]
    var haveLocation = false
    var locationManager = CLLocationManager()

    init(city:String, days:[DailyWeather], icons:[UIImage] ) {
        self.city = city
        self.days = days
        self.iconImages = icons
    }

    convenience override init() {
        self.init(city: "", days: Array(repeating: DailyWeather(temperature: "10", description: "Warm", dateString: "Today", iconName: "01d"), count: 5), icons: Array(repeating: UIImage(), count: 5))
    }

    func updateFromModel(_ dataModel: DataModel) {
        days.removeAll()
        for (index,model) in dataModel.list.enumerated() {
            days.append(DailyWeather.init(model, index: index))
        }
        for (index, day) in days.enumerated() {
            loadIcon(iconName: day.iconName, index: index)
        }
        self.city=dataModel.city.name
    }

    func loadIcon(iconName: String, index: Int) {
        let iconPath = "https://openweathermap.org/img/w/\(iconName).png"
        guard let imageURL = URL(string: iconPath) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data,response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("no data")
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.iconImages[index] = image
                }
            }
        }.resume()

    }
}

extension ViewModel: CLLocationManagerDelegate {
    func getLocation() {
        haveLocation = false
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        if haveLocation {
            return
        }
        haveLocation = true
        let latestLocation = locations[locations.count - 1]

        let latitudeString = String(format: "%.4f",
                               latestLocation.coordinate.latitude)
        let longitudeString = String(format: "%.4f",
                                latestLocation.coordinate.longitude)
        loadWeather(latitude: latitudeString, longitude: longitudeString)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func loadWeather(latitude:String, longitude: String) {
        let APIKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&mode=json&units=metric&cnt=5&APPID=\(APIKey)") else {
            return
        }
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let modelData = try decoder.decode(DataModel.self, from: data)
                            DispatchQueue.main.async {
                                self.updateFromModel(modelData)
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
        }.resume()
    }
}
