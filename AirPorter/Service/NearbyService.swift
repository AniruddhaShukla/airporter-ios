//
//  NearbyService.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//

import Foundation

class NearbyService {
    
    private let baseURL = "https://hammerhead-app-o95ou.ondigitalocean.app"
    
    func fetchNearbyHotels(for iataCode: String) async throws -> HotelsResponse {
        guard let url = URL(string: "\(baseURL)/airports/\(iataCode)/nearby/hotels") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(HotelsResponse.self, from: data)
        return response
    }
}
