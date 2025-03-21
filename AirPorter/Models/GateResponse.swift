//
//  GateResponse.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/20/25.
//


struct GateResponse: Codable {
    let gates: [Gate]
    let count: Int
    let iata: String
}
