//
//  LinkView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI
import LinkPresentation

struct LinkView: View {
    let website: String
    let name: String
    @StateObject private var viewModel = LinkMetadataViewModel()

    var body: some View {
        ZStack {
            if viewModel.isFetching {
                Color.accentColor
            } else if let metadata = viewModel.metadata {
                LinkMetadataView(metadata: metadata)
            } else {
                // Fallback placeholder
                Color.accentColor
                    .overlay {
                        HStack {
                            Image(systemName: "bed.double.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text(name)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal, 4)
                        }
                    }
            }
        }
        .onAppear {
            viewModel.fetchMetadata(for: website)
        }
    }
}
