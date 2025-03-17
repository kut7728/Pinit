//
//  WeatherModel.swift
//  Pinit
//
//  Created by 안세훈 on 3/14/25.
//

import Foundation

struct WeatherResponse : Codable {
    let coord: Coord?
    let weather: [Weather]?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
