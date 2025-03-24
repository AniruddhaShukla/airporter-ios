//
//  AirportDetailsSkinnyView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//


import SwiftUI

struct AirportDetailsSkinnyView: View {
    let airport: Airport
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Section(content: {
                    HStack {
                        Text(airport.iataCode).font(.largeTitle)
                        Text(airport.name).font(.headline)
                    }
                    Text("\(airport.city), \(airport.country)").font(.headline)
                }, header: {
                    if let website = airport.website {
                        LinkView(website: website, name: airport.name)
                            .frame(width: geometry.size.width, height: geometry.size.width / 2.3)
                            .clipped() // or .aspectRatio(16/9, contentMode: .fit) if you prefer
                    }
                })
                
                Section(content: {
                    NavigationLink(destination: {
                        LayoverPlanView(airport: airport)
                    }, label: {
                        HStack {
                            Image(systemName: "airplane.circle.fill")
                            Text("Generate Layover Plan")
                        }
                    })
                }, header: {
                    Text("Layover Plan")
                })
                
                Section(content: {
                    NavigationLink(destination: NearbyHotelsView(airport: airport)) {
                        HStack {
                            Image(systemName: "bed.double.circle.fill")
                            Text("Hotels")
                        }
                     }
                    
                    NavigationLink(destination: Text("Future of nearby resturants")) {
                        HStack {
                            Image(systemName: "fork.knife.circle.fill")
                            Text("Restaurants")
                        }
                     }
                }, header: {
                    Text("Nearby")
                })
            }
        }
    }
}


import SwiftUI

struct LayoverPlanView: View {
    let airport: Airport  // This model should at least include airport.iataCode and airport.name.
    
    @State var viewModel = LayoverPlanViewModel()
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Layover Duration (hours)")
                .font(.headline)
            
            Picker("Layover Hours", selection: $viewModel.layoverHours) {
                ForEach(1...48, id: \.self) { hour in
                    Text("\(hour) hrs").tag(hour)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)
            
            Button("Generate Layover Plan") {
                isLoading = true
                Task {
                    await viewModel.loadLayoverPlan(for: airport.iataCode)
                    isLoading = false
                }
            }
            .buttonStyle(.borderedProminent)
            
            if isLoading {
                ProgressView()
            } else if let plan = viewModel.layoverPlan {
                ScrollView {
                    if let attributed = try? AttributedString(markdown: plan.ai_recommendation) {
                        Text(attributed)
                    } else {
                        Text(plan.ai_recommendation)
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Layover Plan")
    }
}

import Foundation
import MapKit

@Observable
class LayoverPlanViewModel {
    // The user can change this value via the Picker.
    var layoverHours: Int = 4
    // This property will be set once the plan is fetched.
    var layoverPlan: LayoverPlanResponse?
    var errorMessage: String?
    
    // Computed property: if layoverHours is 24 or more, we treat it as overnight.
    var isOvernight: Bool {
        return layoverHours >= 24
    }
    
    private let service = LayoverPlanService()
    
    func loadLayoverPlan(for iataCode: String) async {
        do {
            let plan = try await service.fetchLayoverPlan(for: iataCode, layoverHours: layoverHours, isOvernight: isOvernight)
            self.layoverPlan = plan
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
import Foundation

struct LayoverPlanResponse: Decodable {
    let airport: String
    let layover_hours: Int
    let overnight: Bool
    let ai_recommendation: String
    let nearby_hotels: [Hotel] // Assuming you have a Hotel model defined elsewhere.
}

class LayoverPlanService {
    private let baseURL = "https://hammerhead-app-o95ou.ondigitalocean.app"
    
    func fetchLayoverPlan(for iataCode: String, layoverHours: Int, isOvernight: Bool) async throws -> LayoverPlanResponse {
        guard let url = URL(string: "\(baseURL)/airports/\(iataCode)/layover-plan-with-gates?layover_hours=\(layoverHours)&is_overnight=\(isOvernight)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(LayoverPlanResponse.self, from: data)
    }
}
