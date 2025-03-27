//
//  AirPorterApp.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import SwiftUI

@main
struct AirPorterApp: App {
    var body: some Scene {
        WindowGroup {
            TabView(content: {
//                CurrentTripView()
//                    .tabItem {
//                        Image(systemName: "airplane")
//                        Text("Current Trip")
//                    }
                ExploreView()
                    .tabItem {
                        Image(systemName: "globe")
                        Text("Explore Airports")
                    }
                
                UpcomingTripsView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Upcoming Flights")
                    }
                
            })
            
        }
    }
}

struct UpcomingTripsView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("No Upcoming Trips").font(.title3).bold()
                Text("Start by adding flights for your trip.").foregroundStyle(.secondary).font(.subheadline)
            }
            .toolbar(content: {
                Button(action: {
                    print("Add new flight flow.")
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .navigationTitle("Upcoming Flights")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}


struct TrackView: View {
        
    let flightNumber = "UAL519"
    var website: String {
        return "https://www.flightaware.com/live/flight/\(flightNumber)"
    }
    
    var body: some View {
        VStack {
            LinkView(website: website, name: "\(flightNumber)")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {}
        NavigationView {
            Text("Settings Content")
                .navigationTitle("Settings")
        }
    }
}
