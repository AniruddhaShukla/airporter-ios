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
                NavigationLink(destination: NearbyHotelsView(iataCode: airport.iataCode)) {
                     Text("Hotels")
                 }
                
                NavigationLink(destination: Text("Future of nearby resturants")) {
                     Text("Restaurants")
                 }
            }, header: {
                Text("Nearby")
            })
        }
    }
}

