//
//  AmenityType.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/12/25.
//
import Foundation

enum AmenityType: String, CaseIterable, Identifiable {
    case lounge = "lounge"
    case toilets = "toilets"
    case gate = "gate"
    case restaurant = "restaurant"
    case fastFood = "fast_food"
    case atm = "atm"
    case drinkingWater = "drinking_water"
    case cafe = "cafe"
    case deviceChargingStation = "device_charging_station"

    var id: String { self.rawValue }

    /// Provides a user-friendly display name for each amenity type
    var displayName: String {
        switch self {
        case .lounge:
            return "Lounge"
        case .toilets:
            return "Toilets"
        case .gate:
            return "Gate"
        case .restaurant:
            return "Restaurant"
        case .fastFood:
            return "Fast Food"
        case .atm:
            return "ATM"
        case .drinkingWater:
            return "Drinking Water"
        case .cafe:
            return "Café"
        case .deviceChargingStation:
            return "Device Charging Station"
        }
    }

    /// Provides a system image (SF Symbol) associated with each amenity type
    var icon: String {
        switch self {
        case .lounge:
            return "airplane.circle.fill"
        case .toilets:
            return "toilet.fill"
        case .gate:
            return "door.right.hand.open"
        case .restaurant:
            return "fork.knife"
        case .fastFood:
            return "takeoutbag.and.cup.and.straw.fill"
        case .atm:
            return "creditcard.fill"
        case .drinkingWater:
            return "drop.fill"
        case .cafe:
            return "cup.and.saucer.fill"
        case .deviceChargingStation:
            return "battery.100.bolt"
        }
    }
}
