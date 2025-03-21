//
//  WakingRouteResponse.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import Foundation
struct WalkingRouteResponse: Codable {
    let start_coordinates: Coordinate
    let end_coordinates: Coordinate
    let route: RouteData

    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }

    struct RouteData: Codable {
        let distance_meters: Double
        let distance_km: Double
        let duration_seconds: Double
        let duration_minutes: Double
        let geometry: GeometryData
    }

    struct GeometryData: Codable {
        let coordinates: [[Double]]  // [[longitude, latitude]]
        let type: String
    }
}
