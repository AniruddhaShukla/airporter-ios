//
//  AirportGatesViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/20/25.
//

import SwiftUI

@Observable
class AirportGatesViewModel {
    var gates: [Gate] = []
    private let gateService = GateService()

    func loadGates(iataCode: String) async {
        do {
            gates = try await gateService.fetchGates(for: iataCode)
        } catch {
            gates = []
            print("Error fetching gates: \(error)")
        }
    }
}
