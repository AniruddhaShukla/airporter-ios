//
//  AirportService.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/19/25.
//

import Foundation


class AirportService {
    private let baseURL = "https://hammerhead-app-o95ou.ondigitalocean.app"

    func searchAirports(query: String) async throws -> [Airport] {
        guard let url = URL(string: "\(baseURL)/airports/search?query=\(query)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Print status code
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }

        // Print raw JSON response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response:\n\(jsonString)")
        } else {
            print("Invalid JSON format")
        }

        // Decode response
        return try JSONDecoder().decode([Airport].self, from: data)
    }
}
