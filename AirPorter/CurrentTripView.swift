//
//  CurrentTripView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/25/25.
//

import SwiftUI


struct CurrentTripView: View {
    @State private var flightStatus: FlightStatus?
    @State private var errorMessage: String?
    
    var flightNumber = "UA519"
    var flightDate = "2025-03-25"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                flightStatusView()
                if let flightStatus = flightStatus {
                    Section(content: {

                        NavigationLink(destination: GateDetailView(iataCode: flightStatus.origin.codeIata!)) {
                            Text("Departure Gate \(flightStatus.gateOrigin ?? "N/A")")
                        }
                    }, header: {
                        Text("Departure Gate")
                    })
                    
                    Section(content: {
                        NavigationLink(destination: GateDetailView(iataCode: flightStatus.destination.codeIata!)) {
                            Text("Tenative Arrival Gate \(flightStatus.gateDestination ?? "N/A")")
                        }
                    }, header: {
                        Text("Arrival Gate")
                    })
                }

            }
            .navigationTitle("Current Trip")
            .navigationBarTitleDisplayMode(.inline)
        }



    }
    
    @ViewBuilder
    func flightStatusView() -> some View {
        Section {
            VStack(spacing: 20) {
                if let status = flightStatus {
//                            Text("Flight \(status.ident)")
//                                .font(.title2)
//                                .bold()
                    
                    Text(status.status)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                    
                    // Progress View
                    VStack {
                        HStack {
                            VStack {
                                Text(status.origin.codeIata ?? status.origin.code)
                                    .font(.title3).bold()
                                Text(status.origin.city ?? "").font(.caption)
                            }
                            Spacer()
                            VStack {
                                Text(status.destination.codeIata ?? status.destination.code)
                                    .font(.title3).bold()
                                Text(status.destination.city ?? "").font(.caption)
                            }
                        }
                        .padding(.horizontal)
                        
                        // New gate information
                        HStack {
                            VStack(spacing: 2) {
                                if let terminalOrigin = status.terminalOrigin {
                                    Text("Terminal \(terminalOrigin)")
                                        .font(.caption2)
                                }
                                if let gateOrigin = status.gateOrigin {
                                    Text("Gate \(gateOrigin)")
                                        .font(.caption2)
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 2) {
                                if let terminalDestination = status.terminalDestination {
                                    Text("Terminal \(terminalDestination)")
                                        .font(.caption2)
                                }
                                if let gateDestination = status.gateDestination {
                                    Text("Gate \(gateDestination)")
                                        .font(.caption2)
                                        .bold()
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .frame(height: 6)
                                    .foregroundColor(Color.gray.opacity(0.3))
                                
                                Capsule()
                                    .frame(width: geometry.size.width * CGFloat(status.progressPercent) / 100, height: 6)
                                    .foregroundColor(.accentColor)
                                
                                Image(systemName: "airplane")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.primary)
                                    .offset(x: geometry.size.width * CGFloat(status.progressPercent) / 100 - 12, y: -1)
                            }
                        }
                        .frame(height: 30)
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    .padding(.horizontal)
                    
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ProgressView("Fetching flight info...")
                }
                Spacer()
            }
            .frame(width: 500)
            .task {
                await loadFlightData()
            }
        }
    }
    private func loadFlightData() async {
        do {
            flightStatus = try await FlightTrackingService.shared.fetchFlightStatus(flightNumber: flightNumber, date: flightDate)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}


import Foundation

class FlightTrackingService {
    static let shared = FlightTrackingService()
    
    private let baseURL = URL(string: "http://127.0.0.1:8000/airports/")! // Update your URL as needed
    
    func fetchFlightStatus(flightNumber: String, date: String) async throws -> FlightStatus {
        let endpoint = baseURL.appending(path: "track/flight/\(flightNumber)/\(date)")
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(FlightStatus.self, from: data)
    }
}


struct FlightStatus: Codable {
    let ident: String
    let identIcao: String?
    let identIata: String?
    let actualRunwayOff: String?
    let actualRunwayOn: String?
    let faFlightId: String?
    let operatorCode: String?
    let operatorIcao: String?
    let operatorIata: String?
    let flightNumber: String?
    let registration: String?
    let codeshares: [String]?
    let origin: AirportDetail
    let destination: AirportDetail
    let progressPercent: Int
    let status: String
    let aircraftType: String?
    
    let terminalOrigin: String?
    let gateOrigin: String?
    
    let terminalDestination: String?
    let gateDestination: String?
    
    
    enum CodingKeys: String, CodingKey {
        case ident
        case identIcao = "ident_icao"
        case identIata = "ident_iata"
        case actualRunwayOff = "actual_runway_off"
        case actualRunwayOn = "actual_runway_on"
        case faFlightId = "fa_flight_id"
        case operatorCode = "operator"
        case operatorIcao = "operator_icao"
        case operatorIata = "operator_iata"
        case flightNumber = "flight_number"
        case registration
        case codeshares
        case origin
        case destination
        case progressPercent = "progress_percent"
        case status
        case aircraftType = "aircraft_type"
        case terminalOrigin = "terminal_origin"
        case gateOrigin = "gate_origin"
        case terminalDestination = "terminal_destination"
        case gateDestination = "gate_destination"
    }
}

struct AirportDetail: Codable {
    let code: String
    let codeIcao: String?
    let codeIata: String?
    let timezone: String?
    let name: String?
    let city: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case codeIcao = "code_icao"
        case codeIata = "code_iata"
        case timezone
        case name
        case city
    }
}

struct GateDetailView: View {
    let iataCode: String
    //@ObservedObject var viewModel: GateDetailViewModel
    
    var body: some View {
        VStack {
            Text("Gate Detail")
        }.onAppear {
            // Load gate on the map and display amenities near
        }
    }
}

