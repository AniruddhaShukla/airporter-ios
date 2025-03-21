//
//  AirportDetailView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/12/25.
//

import SwiftUI
import MapKit

struct AirportDetailView: View {
    let airport: Airport
    
    @State private var region: MKCoordinateRegion
    @State private var selectedDetent: PresentationDetent = .medium
    @State private var showGateRouteView = false

    init(airport: Airport) {
        self.airport = airport
        self._region = State(initialValue: MKCoordinateRegion(
            center: airport.coordinates!,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: [airport]) { airport in
                    MapMarker(coordinate: airport.coordinates!, tint: .blue)
                }.mapStyle(.imagery)
                .ignoresSafeArea()
            }
            .sheet(isPresented: .constant(!showGateRouteView)) {  // ✅ Keep the sheet always visible
                VStack {
                    if selectedDetent == .height(64) {
                        Text(airport.name)
                            .font(.headline)
                            .padding()
                    } else {
                        // ✅ Pass `showGateRouteView` binding to trigger navigation
                        AirportAmenitiesView(airport: airport, showGateRouteView: $showGateRouteView)
                    }
                }
                .presentationDetents([.height(64), .medium, .large], selection: $selectedDetent)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled(true)
            }
            // ✅ Conditional NavigationLink (Invisible, activates when showGateRouteView is true)
            .background(
                NavigationLink(
                    destination: GateRouteView(iataCode: airport.id),
                    isActive: $showGateRouteView
                ) { EmptyView() }  // Invisible NavigationLink
            )
        }
    }
}
