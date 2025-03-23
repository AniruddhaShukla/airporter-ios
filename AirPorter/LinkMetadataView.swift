//
//  LinkMetadataView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import SwiftUI
import LinkPresentation

struct LinkMetadataView: UIViewRepresentable {
    let metadata: LPLinkMetadata

    func makeUIView(context: Context) -> LPLinkView {
        LPLinkView(metadata: metadata)
    }

    func updateUIView(_ uiView: LPLinkView, context: Context) {
        uiView.metadata = metadata
        uiView.sizeToFit()  // Force the LPLinkView to measure itself
    }
}
