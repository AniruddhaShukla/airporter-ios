//
//  Hotels.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//


struct Hotel: Identifiable, Decodable {
    let id: Int
    let name: String
    let address: String
    let website: String?
    let phone: String?
    let distance_km: Double
    let lat: Double
    let lon: Double
}
