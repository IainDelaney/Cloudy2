//
//  DataModel.swift
//  Cloudy
//
//  Created by Iain Delaney on 2020-05-09.
//  Copyright © 2020 Lucerne Systems. All rights reserved.
//

struct DataModel: Codable {
    let list:[WeatherModel]
    let city:City
}

struct WeatherModel: Codable {
    let weather:[Weather]
    let temp: Temp
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let day: Float
}

struct City: Codable {
    let id:Int
    let name: String
}
