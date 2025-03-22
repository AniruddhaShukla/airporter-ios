//
//  HotelsResponse.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//

struct Coordinate: Decodable {
    let lat: Double
    let lon: Double
}


struct HotelsResponse: Decodable {
    let iata: String
    let airport_center: Coordinate
    let hotel_count: Int
    let hotels: [Hotel]
}
