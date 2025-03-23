//
//  DirectionsViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI
import MapKit
import CoreLocation

@Observable
class DirectionsViewModel {
    var route: MKRoute?
    var errorMessage: String?

    private let geocoder = CLGeocoder()
    
    /// Calculate driving or public-transit directions between two coordinates.
    /// - Parameters:
    ///   - fromCoordinate: The starting coordinate.
    ///   - toCoordinate: The destination coordinate.
    ///   - transportType: The type of transport to request (.automobile, .transit, etc.).
    func getDirections(from fromCoordinate: CLLocationCoordinate2D,
                       to toCoordinate: CLLocationCoordinate2D,
                       transportType: MKDirectionsTransportType = .automobile) {
        // 1. Create MKPlacemark for start and destination
        let startPlacemark = MKPlacemark(coordinate: fromCoordinate)
        let endPlacemark = MKPlacemark(coordinate: toCoordinate)
        
        // 2. Create MKMapItems
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        // 3. Create an MKDirections.Request
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = endMapItem
        request.transportType = transportType
        request.requestsAlternateRoutes = false
        
        // 4. Calculate the route
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Error calculating directions: \(error.localizedDescription)"
                return
            }
            guard let route = response?.routes.first else {
                self.errorMessage = "No routes found."
                return
            }
            
            // 5. Store the route
            self.route = route
        }
    }
}
