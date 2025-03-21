//
//  GateService.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/19/25.
//

import Foundation

class GateService {
    private let baseURL = "https://hammerhead-app-o95ou.ondigitalocean.app"

    func fetchGates(for iataCode: String) async throws -> [Gate] {
        guard let url = URL(string: "\(baseURL)/airports/\(iataCode)/gates") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(GateResponse.self, from: data)
        return response.gates.sorted { $0.number < $1.number }
    }
}


