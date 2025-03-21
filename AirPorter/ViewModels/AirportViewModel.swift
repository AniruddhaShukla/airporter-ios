//
//  AirportViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/19/25.
//

import SwiftUI
import Observation

@Observable
class AirportViewModel {
    var searchText: String = "" {
        didSet {
            Task { await fetchAirports() }
        }
    }
    
    var airports: [Airport] = []
    private let airportService = AirportService()

    func fetchAirports() async {
        guard searchText.count >= 2 else {
            airports = []
            return
        }

        do {
            airports = try await airportService.searchAirports(query: searchText)
        } catch {
            print("Error fetching airports: \(error.localizedDescription)")
            airports = []
        }
    }
}
