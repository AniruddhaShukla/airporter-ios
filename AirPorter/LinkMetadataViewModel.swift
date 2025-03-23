//
//  LinkMetadataViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/23/25.
//

import Foundation
import LinkPresentation

class LinkMetadataViewModel: ObservableObject {
    @Published var metadata: LPLinkMetadata? = nil
    @Published var error: Error? = nil
    @Published var isFetching: Bool = false

    private var isCancelled = false
    private var currentProvider: LPMetadataProvider?

    func fetchMetadata(for urlString: String) {
        cancelCurrentTask()

        guard let url = URL(string: urlString) else {
            self.error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            return
        }
        
        isFetching = true
        isCancelled = false
        let provider = LPMetadataProvider()
        currentProvider = provider

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            provider.startFetchingMetadata(for: url) { metadata, error in
                DispatchQueue.main.async {
                    guard !self.isCancelled else { return }

                    if let error = error {
                        self.error = error
                        print("Error fetching metadata: \(error.localizedDescription)")
                        if let lpError = error as? LPError {
                            print("LPError code: \(lpError.code.rawValue)")
                        }
                    } else {
                        self.metadata = metadata
                    }
                    self.isFetching = false
                    self.currentProvider = nil
                }
            }
        }
    }

    func cancelCurrentTask() {
        isCancelled = true
        currentProvider = nil
        DispatchQueue.main.async {
            self.metadata = nil
            self.error = nil
        }
    }
}
