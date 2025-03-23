//
//  CallButton.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI

struct CallButton: View {
    let phoneNumber: String
    
    @Environment(\.openURL) private var openURL

    var body: some View {
        HStack {
            Image(systemName: "phone.circle.fill").font(.headline)
            Text("Call").font(.headline)
        }
        .foregroundStyle(.accent)
        .onTapGesture {
            if let url = URL(string: "tel://\(phoneNumber)") {
                openURL(url)
            }
        }
    }
}
