//
//  RoutePoint.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//
import Foundation
import MapKit

struct RoutePoint: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
