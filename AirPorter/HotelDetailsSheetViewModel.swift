//
//  HotelDetailsSheetViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/24/25.
//

import Foundation
import MapKit

@Observable
class HotelDetailsSheetViewModel {
    // This property will hold the textual route info to display
    var distance: String = ""
    var estimatedTravelTime: String = ""
    
    
    var fromAddress: CLLocationCoordinate2D
    let toAddress: CLLocationCoordinate2D
    
    init(fromAddress: CLLocationCoordinate2D, toAddress: CLLocationCoordinate2D) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
    }
    
    // We'll use your DirectionsViewModel to fetch directions.
    private let directionsViewModel = DirectionsViewModel()
    
    /// Loads route info from a starting address (airport name) to the given hotel's address.
    /// - Parameters:
    ///   - fromAddress: The airport name or address to start from.
    ///   - toAddress: The hotel's address.
    func loadRoute() async {
        // Start fetching directions (using automobile as the default)
        directionsViewModel.getDirections(from: fromAddress, to: toAddress, transportType: .automobile)
        
        for _ in 0..<10 {
            if let route = directionsViewModel.route {
                // Format the route info with distance (in km) and expected travel time (in minutes)
                self.distance = String(format: "%.2f km", route.distance / 1000)
                let travelTimeMinutes = route.expectedTravelTime / 60.0
                let roundedTravelTime = (travelTimeMinutes - floor(travelTimeMinutes)) > 0.5 ? ceil(travelTimeMinutes) : floor(travelTimeMinutes)
                self.estimatedTravelTime = String(format: "%.0f minutes", roundedTravelTime)
                return
            }
            try? await Task.sleep(nanoseconds: 500_000_000) // sleep 0.5 second
        }
        self.distance = "No route info available."
        self.estimatedTravelTime = ""
    }
    
    func loadTravelTimeEstimates() async {
        await directionsViewModel.calculateETA(from: fromAddress,
                                               toCoordinate: toAddress,
                                               transportType: .automobile)
        if let distance = directionsViewModel.distance {
            let miles = distance * 0.62
            self.distance = String(format: "%.1f mi", miles)
        }
        if let estimatedTravelTime = directionsViewModel.expectedTravelTime {
            self.estimatedTravelTime = String(format: "%.0f min", estimatedTravelTime)
        }
    }
    func loadPublicTransitEstimates() async {
        await directionsViewModel.calculateETA(from: fromAddress,
                                               toCoordinate: toAddress,
                                               transportType: .transit)
        if let distance = directionsViewModel.distance {
            let miles = distance * 0.62
            self.distance = String(format: "%.1f mi", miles)
        }
        if let estimatedTravelTime = directionsViewModel.expectedTravelTime {
            self.estimatedTravelTime = String(format: "%.0f min", estimatedTravelTime)
        }
    }
}
