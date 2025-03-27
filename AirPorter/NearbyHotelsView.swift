//
//  NearbyHotelsView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//


import SwiftUI
import MapKit

enum ViewMode: String, CaseIterable, Identifiable {
    case list = "List"
    case map = "Map"
    
    var id: String { self.rawValue }
}

struct NearbyHotelsView: View {
    @State private var viewMode: ViewMode = .list
    @State private var hotels: [Hotel] = []
    @State private var viewModel = NearbyHotelsViewModel()
    @State private var selectedHotel: Hotel? = nil  // New state for selected hotel

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.2905026, longitude: -94.6902992),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // For this example, we hard-code an IATA code.
    let airport: Airport
    
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
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(hotel.name)
                            .font(.title3).bold()
                        
                        if let website = hotel.website {
                            if let phone = hotel.phone {
                                HStack {
                                    if let website = hotel.website {
                                        Link(destination: URL(string: website)!) {
                                            HStack {
                                                Image(systemName: "link.circle.fill").font(.subheadline)
                                                Text("Website").font(.subheadline)
                                            }
                                        }
                                    }
                                    CallButton(phoneNumber: phone)
                                    Spacer()
                                }
                            } else {
                                Link(destination: URL(string: website)!) {
                                    HStack {
                                        Image(systemName: "link.circle.fill").font(.headline)
                                        Text("Website").font(.headline)
                                    }
                                }
                            }

                        }
                        
                        Text("Distance from Airport: \(hotel.distance_km, specifier: "%.1f") km")
                            .foregroundStyle(.gray)
                            .font(.headline)
                    }
                }
            } else {
                NearbyHotelMapView(hotels: hotels,
                                   selectedHotel: $selectedHotel,
                                   region: region, airport: airport)
            }
        }
        .navigationTitle("Nearby Hotels")
        .onAppear(perform: loadHotels)
    }
    
    private func loadHotels() {
        Task {
            await viewModel.loadHotels(iataCode: airport.iataCode)
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
