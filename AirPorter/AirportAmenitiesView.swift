//
//  AirportAmenitiesView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/12/25.
//

import SwiftUI

struct AirportAmenitiesView: View {
    let airport: Airport
    @Binding var showGateRouteView: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text(airport.name)
                    .font(.headline)
                    .padding()

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                    ForEach(AmenityType.allCases, id: \.self) { amenity in
                        VStack {
                            Image(systemName: amenity.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Text(amenity.displayName.capitalized)
                                .font(.caption)
                        }
                        .onTapGesture {
                            print("Selected \(amenity.rawValue)")
                        }
                    }
                }
                Button(action: {
                    self.showGateRouteView = true
                }, label: {
                    Text("Gate Navigation")
                })
            }

        }
        .presentationDetents([.fraction(20.0), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}
