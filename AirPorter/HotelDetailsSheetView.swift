//
//  HotelDetailsSheetView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI

struct HotelDetailsSheetView: View {
    
    let hotel: Hotel
    let airport: Airport
    
    
    @State private var viewModel: HotelDetailsSheetViewModel?
    
    init(hotel: Hotel, airport: Airport) {
        self.hotel = hotel
        self.airport = airport
        if let sourceCoordinate = airport.coordinates {
            let destinationCoordinate = CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon)
            self._viewModel = State(wrappedValue: HotelDetailsSheetViewModel(fromAddress:sourceCoordinate, toAddress: destinationCoordinate))
        }
       
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                if let website = hotel.website {
                    LinkView(website: website, name: hotel.name)
                        .frame(width: geometry.size.width, height: geometry.size.width / 2.8)
                        .clipped() // or .aspectRatio(16/9, contentMode: .fit) if you prefer
                    
                    Text(hotel.name)
                        .font(.title2).bold()
                        .padding([.leading, .trailing], 8.0)
                    
                    Text(hotel.address)
                        .font(.headline)
                        .padding([.leading, .trailing], 8.0)
                    
                    if let phone = hotel.phone {
                        CallButton(phoneNumber: phone).padding(8.0)
                    }
                   
                    if let viewModel {
                        Text("Travel times from \(airport.name)")
                            .font(.headline).fontWeight(.semibold)
                            .padding(.leading, 8.0)
                        HStack {
                            Image(systemName: "car.circle.fill")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                            VStack(alignment: .leading) {
                                Text(viewModel.distance).font(.headline)
                                Text(viewModel.estimatedTravelTime).font(.subheadline)
                            }
                        }.padding([.leading], 8.0)
                    }
                        
                } else {
                    Color.accentColor.frame(width: geometry.size.width, height: 120)
                        .overlay {
                            HStack {
                                Image(systemName: "bed.double.circle.fill")
                                    .resizable().frame(width: 32, height: 32)
                                Text(hotel.name)
                                    .font(.title2)
                                    .bold()
                                    .padding([.leading, .trailing], 4.0)
                            }.padding()

                        }

                    Text(hotel.address)
                        .font(.headline)
                        .padding([.leading, .trailing], 8.0)
                    
                    if let phone = hotel.phone {
                        CallButton(phoneNumber: phone).padding(8.0)
                    }
                    
                    
                    if let viewModel {
                        Text("Travel times from \(airport.name)").font(.headline).fontWeight(.semibold)
                            .padding(.leading, 8.0)
                        HStack {
                            Image(systemName: "car.circle.fill")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                            VStack(alignment: .leading) {
                                Text(viewModel.distance).font(.headline)
                                Text(viewModel.estimatedTravelTime).font(.subheadline)
                            }
                        }.padding([.leading], 8.0)
                    }

                }
            }
        }
        .onAppear {
            Task {
                await viewModel?.loadRoute()
            }
        }
        .presentationDetents([.medium, .large])
    }
}

import Foundation
import MapKit

@Observable
class HotelDetailsSheetViewModel {
    // This property will hold the textual route info to display
    var distance: String = ""
    var estimatedTravelTime: String = ""
    
    var fromAddress: CLLocationCoordinate2D
    let toAddress: CLLocationCoordinate2D
    
    init(fromAddress: CLLocationCoordinate2D, toAddress: CLLocationCoordinate2D) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
    }
    
    // We'll use your DirectionsViewModel to fetch directions.
    private let directionsViewModel = DirectionsViewModel()
    
    /// Loads route info from a starting address (airport name) to the given hotel's address.
    /// - Parameters:
    ///   - fromAddress: The airport name or address to start from.
    ///   - toAddress: The hotel's address.
    func loadRoute() async {
        // Start fetching directions (using automobile as the default)
        directionsViewModel.getDirections(from: fromAddress, to: toAddress, transportType: .automobile)
        
        // Wait for a short time until a route is available. (You may wish to update DirectionsViewModel to an async API for production.)
        for _ in 0..<10 {
            if let route = directionsViewModel.route {
                // Format the route info with distance (in km) and expected travel time (in minutes)
                self.distance = String(format: "%.2f km", route.distance / 1000)
                let travelTimeMinutes = route.expectedTravelTime / 60.0
                let roundedTravelTime = (travelTimeMinutes - floor(travelTimeMinutes)) > 0.5 ? ceil(travelTimeMinutes) : floor(travelTimeMinutes)
                self.estimatedTravelTime = String(format: "%.0f minutes", roundedTravelTime)
                return
            }
            try? await Task.sleep(nanoseconds: 500_000_000) // sleep 0.5 second
        }
        self.distance = "No route info available."
        self.estimatedTravelTime = ""
    }
}
