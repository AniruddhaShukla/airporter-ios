//
//  WalkingRouteView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import SwiftUI
import MapKit

//
//struct WalkingRouteView: View {
//    let startingCoordinate: CLLocationCoordinate2D
//    let endingCoordinate: CLLocationCoordinate2D
//    let startingLabel: String
//    let endingLabel: String
//
//    @StateObject private var viewModel = WalkingRouteViewModel()
//
//    var body: some View {
//        SatelliteMapView(region: $viewModel.region,
//                         annotations: mapAnnotations,
//                         overlays: viewModel.mapOverlays)
//            .onAppear {
//                viewModel.fetchWalkingRoute(start: startingCoordinate, end: endingCoordinate)
//            }
//    }
//    
//    var mapAnnotations: [MKAnnotation] {
//        return [
//            CustomAnnotation(coordinate: startingCoordinate, title: startingLabel),
//            CustomAnnotation(coordinate: endingCoordinate, title: endingLabel)
//        ]
//    }
//}


struct GateRouteView: View {
    let iataCode: String
    
    @State private var selectedStartingGate: String = ""
    @State private var selectedEndingGate: String = ""
    @State private var viewModel = AirportGatesViewModel()
    @StateObject private var walkingRouteViewModel = WalkingRouteViewModel()
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            HStack {
                Picker("Starting Gate", selection: $selectedStartingGate) {
                    ForEach(viewModel.gates, id: \.id) { gate in
                        Text(gate.number).tag(gate.number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Image(systemName: "arrowshape.right.fill")

                Picker("Ending Gate", selection: $selectedEndingGate) {
                    ForEach(viewModel.gates) { gate in
                        Text(gate.number).tag(gate.number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button("Show Route") {
                    walkingRouteViewModel.fetchGateRoute(iata: iataCode, fromGate: selectedStartingGate, toGate: selectedEndingGate)
                }
                .buttonStyle(.bordered)
                .padding()
            }
            HStack {
                if walkingRouteViewModel.time != 0 && walkingRouteViewModel.distance != 0.0 {
                    HStack {
                        Image(systemName: "figure.walk")
                        Text("\(walkingRouteViewModel.time) min").font(.title3).foregroundStyle(.green).bold()
                        Text("(\(String(format: "%.1f", walkingRouteViewModel.distance)) Km)").font(.title3).bold()
                        Spacer()
                    }
                    .padding([.leading, .trailing], 8.0)
                }
            }.padding()


            SatelliteMapView(region: $walkingRouteViewModel.region,
                             annotations: walkingRouteViewModel.mapAnnotations,
                             overlays: walkingRouteViewModel.mapOverlays)
                .ignoresSafeArea(.all)
        }
        .navigationTitle(iataCode)
        .task {
            isLoading = true
            await viewModel.loadGates(iataCode: iataCode) // Fetch gates when the view appears
            isLoading = false
            if let firstGate = viewModel.gates.first {
                selectedStartingGate = firstGate.number
                if viewModel.gates.count > 1 {
                    selectedEndingGate = viewModel.gates[1].number
                } else {
                    selectedEndingGate = firstGate.number
                }
                
            }
        }
    }
}
