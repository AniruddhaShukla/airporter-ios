//
//  AirPorterApp.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


import SwiftUI
import FirebaseCore

@main
struct AirPorterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isUserLoggedIn {
                // User is signed in, show the main content
                TabView {
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
                }
            } else {
                // User is not signed in, show the login view
                LoginView()
            }
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
