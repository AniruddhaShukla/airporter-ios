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
        List {
            Section {
                HStack {
                    Text(airport.iataCode).font(.headline)
                    Text(airport.name).font(.headline)
                }
                Text(airport.city).font(.subheadline)
            }
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

