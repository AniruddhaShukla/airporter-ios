//
//  NearbyHotelsViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//

import SwiftUI

@Observable
class NearbyHotelsViewModel {
    var hotels: [Hotel] = []
    var airportCenter: Coordinate?
    
    private let nearbyService = NearbyService()
    
    func loadHotels(iataCode: String) async {
        do {
            let response = try await nearbyService.fetchNearbyHotels(for: iataCode)
            airportCenter = response.airport_center
            hotels = response.hotels
        } catch {
            hotels = []
            airportCenter = nil
            print("Error fetching hotels: \(error)")
        }
    }
}
