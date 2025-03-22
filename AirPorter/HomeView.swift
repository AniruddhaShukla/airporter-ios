//
//  HomeView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/18/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = AirportViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.airports) { airport in
                NavigationLink(destination: AirportDetailsSkinnyView(airport: airport)) {
                    VStack(alignment: .leading) {
                        Text(airport.name)
                            .font(.headline)
                        Text("\(airport.city), \(airport.country)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Search Airports")
            .searchable(text: $viewModel.searchText, prompt: "Enter airport code or city")
        }
    }
}
