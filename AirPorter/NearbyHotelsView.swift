//
//  NearbyHotelsView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//


enum ViewMode: String, CaseIterable, Identifiable {
    case list = "List"
    case map = "Map"
    
    var id: String { self.rawValue }
}


import SwiftUI
import MapKit

struct NearbyHotelsView: View {
    @State private var viewMode: ViewMode = .list
    @State private var hotels: [Hotel] = []
    @State private var viewModel = NearbyHotelsViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.2905026, longitude: -94.6902992),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // For this example, we hard-code an IATA code.
    let iataCode: String
    
    var body: some View {
        VStack {
            // Segmented Control
            Picker("View Mode", selection: $viewMode) {
                ForEach(ViewMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content Based on Selected Mode
            if viewMode == .list {
                List(hotels) { hotel in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(hotel.name)
                            .font(.headline)
                        if let website = hotel.website {
                            Text(website)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        if let phone = hotel.phone {
                            Text(phone)
                                .font(.subheadline)
                        }
                        Text("Distance: \(hotel.distance_km, specifier: "%.1f") km")
                            .font(.caption)
                    }
                    .padding(4)
                }
            } else {
                // Map view displaying hotel pins.
                Map(coordinateRegion: $region, annotationItems: hotels) { hotel in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon))
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle("Nearby Hotels")
        .onAppear(perform: loadHotels)
    }
    
    private func loadHotels() {
        Task {
            await viewModel.loadHotels(iataCode: iataCode)
            self.hotels = viewModel.hotels
            if let center = viewModel.airportCenter {
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: center.lat, longitude: center.lon),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
        }
    }
}
