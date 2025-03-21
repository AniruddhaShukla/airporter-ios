//
//  Airport.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/19/25.
//

import Foundation
import CoreLocation

struct Airport: Codable, Identifiable {
    var id: String { iataCode }
    
    let iataCode: String
    let name: String
    let lat: Double?
    let long: Double?
    let description: String?
    let website: String?
    let city: String
    let imageUrl: String?
    let country: String

    enum CodingKeys: String, CodingKey {
        case iataCode = "iata_code"
        case name
        case lat
        case long
        case description
        case website
        case city
        case imageUrl = "image_url"
        case country
    }
    /// Computed property that returns the airport's coordinates as CLLocationCoordinate2D
    var coordinates: CLLocationCoordinate2D? {
        guard let lat = lat, let long = long else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
