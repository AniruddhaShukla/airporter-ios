//
//  WalkingRouteViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

import Foundation
import MapKit

class WalkingRouteViewModel: ObservableObject {
    @Published var routeCoordinates: [RoutePoint] = []
    @Published var routePolyline: MKPolyline?
    @Published var mapAnnotations: [CustomAnnotation] = []
    @Published var distance: Double = 0.0
    @Published var time: Int = 0
    
    /// Dynamically updates the region to ensure both start and end coordinates are visible
    @Published var region = MKCoordinateRegion()

    private let baseURL = "https://hammerhead-app-o95ou.ondigitalocean.app"

    /// Fetches walking route between two gates in the same airport
    func fetchGateRoute(iata: String, fromGate: String, toGate: String) {
        let urlString = "\(baseURL)/airports/\(iata)/route/gates?from_gate=\(fromGate)&to_gate=\(toGate)"
        fetchRoute(urlString: urlString, fromGate: fromGate, endGate: toGate)
    }

    /// Fetches route data and updates UI accordingly
    private func fetchRoute(urlString: String, fromGate: String?, endGate: String?) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(WalkingRouteResponse.self, from: data)
                DispatchQueue.main.async {
                    self.routeCoordinates = decodedResponse.route.geometry.coordinates.map { coord in
                        RoutePoint(latitude: coord[1], longitude: coord[0])
                    }
                    
                    let coordinates = self.routeCoordinates.map { $0.coordinate }
                    self.routePolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

                    let startCoord = CLLocationCoordinate2D(latitude: decodedResponse.start_coordinates.lat, longitude: decodedResponse.start_coordinates.lon)
                    let endCoord = CLLocationCoordinate2D(latitude: decodedResponse.end_coordinates.lat, longitude: decodedResponse.end_coordinates.lon)

                    // Add annotations for start and end gates
                    if let fromGate, let endGate {
                        self.mapAnnotations = [
                            CustomAnnotation(coordinate: startCoord, title: "Gate \(fromGate)"),
                            CustomAnnotation(coordinate: endCoord, title: "Gate \(endGate)")
                        ]
                    }


                    self.updateMapRegion(start: startCoord, end: endCoord)
                    self.distance = decodedResponse.route.distance_km
                    self.time = Int(decodedResponse.route.duration_minutes)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    /// Updates the map region dynamically to ensure both points are visible
    private func updateMapRegion(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let minLat = min(start.latitude, end.latitude)
        let maxLat = max(start.latitude, end.latitude)
        let minLon = min(start.longitude, end.longitude)
        let maxLon = max(start.longitude, end.longitude)

        // Expand region slightly to add padding
        let paddingFactor = 1.2
        let latSpan = (maxLat - minLat) * paddingFactor
        let lonSpan = (maxLon - minLon) * paddingFactor

        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLon + minLon) / 2
        )
        let span = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)

        self.region = MKCoordinateRegion(center: center, span: span)
    }

    /// Provides overlays for the route polyline
    var mapOverlays: [MKOverlay] {
        if let polyline = routePolyline {
            return [polyline]
        }
        return []
    }
}
