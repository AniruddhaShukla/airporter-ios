//
//  HotelDetailsSheetView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI
import MapKit

struct HotelDetailsSheetView: View {
    
    let hotel: Hotel
    let airport: Airport
    
    
    @State private var viewModel: HotelDetailsSheetViewModel?
    
    @State private var showLookAround: Bool = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    init(hotel: Hotel, airport: Airport) {
        self.hotel = hotel
        self.airport = airport
        if let sourceCoordinate = airport.coordinates {
            let destinationCoordinate = CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon)
            self._viewModel = State(wrappedValue: HotelDetailsSheetViewModel(fromAddress:sourceCoordinate, toAddress: destinationCoordinate))
        }
       
    }
    
    @ViewBuilder
    private func hotelInfoSection(geometry: GeometryProxy) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8.0) {
                if let website = hotel.website {
                    LinkView(website: website, name: hotel.name)
                        .frame(width: geometry.size.width, height: geometry.size.width / 2.8)
                        .clipped() // or .aspectRatio(16/9, contentMode: .fit) if you prefer
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
                }
                Text(hotel.name)
                    .font(.title2).bold()
                    .padding([.leading, .trailing], 8.0)
                
                Text(hotel.address)
                    .font(.headline)
                    .padding([.leading, .trailing], 8.0)
                
                if let phone = hotel.phone {
                    CallButton(phoneNumber: phone).padding(8.0)
                }
                Section {
                    Button(action: {
                        Task {
                            await fetchLookAroundScene()
                        }
                        
                    }, label: {
                        HStack {
                            Image(systemName: "binoculars.fill")
                            Text("Look Around")
                        }
                    })
                }
            }

        }
    }
    
    @ViewBuilder
    private func travelInfoSection(geometry: GeometryProxy) -> some View {
        Section {
            if let viewModel {
                Text("Travel times from \(airport.name)").font(.headline)
                    .fontWeight(.medium)
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
            } else {
                EmptyView()
            }
        }

    }
    
    // New method to fetch Look Around scene
     private func fetchLookAroundScene() async {
         let request = MKLookAroundSceneRequest(coordinate: CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon))
         
         Task {
             do {
                 let scene = try await request.scene
                 await MainActor.run {
                     self.lookAroundScene = scene
                 }
                 try? await Task.sleep(nanoseconds: 950_000_000) // 150 ms delay
                 await MainActor.run {
                     self.showLookAround = true
                 }
             } catch {
                 print("Error fetching Look Around scene: \(error)")
                 // Optionally show an alert to the user
             }
         }
     }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                hotelInfoSection(geometry: geometry)
                Divider()
                travelInfoSection(geometry: geometry)
            }
        }
        .onAppear {
            Task {
                await viewModel?.loadTravelTimeEstimates()
                //await viewModel?.loadPublicTransitEstimates()
            }
        }
        .sheet(isPresented: $showLookAround) {
            if let scene = lookAroundScene {
                LookAroundPreview(scene: $lookAroundScene)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Look Around not available")
                    .padding()
            }
        }
        .presentationDetents([.medium, .large])
    }
}
