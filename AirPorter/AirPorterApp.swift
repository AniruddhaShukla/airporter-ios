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
            HomeView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings Content")
                .navigationTitle("Settings")
        }
    }
}
